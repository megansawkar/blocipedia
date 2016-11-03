class Wiki < ActiveRecord::Base
  belongs_to :user

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 5 }, presence: true

  default_scope { order('updated_at ASC') }

  scope :visible_to, -> (user) { user ? all : where(private: false) }
end
