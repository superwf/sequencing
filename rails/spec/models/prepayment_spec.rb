require 'spec_helper'

describe Prepayment do
  before :each do
    @company = ::FactoryGirl.create :company
    @prepayment = ::FactoryGirl.create :prepayment, company_id: @company.id
    @bill = ::FactoryGirl.create :bill
  end

  it 'test prepayment_records foreign key constraint' do
    @prepayment_record = ::FactoryGirl.create :prepayment_record, prepayment_id: @prepayment.id, bill_id: @bill.id
    expect(@prepayment_record).to be_persisted
    rescue_destroy @prepayment
  end
end
