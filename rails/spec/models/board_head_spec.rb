require 'spec_helper'

describe BoardHead do
  before :each do
    company = ::FactoryGirl.create :company
    @client = ::FactoryGirl.create :client, company_id: company.id
    @board_head = ::FactoryGirl.create :board_head
  end

  it 'test boards foreign key restrict' do
    board = ::FactoryGirl.create :board, board_head_id: @board_head.id
    rescue_destroy @board_head
  end

  it 'test orders foreign key restrict' do
    order = ::FactoryGirl.create :order, board_head_id: @board_head.id, client_id: @client.id
    rescue_destroy @board_head
  end

  it 'test flows foreign key restrict' do
    procedure = ::FactoryGirl.create :procedure
    flow = ::FactoryGirl.create :flow, board_head_id: @board_head.id, procedure_id: procedure.id
    expect(flow).to be_persisted
    rescue_destroy @board_head
  end
end
