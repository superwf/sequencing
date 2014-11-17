require 'spec_helper'

describe Sample do
  before :each do
    @company = ::FactoryGirl.create :company
    @client = ::FactoryGirl.create :client, company_id: @company.id
    @bill = ::FactoryGirl.create :bill
    @board_head = ::FactoryGirl.create :board_head
    @order = ::FactoryGirl.create :order, client_id: @client.id, board_head_id: @board_head.id
    @sample = ::FactoryGirl.create :sample, order_id: @order.id
    expect(@sample).to be_persisted
  end

  it 'test reaction, pladmids, prechecks foreign key cascade' do
    board_head = ::FactoryGirl.create :board_head
    board = ::FactoryGirl.create :board, board_head_id: board_head.id
    primer = ::FactoryGirl.create :primer, client_id: @client.id, board_id: board.id
    reaction = ::FactoryGirl.create :reaction, sample_id: @sample.id, primer_id: primer.id, order_id: @order.id
    expect(reaction).to be_persisted

    plasmid_code = ::FactoryGirl.create :plasmid_code
    plasmid = ::FactoryGirl.create :plasmid, code_id: plasmid_code.id, sample_id: @sample.id
    expect(plasmid).to be_persisted

    precheck_code = ::FactoryGirl.create :precheck_code
    precheck = ::FactoryGirl.create :precheck, code_id: precheck_code.id, sample_id: @sample.id
    expect(precheck).to be_persisted

    @sample.destroy
    expect(Reaction.where("id = ?", reaction.id).count).to eq(0)
    expect(Plasmid.where('sample_id = ?', plasmid.id).count).to eq(0)
    expect(Precheck.where('sample_id = ?', plasmid.id).count).to eq(0)
  end
end
