class Book < ApplicationRecord
  validates :title, :author, :genre, presence: true
end
