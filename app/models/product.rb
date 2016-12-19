class Product < ActiveRecord::Base
  belongs_to :allocator, polymorphic: true
  belongs_to :upc
end
