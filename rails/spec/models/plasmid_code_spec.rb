require 'spec_helper'

describe PlasmidCode do
  before :each do
    @company = ::FactoryGirl.create :company
    @client = ::FactoryGirl.create :client, company_id: @company.id
    @bill = ::FactoryGirl.create :bill
    @board_head = ::FactoryGirl.create :board_head
    @order = ::FactoryGirl.create :order, client_id: @client.id, board_head_id: @board_head.id
    @sample = ::FactoryGirl.create :sample, order_id: @order.id
    expect(@sample).to be_persisted
    @plasmid_code = ::FactoryGirl.create :plasmid_code
  end

  it 'test plasmids foreign key restrict' do
    plasmid = ::FactoryGirl.create :plasmid, code_id: @plasmid_code.id, sample_id: @sample.id
    rescue_destroy @plasmid_code
  end
end
