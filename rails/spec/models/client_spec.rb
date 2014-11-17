require 'spec_helper'

describe Client do
  before :each do
    company = ::FactoryGirl.create :company
    @client = ::FactoryGirl.create :client, company_id: company.id
    expect(@client).to be_persisted
  end

  it 'test primers foreign key restrict' do
    board_head = ::FactoryGirl.create :board_head
    board = ::FactoryGirl.create :board, board_head_id: board_head.id
    primer = ::FactoryGirl.create :primer, client_id: @client.id, board_id: board.id
    rescue_destroy @client
  end

  it 'test orders foreign key restrict' do
    board_head = ::FactoryGirl.create :board_head
    order = ::FactoryGirl.create :order, board_head_id: board_head.id, client_id: @client.id
    rescue_destroy @client
  end
end
