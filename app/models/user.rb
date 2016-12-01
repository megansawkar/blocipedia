class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  has_many :wikis, dependent: :destroy
  has_many :collaborations, dependent: :destroy 

  after_initialize :init
  after_update :downgrade_wikis

  validates :username, :presence => true, :uniqueness => { :case_sensitive => false }

  attr_accessor :login

  enum role: [:standard, :premium, :admin]

  def admin?
    role == 'admin'
  end

  def premium?
    role == 'premium'
  end

  def standard?
    role == 'standard'
  end

  def owner_of(wiki)
    wiki.user
  end

  def avatar_url(size)
    gravatar_id = Digest::MD5::hexdigest(self.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_h).first
    end
  end

  private

  def init
    if self.new_record? && self.role.nil?
      self.role = 'standard'
    end
  end

  def downgrade_wikis
    return unless self.role_changed?(from: 'premium', to: 'standard')
    wikis.update_all private: false
  end
end
