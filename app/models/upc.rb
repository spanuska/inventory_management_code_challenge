class Upc < ActiveRecord::Base
  has_many :products
  has_and_belongs_to_many :orders
end
