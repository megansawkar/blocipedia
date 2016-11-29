class CollaborationsController < ApplicationController
  def create
    @wiki = Wiki.find(params[:wiki_id])
    @collaboration = Collaboration.new(user_id: params[:user_id], wiki_id: params[:wiki_id])

    if @collaboration.save
        flash[:notice] = "Collaborator successfully added to Wiki."
        redirect_to @wiki
    else
        flash[:error] = "There was a problem adding the collaborator. Please try again."
        render :new
    end
  end


  def destroy
    @wiki = Wiki.find(params[:wiki_id])
    @collaboration = Collaboration.new(user_id: params[:user_id], wiki_id: params[:wiki_id])

    if @collaboration.destroy
      flash[:notice] = "Collaborator removed from wiki."
      redirect_to @wiki
    else
      flash[:error] = "There was an error deleting the collaborator. Please try again."
    end
  end

end
