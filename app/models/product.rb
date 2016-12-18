class Product < ActiveRecord::Base
  belongs_to :allocator, polymorphic: true
end
