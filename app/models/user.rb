class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # フォローされている側のUserから見て、フォローしてくる側のUserを(中間テーブルを介して)集める。参照するカラムは’followee_id’(フォローされる側)
  has_many :reverse_of_relationships, class_name: "Relationship",foreign_key: "followed_id",dependent: :destroy
  #一覧画面で使う中間テーブル(relationships)を介して「user」モデルのUser(フォローする側)「follower_id」を集めることを「followers」と定義
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # フォローしている側のUserから見て、フォローされている側のUserを(中間テーブルを介して)集める。参照するカラムは 'follower_id(フォローする側)
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  #一覧画面で使う中間テーブル(relationships)を介して「followee」モデルのUser(フォローされた側)「follow_id」を集めることを「followings」と定義
  has_many :followings, through: :relationships, source: :followed

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def self.search(method,word)
   if method == "forward_match"
      @users = User.where("name LIKE?","#{word}%")
   elsif method == "backward_match"
      @users = User.where("name LIKE?","%#{word}")
   elsif method == "perfect_match"
      @users = User.where("name LIKE?","#{word}")
   elsif method == "partial_match"
      @users = User.where("name LIKE?","%#{word}%")
   else
       @users = User.all
   end
  end
end
