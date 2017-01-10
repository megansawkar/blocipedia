class CollaborationsController < ApplicationController
  include Pundit

  before_action :authenticate_user!
  before_action :wiki_find, only: :create
  before_action :user_find, only: :create

  def create # rubocop:disable MethodLength
    if @user
      @collaboration = Collaboration.new(wiki_id: params[:wiki_id], user_id: @user.id)
      authorize @collaboration

      if @collaboration.save
        flash[:notice] = "Collaborator successfully added to Wiki."
        redirect_to @wiki
      else
        flash[:error] = "There was a problem adding the collaborator. Please try again."
        render :show
      end
    else
      flash[:error] = "The username is invalid. Please try again."
      render :show
    end
  end

  def destroy
    #  @wiki = Wiki.find(params[:wiki_id])
    @collaboration = Collaboration.find(params[:id])
    authorize @collaboration

    if @collaboration.destroy
      flash[:notice] = "Collaborator removed from wiki."
      redirect_to @wiki
    else
      flash[:error] = "There was an error deleting the collaborator. Please try again."
    end
  end

  private

  def wiki_find
    @wiki = Wiki.find(params[:wiki_id])
  end

  def user_find
    @user = User.find_by(username: params[:search])
  end
end
