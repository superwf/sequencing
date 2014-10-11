class CreateBillRecords < ActiveRecord::Migration
  def change
    create_table :bill_records do |t|
      t.column :bill_id, 'INT(11) UNSIGNED', null: false
      t.string :flow, null: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.text :data, null: false
      t.timestamps
    end
    add_index :bill_records, :bill_id, name: :bill_id
  end
end
