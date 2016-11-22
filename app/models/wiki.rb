class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :collaborations
  has_many :collaborated_users, through: :collaborations, source: :user 

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 5 }, presence: true

  default_scope { order('updated_at DESC') }

  scope :visible_to, -> (user) { user ? all : where(private: false) }

#  def collaboration

#  end
end
