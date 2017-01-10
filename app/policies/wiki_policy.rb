class WikiPolicy < ApplicationPolicy
  attr_reader :user, :wiki

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def index
    wiki_show?
  end

  def new
    user.present?
  end

  def show?
    wiki_show?
  end

  def create?
    user.present?
  end

  def update?
    user.present? && wiki_show?
  end

  def edit?
    user.present? && wiki_show?
  end

  def destroy?
    user.present? && (user.admin? || user.owner_of_wiki?(wiki))
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve # rubocop:disable CyclomaticComplexity, PerceivedComplexity, Metrics/AbcSize, MethodLength
      wikis = []
      if user.present? && user.role == 'admin'
        wikis = scope.all # if the user is an admin, show them all the wikis
      elsif user.present? && user.role == 'premium'
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.user == user || wiki.users.include?(user)
            wikis << wiki # if the user is premium, only show them public wikis,
            # or that private wikis they created, or private wikis they are a collaborator on
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

  private

  def wiki_show?
    wiki.private == false ||
      user.owner_of_wiki?(wiki) ||
      user.admin? ||
      wiki.users.include?(user)
  end
end
