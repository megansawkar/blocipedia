class WikiPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      wikis = []
      if user.role == 'admin'
        wikis = scope.all # if the user is an admin, show them all the wikis
      elsif user.role == 'premium'
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.user == user || wiki.users.include?(user)
            wikis << wiki # if the user is premium, only show them public wikis, or that private wikis they created, or private wikis they are a collaborator on
          end
        end
      else # this is the lowly standard user
        all_wikis = scope.all
        wikis = []
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.users.include?(user)
            wikis << wiki # only show standard users public wikis and private wikis they are a collaborator on
          end
        end
      end
      wikis # return the wikis array we've built up
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
    !wiki.private? || user.present? && (wiki.user == user || user.admin? || user.premium? || wiki.users.include?(user))
  end

  def create?
    !wiki.private? && (user.present?) || wiki.private? && (user.admin? || user.premium?)
  end

  def update?
    user.present?
  end

  def edit?
    !wiki.private? && (user.present?) || wiki.private? && (user.admin? || wiki.user || wiki.users.include?(user))
  end

  def destroy?
    !wiki.private? && (user.admin? || wiki.user) || wiki.private? && (user.admin? || wiki.user) 
  end
end
