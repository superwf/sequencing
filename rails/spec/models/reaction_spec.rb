require 'spec_helper'

describe Reaction do
  before :each do
    @company = ::FactoryGirl.create :company
    @client = ::FactoryGirl.create :client, company_id: @company.id
    @bill = ::FactoryGirl.create :bill
    @board_head = ::FactoryGirl.create :board_head
    @order = ::FactoryGirl.create :order, client_id: @client.id, board_head_id: @board_head.id
    @sample = ::FactoryGirl.create :sample, order_id: @order.id
    expect(@sample).to be_persisted
  end

  it 'test reaction_files foreign key cascade' do
    board_head = ::FactoryGirl.create :board_head
    board = ::FactoryGirl.create :board, board_head_id: board_head.id
    primer = ::FactoryGirl.create :primer, client_id: @client.id, board_id: board.id
    reaction = ::FactoryGirl.create :reaction, sample_id: @sample.id, primer_id: primer.id, order_id: @order.id
    expect(reaction).to be_persisted
    reaction_file = ::FactoryGirl.create :reaction_file, reaction_id: reaction.id
    reaction.destroy
    expect(ReactionFile.where('reaction_id = ?', reaction_file.id).count).to eq(0)
  end
end
