class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  def self.from_cart_item(cart_item)
    line_item = self.new
    line_item.product = cart_item.product
    line_item.quantity = cart_item.quantity
    line_item.total_price = cart_item.price
    line_item
  end
end