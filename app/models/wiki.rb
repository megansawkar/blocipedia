class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :collaborations, dependent: :destroy
  has_many :users, through: :collaborations

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 5 }, presence: true

  default_scope { order('updated_at DESC') }

  after_update :delete_collaborations

  #  scope :visible_to, -> (user) { user ? all : where(private: false) }

  private

  def delete_collaborations
    return unless self.private == false

    self.collaborations.delete_all
  end
end
