class ChargesController < ApplicationController
  before_filter :authenticate_user!

  def create
    #@amount = 15_00
    # Creates a Stripe Customer object, for associating with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
      )

    current_user.stripeid = customer.id
    current_user.save
    current_user.update_attribute(:role, 'premium')

    charge = Stripe::Charge.create(
    customer: customer.id, # Note -- this is NOT the user_id in the app
    amount: Amount.default,
    description: "Premium Membership - #{current_user.email}",
    currency: 'usd'
    )

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

  def destroy
  #  @stripe_btn_data = {
  #    key: "#{ Rails.configuration.stripe[:publishable_key] }",
  #  }

    customer = Stripe::Customer.retrieve({CUSTOMER_ID})
    card = customer.cards.retrieve({CARD_ID})
    card.delete
    customer.delete(:at_period_end => true)

    current_user.save
    current_user.update_attribute(:role, 'standard')

    flash[:notice] = "We hope you enjoyed your Premium experience #{current_user.email}! If you'd like to provide feedback, please send a note to test@feedback.com."
    redirect_to user_path(current_user)
  end

end
