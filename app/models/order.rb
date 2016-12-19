class Order < ActiveRecord::Base
  has_one :shipment
  has_and_belongs_to_many :upcs
  belongs_to :warehouse

  def add_upc(name)
    upc = Upc.find_by(name: name)
    upcs << upc
  end

  def inventory_required_to_fulfill
    upcs.map(&:name).each_with_object(Hash.new(0)) do |name, counts|
      counts[name] += 1
    end
  end

  def assign_to_warehouse
    w = Warehouse.find_by_inventory(inventory_required_to_fulfill)
    self.update!(warehouse: w)
  end

end
