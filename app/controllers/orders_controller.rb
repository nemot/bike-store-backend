class OrdersController < ApplicationController
  def add_product_to_cart
    cart_order
  end

  def remove_product_from_cart
    cart_order
  end

  private
  # lets' stub for now,
  # In reality we must differentiate guests form logged users
  def current_user
    User.first_or_create(name: "Guest", address: "Some Shipping address", email: "some@email.com")
  end

  def cart_order
    @cart_order ||= Order.for_user(current_user).cart.first_or_create
  end
end
