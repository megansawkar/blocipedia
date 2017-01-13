class WikisController < ApplicationController
  include Pundit

  before_action :authenticate_user!, except: [:index, :show]

  #  after_action :verify_authorized, except: :index
  #  after_action :verify_policy_scoped, only: :index

  def index
    @wikis = policy_scope(Wiki)
    authorize @wiki
  end

  def show
    @wiki = Wiki.find(params[:id])
    @user = current_user
    authorize @wiki
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    authorize @wiki

    if @wiki.save
      flash[:notice] = "Wiki was saved successfully"
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error saving the Wiki. Please try again."
      render :new
    end
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def edit
    @user = current_user
    @users = User.all
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)
    authorize @wiki

    if @wiki.save
      flash[:notice] = "Wiki was updated successfully."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    # title = @wiki.title

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to wikis_path
    else
      flash.now[:alert] = "There was an error deleting the post."
      render :show
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
