class CollaborationPolicy < ApplicationPolicy
  attr_reader :user, :wiki

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def create?
    collaboration_show?
  end

  def destroy?
    collaboration_show?
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

  private

  def collaboration_show?
    user.present? && (user.admin? || user.owner_of_wiki?(wiki.wiki))
    #user.id == wiki.user_id || user.admin?
    #user.owner_of_wiki?(wiki) || user.admin?
  end
end
