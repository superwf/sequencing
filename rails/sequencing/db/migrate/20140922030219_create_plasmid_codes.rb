class CreatePlasmidCodes < ActiveRecord::Migration
  def change
    create_table :plasmid_codes do |t|
      t.string :code, null: false
      t.string :remark, null: false
      t.column :available, 'TINYINT(1) UNSIGNED', null: false, default: true
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.timestamps
    end
    add_index :plasmid_codes, :code, name: :code, unique: true
  end
end
