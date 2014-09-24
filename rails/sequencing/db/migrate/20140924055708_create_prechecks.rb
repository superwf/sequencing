class CreatePrechecks < ActiveRecord::Migration
  def change
    create_table :prechecks, primary_key: :sample_id do |t|
      t.column :code_id, 'INT(11) UNSIGNED', null: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.timestamps
    end
  end
end
