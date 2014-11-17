require 'spec_helper'

describe Company do
  before :each do
    @company = ::FactoryGirl.create :company
  end

  it 'test clients foreign key constraint' do
    expect(Company.count).to eq(1)
    @client = ::FactoryGirl.create :client, company_id: @company.id
    expect(@client).to be_persisted
    rescue_destroy @company
  end

  it 'test prepayments foreign key constraint' do
    @prepayment = ::FactoryGirl.create :prepayment, company_id: @company.id
    expect(@prepayment).to be_persisted
    rescue_destroy @company
  end
end
