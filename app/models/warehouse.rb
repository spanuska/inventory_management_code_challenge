class Warehouse < ActiveRecord::Base
  has_many :orders
  has_many :shipments
  has_many :products, as: :allocator

  def self.find_by_inventory(inventory_hash)
    # inventory_hash example: { "mattress" => 3, "pillow" => 2, "sheet set" => 0 }
    find do |warehouse|
      w_inventory = warehouse.inventory
      inventory_hash.all? do |upc_name, quantity|
        w_inventory[upc_name].present? && w_inventory[upc_name] >= quantity
      end
    end
  end

  def inventory
    Upc.all.inject({}) do |hash, upc|
      hash[upc.name] = Product.where(allocator: self, upc: upc).count
      hash
    end
  end

  def create_shipment(order)
    inventory_hash = order.inventory_required_to_fulfill
    shipment = Shipment.new(warehouse: self)
    inventory_hash.map do |upc_name, quantity|
      products_to_ship = find_products_by_upc_name(upc_name, quantity)
      products_to_ship.each { |product| product.update!(allocator: shipment) }
    end
  end

  private

  def find_products_by_upc_name(upc_name, quantity=1)
    upc = Upc.find_by(name: upc_name)
    products.where(upc: upc).first(quantity)
  end

end