class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites
  has_many :books_comments, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.search(search, word)
    @book = if search == 'forward_match'
              Book.where('title LIKE?', "#{word}%")
            elsif search == 'backward_match'
              Book.where('title LIKE?', "%#{word}")
            elsif search == 'perfect_match'
              Book.where(word.to_s)
            elsif search == 'partial_match'
              Book.where('title LIKE?', "%#{word}%")
            else
              Book.all
            end
  end
end
