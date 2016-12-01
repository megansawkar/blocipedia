class CollaborationPolicy < ApplicationPolicy

  attr_reader :user, :wiki

  def create?
    current_user.id == wiki.user_id || current_user.admin?
  end

  def destroy?
    current_user.owner_of(@wiki) || current_user.admin?
  end

  class Scope < Scope
    attr_reader :user, :scope

    def initialize
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
