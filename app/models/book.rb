class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.search(method,word)
   if method == "forward"
      @books = Book.where("title LIKE?","#{word}%")
   elsif method == "backward"
      @books = Book.where("title LIKE?","%#{word}")
   elsif method == "perfect"
      @books = Book.where("title LIKE?","#{word}")
   elsif method == "partial"
      @books = Book.where("title LIKE?","%#{word}%")
   else
       @books = Book.all
   end
  end
end

