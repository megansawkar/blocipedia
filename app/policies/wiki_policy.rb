class WikiPolicy < ApplicationPolicy
  class Scope < WikiPolicy
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.present?
        @scope.all
      else
        @scope.where(private: false)
      end
    end
  end

  attr_reader :user, :wiki

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def index
    true
  end

  def show?
    true 
  end

  def create?
    user.present?
  end

  def update?
    user.present?
  end

  def edit?
    user.present?
  end

  def destroy?
    user.admin? || user.owner_of(@wiki)
  end
end
