class WikiPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :wiki

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        @scope.where(published: true)
      end
    end
  end


  def destroy?
    user.admin? || user.owner_of?(wiki)
  end
end
