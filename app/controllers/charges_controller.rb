class ChargesController < ApplicationController
  before_filter :authenticate_user!

  def create
    # Creates a Stripe Customer object, for associating with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
      )

    charge = Stripe::Charge.create(
    customer: customer.id, # Note -- this is NOT the user_id in the app
    amount: Amount.default,
    description: "Premium Membership - #{current_user.email}",
    currency: 'usd'
    )

    flash[:notice] = "Thanks for upgrading to a Premium account #{current_user.email}!"
    current_user.update_attribute(:role, 'premium')
    redirect_to user_path(current_user)

    rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to new_charge_path
  end

  def new
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Premium Membership - #{current_user.username}",
      amount: Amount.default
    }
  end

#  def downgrade
#    current_user.update_attribute(:role, 'standard')
#    flash[:notice] = "We hope you enjoyed your Premium experience #{current_user.email}! If you'd like to provide feedback, please send a note to test@feedback.com."
#    redirect_to user_path(current_user)
#  end

end
