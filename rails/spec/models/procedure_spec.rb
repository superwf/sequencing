require 'spec_helper'

describe Procedure do
  before :each do
    @board_head = ::FactoryGirl.create :board_head
    @procedure = ::FactoryGirl.create :procedure
  end

  it 'test flows foreign key restrict' do
    flow = ::FactoryGirl.create :flow, board_head_id: @board_head.id, procedure_id: @procedure.id
    expect(flow).to be_persisted
    rescue_destroy @procedure
  end

  it 'test board_records foreign key restrict' do
    board = ::FactoryGirl.create :board, board_head_id: @board_head.id
    board_record = ::FactoryGirl.create :board_record, board_id: board.id, procedure_id: @procedure.id
    expect(board_record).to be_persisted
    rescue_destroy @procedure
  end
end
