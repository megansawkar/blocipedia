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

  def update
  end

  def destroy
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :user_id, :private)
  end 
end
