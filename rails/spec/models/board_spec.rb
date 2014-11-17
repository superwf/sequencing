require 'spec_helper'

describe Board do
  before :each do
    company = ::FactoryGirl.create :company
    @client = ::FactoryGirl.create :client, company_id: company.id
    board_head = ::FactoryGirl.create :board_head
    @board = ::FactoryGirl.create :board, board_head_id: board_head.id
    @procedure = ::FactoryGirl.create :procedure
  end

  it 'test primers foreign key restrict' do
    primer = ::FactoryGirl.create :primer, client_id: @client.id, board_id: @board.id
    rescue_destroy @board
  end

  it 'test board_records foreign key restrict' do
    board_record = ::FactoryGirl.create :board_record, board_id: @board.id, procedure_id: @procedure.id
    expect(board_record).to be_persisted
    @board.destroy
    expect(BoardRecord.where('id = ?', board_record.id).count).to eq(0)
  end
end
