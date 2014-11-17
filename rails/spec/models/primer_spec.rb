require 'spec_helper'

describe Primer do
  before :each do
    @company = ::FactoryGirl.create :company
    @client = ::FactoryGirl.create :client, company_id: @company.id
    @bill = ::FactoryGirl.create :bill
    @board_head = ::FactoryGirl.create :board_head
    @order = ::FactoryGirl.create :order, client_id: @client.id, board_head_id: @board_head.id
    @sample = ::FactoryGirl.create :sample, order_id: @order.id
    @board_head = ::FactoryGirl.create :board_head
    @board = ::FactoryGirl.create :board, board_head_id: @board_head.id
    @primer = ::FactoryGirl.create :primer, client_id: @client.id, board_id: @board.id
  end

  it 'test reaction foreign key restrict' do
    reaction = ::FactoryGirl.create :reaction, sample_id: @sample.id, primer_id: @primer.id, order_id: @order.id
    expect(reaction).to be_persisted
    rescue_destroy @primer
  end

  it 'test dilute_primer foreign key restrict' do
    @order = ::FactoryGirl.create :order, client_id: @client.id, board_head_id: @board_head.id
    dilute_primer = ::FactoryGirl.create :dilute_primer, primer_id: @primer.id, order_id: @order.id
    expect(dilute_primer).to be_persisted
    rescue_destroy @primer
  end
end
