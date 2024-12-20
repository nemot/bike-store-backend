module Orders
  class AddProductService < ServiceObject
    attribute :order, Types.Instance(Order)
    attribute :product, Types.Instance(Product)
    attribute :quantity, Types::Strict::Integer

    def call
      return Failure([ "Order is already paid" ]) unless order.cart?

      Order.transaction(require_new: true) do
        add_product
        reset_line_items_prices
        apply_rules
        Success(order)
      end
    rescue StandardError
      Failure(error)
    end


    private

    def create_line_item
      order.line_items.where(product:).first_or_create.tap do |li|
        li.update(quantity: li.quantity + quantity)
      end
    end

    def reset_line_items_prices
      order.line_items.includes(:product).each do |li|
        li.update(price: li.product&.price * li.quantity)
      end
    end

    def apply_rules
      order.rules.each do |rule|
        Rules::ApplicatorService.call(rule:, instance: order)
      end
    end
  end
end
