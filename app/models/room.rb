class Room < ApplicationRecord
 has_many :messages
 has_many :user_rooms
end
