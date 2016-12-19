class Shipment < ActiveRecord::Base
  belongs_to :warehouse
  has_many :products, as: :allocator
  belongs_to :order
end
