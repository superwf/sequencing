class CreatePrepaymentRecords < ActiveRecord::Migration
  def change
    create_table :prepayment_records do |t|
      t.column :prepayment_id, 'INT(11) UNSIGNED', null: false
      t.column :bill_id, 'INT(11) UNSIGNED', null: false
      t.date :create_date, null: false
      t.column :money, 'DECIMAL(10,2) UNSIGNED', null: false, default: 0
      t.string :remark, null: false, default: '', limit: 500
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.timestamps
    end
    add_index :prepayment_records, [:prepayment_id, :bill_id], name: :prepayment_id, unique: true
    add_index :prepayment_records, :bill_id, name: :bill_id
  end
end
