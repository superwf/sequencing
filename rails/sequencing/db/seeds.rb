# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
db = ::Menu.connection
seeds = %w{procedures menus}
seeds.each do |f|
  yml = ::Rails.root.join("test/fixtures/#{f}.yml")
  table_name = f
  db.execute("TRUNCATE TABLE #{table_name}")
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
