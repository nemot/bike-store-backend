class Order < ApplicationRecord
  include AASM

  belongs_to :user, optional: true
  has_many :line_items, as: :holder
  has_many :products, through: :line_items

  scope :for_user, ->(user) { where(user:) }

  include RuleSubject
  ruleable_as "order", %w[line_items]

  aasm(column: :status) do
    state :cart, initial: true
    state :paid
    state :sent

    event :pay do
      transitions from: :cart, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :sent
    end
  end
end
