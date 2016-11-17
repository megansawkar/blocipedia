class UsersController < ApplicationController

  def show
    @user = current_user
  end

  def downgrade
    flash[:notice] = "You have successfully downgraded your account. Your Private Wikis will be made Public."
    current_user.update_attribute(:role, 'standard')
    redirect_to wikis_path
  end
end
