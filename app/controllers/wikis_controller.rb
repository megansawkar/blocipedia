class WikisController < ApplicationController

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user

    if @wiki.save
      flash[:notice] = "Wiki was saved successfully"
      redirect_to [@wiki]
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      redirect_to root_path
    end
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)

    if @wiki.save
      flash[:notice] = "Wiki was updated successfully."
      redirect_to root_path
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      redirect_to root path
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to root_path
    else
      flash.now[:alert] = "There was an error deleting the post."
      redirect_to root_path
    end 
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
