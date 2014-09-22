class CreatePlasmids < ActiveRecord::Migration
  def change
    create_table :plasmids do |t|
      t.column :sample_id, 'INT(11) UNSIGNED', null: false
      t.column :plasmid_code_id, 'INT(11) UNSIGNED', null: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.timestamps
    end
    add_index :plasmids, :sample_id, name: :sample_id, unique: true
  end
end
