class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 自分がフォローしているユーザーとの関連
  # フォローする側のUserから見て、フォローされる側のUserを(中間テーブルを介して)集める。なので親はfollowed_id(フォローする側)
  has_many :active_relationships, class_name: 'Relationship', foreign_key: :followed_id
  # 中間テーブルを介して「follower」モデルのUser(フォローされた側)を集めることを「followings」と定義
  has_many :follows, through: :active_relationships, source: :follower

  # 自分がフォローされるユーザーとの関連
  # フォローされる側のUserから見て、フォローしてくる側のUserを(中間テーブルを介して)集める。なので親はfollower_id(フォローされる側)
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: :follower_id
  # 中間テーブルを介して「following」モデルのUser(フォローする側)を集めることを「followers」と定義
  has_many :followers, through: :passive_relationships, source: :followed

  def followed_by?(user)
    # 今自分(引数のuser)がフォローしようとしているユーザー(レシーバー)がフォローされているユーザー(つまりpassive)の中から、引数に渡されたユーザー(自分)がいるかどうかを調べる
    passive_relationships.find_by(followed_id: user.id).present?
  end

  has_many :books, dependent: :destroy # booksと紐付け
  has_many :favorites # favと紐付け
  has_many :books_comments, dependent: :destroy
  attachment :profile_image
  validates :name, uniqueness: true, presence: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }

  def self.search(search, word)
    @user = if search == 'forward_match'
              User.where('name LIKE?', "#{word}%")
            elsif search == 'backward_match'
              User.where('name LIKE?', "%#{word}")
            elsif search == 'perfect_match'
              User.where(word.to_s)
            elsif search == 'partial_match'
              User.where('name LIKE?', "%#{word}%")
            else
              User.all
            end
  end
  
  include JpPrefecture
  jp_prefecture :prefecture_code
  
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end
  
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
end
