require 'spec_helper'

describe Bill do
  before :each do
    @company = ::FactoryGirl.create :company
    @client = ::FactoryGirl.create :client, company_id: @company.id
    @bill = ::FactoryGirl.create :bill
  end

  it 'test prepayment_records, bill_orders, bill_records foreign key cascade' do
    @prepayment = ::FactoryGirl.create :prepayment, company_id: @company.id
    prepayment_record = ::FactoryGirl.create :prepayment_record, prepayment_id: @prepayment.id, bill_id: @bill.id
    expect(prepayment_record).to be_persisted
    bill_record = ::FactoryGirl.create :bill_record, bill_id: @bill.id
    expect(bill_record).to be_persisted
    client = ::FactoryGirl.create :client, company_id: @company.id
    board_head = ::FactoryGirl.create :board_head
    order = ::FactoryGirl.create :order, client_id: client.id, board_head_id: board_head.id
    bill_order = ::FactoryGirl.create :bill_order, bill_id: @bill.id, order_id: order.id
    expect(bill_order).to be_persisted
    @bill.destroy
    expect(PrepaymentRecord.where("id = ?", prepayment_record.id).count).to eq(0)
    expect(BillRecord.where("bill_id = ?", bill_record.id).count).to eq(0)
    expect(BillOrder.where("order_id = ?", bill_order.id).count).to eq(0)
  end
end
