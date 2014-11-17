#require 'spec_helper'
#
#describe DilutePrimer do
#  before :each do
#    @company = ::FactoryGirl.create :company
#    @client = ::FactoryGirl.create :client, company_id: @company.id
#    @bill = ::FactoryGirl.create :bill
#    @board_head = ::FactoryGirl.create :board_head
#    @order = ::FactoryGirl.create :order, client_id: @client.id, board_head_id: @board_head.id
#  end
#
#  it 'test samples, bill_orders foreign key cascade' do
#    sample = ::FactoryGirl.create :sample, order_id: @order.id
#    expect(sample).to be_persisted
#    bill_order = ::FactoryGirl.create :bill_order, bill_id: @bill.id, order_id: @order.id
#    expect(bill_order).to be_persisted
#    @order.destroy
#    expect(Sample.where("id = ?", sample.id).count).to eq(0)
#    expect(BillOrder.where("order_id = ?", bill_order.id).count).to eq(0)
#  end
#end
