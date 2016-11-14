class UsersController < ApplicationController

  def show
    @user = current_user
  end

  def downgrade
    current_user.update_attribute(:role, 'standard')
    flash[:notice] = "We hope you enjoyed your Premium experience #{current_user.email}! If you'd like to provide feedback, please send a note to test@feedback.com."
    redirect_to user_path(current_user)
  end
end
