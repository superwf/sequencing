require 'spec_helper'

describe PrecheckCode do
  before :each do
    @company = ::FactoryGirl.create :company
    @client = ::FactoryGirl.create :client, company_id: @company.id
    @bill = ::FactoryGirl.create :bill
    @board_head = ::FactoryGirl.create :board_head
    @order = ::FactoryGirl.create :order, client_id: @client.id, board_head_id: @board_head.id
    @sample = ::FactoryGirl.create :sample, order_id: @order.id
    expect(@sample).to be_persisted
    @precheck_code = ::FactoryGirl.create :precheck_code
  end

  it 'test prechecks foreign key restrict' do
    precheck = ::FactoryGirl.create :precheck, code_id: @precheck_code.id, sample_id: @sample.id
    rescue_destroy @precheck_code
  end
end
