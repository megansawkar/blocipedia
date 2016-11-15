class UsersController < ApplicationController

  def show
    @user = current_user
  end

  def downgrade
    flash[:notice] = "You have successfully downgraded your account. Your Private Wikis will be made Public."
    current_user.update_attribute(:role, 'standard')

    wikis = Wiki.all
    wikis.each do |wiki|
      if wiki.private == true
        wiki.update_attributes(private: false)
      end
    end
    redirect_to wikis_path #user_path(current_user)
  end
end
