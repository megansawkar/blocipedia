class ChargesController < ApplicationController
  def create
    #@amount = 15_00
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

    current_user.update_attribute(:role, 'premium')

    flash[:notice] = "Thanks for upgrading to a Premium account #{current_user.email}!"
    redirect_to user_path(current_user)

    rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to new_charge_path
  end

  def new
    #@amount = 15_00
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Premium Membership - #{current_user.username}",
      amount: Amount.default
    }
  end

  def downgrade

    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
    }

    customer = Stripe::Customer.retrieve("CUSTOMER_ID")
    subscription = customer.subscriptions.retrieve("SUBSCRIPTION_ID")
    subscription.delete(:at_period_end => true)
    current_user.update_attribute(:role, 'standard')
  end

end
