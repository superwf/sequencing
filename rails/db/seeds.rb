require './lib/clean_database'
CleanDatabase.clean
db = Menu.connection

seeds = %w{menus procedures}
seeds.each do |f|
  yml = ::Rails.root.join("test/fixtures/#{f}.yml")
  table_name = f

  # foreign key can not truncate
  #if table_name != 'procedures'
  #end
  db.execute("DELETE FROM #{table_name}")

  if f == 'menus'
    #file_name = yml + '.erb'
    yml = ::ERB.new(::File.read("#{yml}.erb")).result(binding) 
  else
    yml = ::File.read(yml)
  end

  #puts yml
  ::YAML.load(yml).each do |value|
    model_class = eval(table_name.classify)
    if model_class.attribute_names.include? 'creator_id'
      value['creator_id'] = 1
    end
    record = model_class.create value 
    if record.persisted?
      #puts "#{table_name.classify} init data #{value} success "
    else
      puts record.inspect
      puts record.errors.full_messages
    end
  end
end

# convert all datetime field default to 0000-00-00 00:00:00 to avoid go timt.Time can not null error
tables = db.tables
%w[schema_migrations menus_roles users roles pc_relations].each do |t|
  tables.delete t
end
special = %w[prechecks reaction_files plasmids bill_orders bill_records]
tables.each do |t|
  #begin
    model_class = eval(t.classify)
    #puts model_class
    model_class.columns.each do |c|
      if c.type == :datetime
        db.execute "UPDATE #{t} SET #{c.name} = '0000-00-00 00:00:00' WHERE #{c.name} IS NULL"
        db.execute "ALTER TABLE #{t} CHANGE #{c.name} #{c.name} DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'"
      end
    end
    if special.include?(t)
      db.execute "ALTER TABLE #{t} CHANGE #{model_class.primary_key} #{model_class.primary_key} INT(11) UNSIGNED NOT NULL"
    else
      db.execute "ALTER TABLE #{t} CHANGE #{model_class.primary_key} #{model_class.primary_key} INT(11) UNSIGNED NOT NULL AUTO_INCREMENT"
    end
  #rescue
  #end
end

# add forign key constaint
# these should be test in rspec

# restrict company clients
# tested
db.execute "ALTER TABLE `clients` ADD FOREIGN KEY ( `company_id` ) REFERENCES `companies` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"
# restrict company prepayments
# tested
db.execute "ALTER TABLE `prepayments` ADD FOREIGN KEY ( `company_id` ) REFERENCES `companies` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"
# restrict prepayment prepayment_records
# tested
db.execute "ALTER TABLE `prepayment_records` ADD FOREIGN KEY ( `prepayment_id` ) REFERENCES `prepayments` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"
# cascade order samples
# tested
db.execute "ALTER TABLE `samples` ADD FOREIGN KEY ( `order_id` ) REFERENCES `orders` ( `id`) ON DELETE CASCADE ON UPDATE NO ACTION;"
# cascade sample reactions
# tested
db.execute "ALTER TABLE `reactions` ADD FOREIGN KEY ( `sample_id` ) REFERENCES `samples` ( `id`) ON DELETE CASCADE ON UPDATE NO ACTION;"
# restrict primer reactions
# tested
db.execute "ALTER TABLE `reactions` ADD FOREIGN KEY ( `primer_id` ) REFERENCES `primers` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"
# restrict primer dilute_primers
# tested
db.execute "ALTER TABLE `dilute_primers` ADD FOREIGN KEY ( `primer_id` ) REFERENCES `primers` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"
# cascade order dilute_primers
# tested
db.execute "ALTER TABLE `dilute_primers` ADD FOREIGN KEY ( `order_id` ) REFERENCES `orders` ( `id`) ON DELETE CASCADE ON UPDATE NO ACTION;"
# restrict bill prepayment_records
# tested
db.execute "ALTER TABLE `prepayment_records` ADD FOREIGN KEY ( `bill_id` ) REFERENCES `bills` ( `id`) ON DELETE CASCADE ON UPDATE NO ACTION;"
# cascade bill bill_orders
# tested
db.execute "ALTER TABLE `bill_orders` ADD FOREIGN KEY ( `bill_id` ) REFERENCES `bills` ( `id`) ON DELETE CASCADE ON UPDATE NO ACTION;"
# cascade order bill_orders
# tested
db.execute "ALTER TABLE `bill_orders` ADD FOREIGN KEY ( `order_id` ) REFERENCES `orders` ( `id`) ON DELETE CASCADE ON UPDATE NO ACTION;"
# cascade bill bill_records
# tested
db.execute "ALTER TABLE `bill_records` ADD FOREIGN KEY ( `bill_id` ) REFERENCES `bills` ( `id`) ON DELETE CASCADE ON UPDATE NO ACTION;"
# restrict client primers
# tested
db.execute "ALTER TABLE `primers` ADD FOREIGN KEY ( `client_id` ) REFERENCES `clients` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"
# restrict board primers
# tested
db.execute "ALTER TABLE `primers` ADD FOREIGN KEY ( `board_id` ) REFERENCES `boards` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"
# restrict client orders
# tested
db.execute "ALTER TABLE `orders` ADD FOREIGN KEY ( `client_id` ) REFERENCES `clients` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"
# restrict board_head boards
# tested
db.execute "ALTER TABLE `boards` ADD FOREIGN KEY ( `board_head_id` ) REFERENCES `board_heads` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"
# restrict board_head orders
# tested
db.execute "ALTER TABLE `orders` ADD FOREIGN KEY ( `board_head_id` ) REFERENCES `board_heads` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"

# restrict procedure flows
# tested
db.execute "ALTER TABLE `flows` ADD FOREIGN KEY ( `procedure_id` ) REFERENCES `procedures` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"
# restrict procedure board_records
# tested
db.execute "ALTER TABLE `board_records` ADD FOREIGN KEY ( `procedure_id` ) REFERENCES `procedures` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"

# restrict board_head flows
# tested
db.execute "ALTER TABLE `flows` ADD FOREIGN KEY ( `board_head_id` ) REFERENCES `board_heads` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"
# restrict sample plasmids
# tested
db.execute "ALTER TABLE `plasmids` ADD FOREIGN KEY ( `sample_id` ) REFERENCES `samples` ( `id`) ON DELETE CASCADE ON UPDATE NO ACTION;"
# restrict plasmid_codes plasmids
# tested
db.execute "ALTER TABLE `plasmids` ADD FOREIGN KEY ( `code_id` ) REFERENCES `plasmid_codes` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"
# restrict sample prechecks
# tested
db.execute "ALTER TABLE `prechecks` ADD FOREIGN KEY ( `sample_id` ) REFERENCES `samples` ( `id`) ON DELETE CASCADE ON UPDATE NO ACTION;"
# restrict precheck_codes prechecks
# tested
db.execute "ALTER TABLE `prechecks` ADD FOREIGN KEY ( `code_id` ) REFERENCES `precheck_codes` ( `id`) ON DELETE RESTRICT ON UPDATE NO ACTION;"
# restrict reaction reaction_files
# tested
db.execute "ALTER TABLE `reaction_files` ADD FOREIGN KEY ( `reaction_id` ) REFERENCES `reactions` ( `id`) ON DELETE CASCADE ON UPDATE NO ACTION;"
# restrict board board_records
# tested
db.execute "ALTER TABLE `board_records` ADD FOREIGN KEY ( `board_id` ) REFERENCES `boards` ( `id`) ON DELETE CASCADE ON UPDATE NO ACTION;"
