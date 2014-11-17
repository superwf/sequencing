# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require ::File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require './lib/clean_database'
require 'factory_girl'
require 'factory_girl/syntax'

# important , this make the activate_authlogic method avalible
::RSpec.configure do |config|
  config.before :each do
    CleanDatabase.clean
  end
  # == Mock Framework
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false

  # create admin user
  def create_admin
    ::FactoryGirl.create(:user)
  end

end

def rescue_destroy record
  record.destroy
rescue
ensure
  record.reload
  expect(record).to be_persisted
end

def t *args
  ::I18n.t *args
end

# these models can exist without any parent model
[:quality_code, :plasmid_code, :precheck_code, :company, :primer_head, :sample_head, :procedure, :sample_board_template, :reaction_head, :abi_machine, :vector, :menu, :permission, :modification_log].each do |m|
  self.class.send(:define_method, "create_#{m}") do |*args|
    ::FactoryGirl.create m, *args
  end
end

def create_all_sample_head
  heads = ::YAML.load_file("#{Rails.root}/spec/fixtures/sample_heads.yml")
  heads = heads.each do |h|
    h[:creator_id] = 1
    h[:available] = true
    SampleHead.create h
  end
end

def create_plasmid
  ::FactoryGirl.create :plasmid, sample_id: create_sample.id, plasmid_code_id: create_plasmid_code.id
end

def create_client
  ::FactoryGirl.create :client, company_id: create_company.id
end

def create_prepayment
  ::FactoryGirl.create :prepayment, owner: create_company
end

def create_prepayment_record
  ::FactoryGirl.create :prepayment_record, prepayment_id: create_prepayment.id, company_id: create_company.id
end

def create_primer_board
  ::FactoryGirl.create :primer_board, primer_head_id: create_primer_head.id
end

def create_fr_primer
  ::FactoryGirl.create :fr_primer, primer_id: create_primer.id, vector_id: create_vector.id, fr: :forward
end

def create_role
  ::FactoryGirl.create :role
end

def create_flow
  sample_head = create_sample_head
  sample_procedure1 = ::Procedure.find_by_name('electrophoresis') || create_procedure(name: 'electrophoresis', type: :sample, board: true)
  ::FactoryGirl.create :flow, head_id: sample_head.id, procedure_id: sample_procedure1.id, head_type: 'SampleHead'
end

def prepare_sample_head
  sample_head = create_sample_head
  procedure1 = ::Procedure.find_by_name('electrophoresis') || create_procedure(name: 'electrophoresis', type: :sample, board: true)
  ::FactoryGirl.create :flow, head_id: sample_head.id, head_type: 'SampleHead', procedure_id: procedure1.id
  sample_head.update_attribute :available, true
  sample_head
end

def create_sample_board *args, sample_head_id: prepare_sample_head.id
  ::FactoryGirl.create :sample_board, sample_head_id: sample_head_id
end

def create_order *args, sample_head_id: prepare_sample_head.id
  ::FactoryGirl.create :order, client_id: create_client.id, sample_head_id: sample_head_id
end

def create_order_mail
  ::FactoryGirl.create :order_mail, order_id: create_order.id
end

def create_checkout *args, created_date: ::Date.today
  sample = create_sample
  sample.order.update_attribute :status, :checkouted
  qc = create_quality_code
  sample.reactions.first.update_attribute :quality_code_id, qc.id
  ::FactoryGirl.create :checkout, checkout_orders_attributes: {1 => {order_id: sample.order_id}}
end

def create_sample *args, sample_board: create_sample_board, order: create_order(sample_head_id: sample_board.sample_head_id), parent_id: nil
  ::FactoryGirl.create :sample, order_id: order.id, sample_board_id: sample_board.id, sample_head_id: sample_board.sample_head_id , reactions_attributes: [{primer_id: create_primer.id}]
end

def create_primer(primer_board_id: create_primer_board.id, hole: :'1A')
  ::FactoryGirl.create :primer, client_id: create_client.id, primer_board_id: primer_board_id, hole: hole
end

def create_primer_mail
  ::FactoryGirl.create :primer_mail, primer_id: create_primer.id
end

def create_checkout_order
  create_checkout.checkout_orders.first
end

def create_primer_dilution
  ::FactoryGirl.create :primer_dilution, primer_id: create_primer.id
end

def create_sample_board_primer
  ::FactoryGirl.create :sample_board_primer, sample_board_template_id: create_sample_board_template.id, primer_id: create_primer.id
end

def create_reaction *args, sample_id: create_sample.id, primer_id: create_primer.id, **extra
  ::FactoryGirl.create :reaction, sample_id: sample_id, primer_id: primer_id, **extra
end

def prepare_reaction_head
  reaction_head = create_reaction_head
  procedure1 = ::Procedure.find_by_name('heat_cycle') || create_procedure(name: 'heat_cycle', type: :reaction, board: true)
  procedure2 = ::Procedure.find_by_name('alcohol_purification') || create_procedure(name: 'alcohol_purification', type: :reaction, board: true)
  procedure3 = ::Procedure.find_by_name('abi_record') || create_procedure(name: 'abi_record', type: :reaction, board: true)
  ::FactoryGirl.create :flow, head_id: reaction_head.id, head_type: 'ReactionHead', procedure_id: procedure1.id
  ::FactoryGirl.create :flow, head_id: reaction_head.id, head_type: 'ReactionHead', procedure_id: procedure2.id
  ::FactoryGirl.create :flow, head_id: reaction_head.id, head_type: 'ReactionHead', procedure_id: procedure3.id
  reaction_head.update_attribute :available, true
  reaction_head
end

def create_reaction_board
  ::FactoryGirl.create :reaction_board, reaction_head_id: prepare_reaction_head.id
end

def prepare_attr sym
  attrs = ::FactoryGirl.build(sym).attributes
  %w{created_at updated_at creator_id}.each do |a|
    attrs.delete a
  end
  attrs
end
