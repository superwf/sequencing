class CreateBillRecords < ActiveRecord::Migration
  def change
    create_table :bill_records, primary_key: :bill_id do |t|
      t.text :data, null: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.timestamps
    end
  end
end
