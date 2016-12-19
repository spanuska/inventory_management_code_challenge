require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  subject(:subject) { Warehouse.create! }
  let!(:mattress_upc) { Upc.create!(name: "mattress", code: 1) }
  let!(:mattress_product1) { Product.create!(upc: mattress_upc, allocator: subject) }
  let!(:mattress_product2) { Product.create!(upc: mattress_upc, allocator: subject) }
  let!(:mattress_product3) { Product.create!(upc: mattress_upc, allocator: subject) }
  let!(:pillow_upc) { Upc.create!(name: "pillow", code: 2) }
  let!(:pillow_product1) { Product.create!(upc: pillow_upc, allocator: subject) }
  let!(:pillow_product2) { Product.create!(upc: pillow_upc, allocator: subject) }
  let!(:sheet_set_upc) { Upc.create!(name: "sheet set", code: 3) }

  describe '#inventory' do
    let!(:empty_warehouse) { Warehouse.create! }

    it 'returns a hash with all UPC names as keys, and their counts in the warehouse as values' do

      expect(subject.inventory).to eq({ "mattress" => 3, "pillow" => 2, "sheet set" => 0 })
      expect(empty_warehouse.inventory).to eq({ "mattress" => 0, "pillow" => 0, "sheet set" => 0 })
    end
  end

  describe '::find_by_inventory' do
    context 'when there is a warehouse that can fulfill the requested inventory' do
        it 'returns the first warehouse instance with inventory more than or equal to the given parameters' do
          equally_full_warehouse = Warehouse.create!
          Product.create!(upc: mattress_upc, allocator: equally_full_warehouse)
          Product.create!(upc: mattress_upc, allocator: equally_full_warehouse)
          Product.create!(upc: mattress_upc, allocator: equally_full_warehouse)
          Product.create!(upc: pillow_upc, allocator: equally_full_warehouse)
          Product.create!(upc: pillow_upc, allocator: equally_full_warehouse)

          expect(Warehouse.find_by_inventory({ "mattress" => 3 })).to eq subject
          expect(Warehouse.find_by_inventory({ "mattress" => 3 })).to_not eq equally_full_warehouse
          expect(Warehouse.find_by_inventory({ "mattress" => 3, "pillow" => 2 })).to eq subject
        end
    end

    context 'when there is no warehouse to fulfill the requested inventory' do
      it 'returns nil' do

        expect(Warehouse.find_by_inventory({ "mattress" => 8 })).to be_nil
        expect(Warehouse.find_by_inventory({"bananas" => 8})).to be_nil
      end
    end
  end

  describe '#create_shipment' do
    context 'when there is sufficient inventory to create a shipment' do
      let!(:order) { Order.create! }

      before(:each) do
        order.upcs << mattress_upc << mattress_upc
      end

      it 'creates a new shipment ' do
        pre_shipment_creation_warehouse_shipments = subject.shipments.count
        subject.create_shipment(order)

        expect(subject.shipments.count).to eq pre_shipment_creation_warehouse_shipments + 1
      end

      it 'reduces the inventory of the given product by the given amount' do
        pre_shipment_creation_mattress_inventory = subject.inventory["mattress"]
        subject.create_shipment(order)

        expect(subject.inventory["mattress"]).to eq pre_shipment_creation_mattress_inventory - 2
      end
    end
  end

  xcontext 'when there is insufficent inventory to create a shipment' do
    # omitted for the sake of brevity, but in production would be sure to account for the negative case of the context above
  end
end
