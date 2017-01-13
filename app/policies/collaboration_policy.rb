class CollaborationPolicy < ApplicationPolicy
  attr_reader :user, :wiki

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def create?
    collaboration_create?
  end

  def destroy?
    collaboration_destroy?
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

  def collaboration_create?
    user.admin? || user.owner_of_wiki?(wiki.wiki)
  end

  def collaboration_destroy?
    user.present? && (user.admin? || user.owner_of_wiki?(wiki.wiki))
    # user.id == wiki.user_id || user.admin?
    # user.owner_of_wiki?(wiki) || user.admin?
  end
end
