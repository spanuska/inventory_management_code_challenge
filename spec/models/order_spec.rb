require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { Order.new }
  let!(:upc) { Upc.find_or_create_by(name: "mattress") }
  let(:upc2) { Upc.find_or_create_by(name: "pillow") }
  let(:upc3) { Upc.find_or_create_by(name: "sheet set") }

  describe '#upcs' do
    context 'when it is initialized' do
      it 'returns an empty array' do
        order_upcs = subject.upcs
        expect(order_upcs).to eq []
      end
    end

    context 'when it has 3 UPCs' do
      it 'returns an array containing 3 UPCs' do
        subject.upcs << upc << upc2 << upc3

        expect(subject.upcs).to match_array [upc, upc2, upc3]
      end
    end
  end

  describe '#add_upc' do
    context 'when adding a valid upc code' do
      it 'inserts a UPC object into the order\'s collection of UPCs' do
        subject.add_upc("mattress")

        expect(subject.upcs).to match_array [upc]
      end
    end

    context 'when adding an invalid upc code' do
      it 'raises an error' do

        expect{ subject.add_upc("bananas") }.to raise_error
      end
    end
  end

  describe '#inventory_required_to_fulfill' do
    it 'returns a hash with keys perataining to upc names whose values are the counts of those upcs in the order' do
      subject.upcs << upc << upc << upc2 << upc2

      expect(subject.inventory_required_to_fulfill).to eq ({ "mattress" => 2, "pillow" => 2 })
    end
  end

  describe '#assign_to_warehouse' do
    let!(:first_qualified_warehouse) { Warehouse.create!(id: 1) }
    let!(:second_qualified_warehouse) { Warehouse.create!(id: 2) }

    before(:each) do
      3.times { Product.create!(upc: upc, allocator: first_qualified_warehouse) }
      2.times { Product.create!(upc: upc2, allocator: first_qualified_warehouse) }

      3.times { Product.create!(upc: upc, allocator: second_qualified_warehouse) }
      2.times { Product.create!(upc: upc2, allocator: second_qualified_warehouse) }
    end

    it 'associates itself with the first warehouse that has enough inventory for a shipment' do
      subject.upcs << upc << upc << upc << upc2 << upc2
      warehouse_before_assign_to_warehouse = subject.warehouse
      subject.assign_to_warehouse

      expect(warehouse_before_assign_to_warehouse).to be nil
      expect(subject.warehouse).to eq first_qualified_warehouse
      expect(subject.warehouse).to_not eq second_qualified_warehouse
    end
  end
end
