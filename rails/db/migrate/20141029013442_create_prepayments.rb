class CreatePrepayments < ActiveRecord::Migration
  def change
    create_table :prepayments do |t|
      t.column :company_id, 'INT(11) UNSIGNED', null: false
      t.date :create_date, null: false
      t.column :money, 'DECIMAL(10,2) UNSIGNED', null: false, default: 0
      t.column :balance, 'DECIMAL(10,2) UNSIGNED', null: false, default: 0
      t.string :invoice, null: false, default: ''
      t.string :remark, null: false, default: '', limit: 500
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.timestamps
    end
    add_index :prepayments, :company_id, name: :company_id
    add_index :prepayments, :create_date, name: :create_date
  end
end
