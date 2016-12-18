class Warehouse < ActiveRecord::Base
  has_many :shipments
  has_many :products, as: :allocator
end
