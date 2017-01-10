class ChargesController < ApplicationController
  before_action :authenticate_user!

  attr_accessor :customer

  def create # rubocop:disable Metrics/AbcSize, MethodLength
    # customer = Stripe::Customer.create(email: current_user.email, card: params[:stripeToken])

    Stripe::Charge.create(
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
      # key: "#{Rails.configuration.stripe[:publishable_key]}",
      key: Rails.configuration.stripe[:publishable_key].to_s,
      description: "Premium Membership - #{current_user.username}",
      amount: Amount.default
    }
  end

  private

  def customer
    Stripe::Customer.create(email: current_user.email, card: params[:stripeToken])
  end
end
