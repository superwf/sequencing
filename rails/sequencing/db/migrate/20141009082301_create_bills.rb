class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.date :create_date, null: false
      t.column :number, 'INT(11) UNSIGNED', null: false, default: 1
      t.string :sn, null: false
      t.column :money, 'DECIMAL(10,2) UNSIGNED', null: false, default: 0
      t.column :other_money, 'DECIMAL(10,2) UNSIGNED', null: false, default: 0
      t.string :status, null: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.timestamps
    end
    add_index :bills, :sn, name: :sn, unique: true
  end
end
