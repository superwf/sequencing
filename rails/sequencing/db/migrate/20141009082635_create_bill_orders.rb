class CreateBillOrders < ActiveRecord::Migration
  def change
    create_table :bill_orders do |t|
      t.column :bill_id, 'INT(11) UNSIGNED', null: false
      t.column :order_id, 'INT(11) UNSIGNED', null: false
      t.column :price, 'DECIMAL(10,2) UNSIGNED', null: false, default: 0
      t.column :money, 'DECIMAL(10,2) UNSIGNED', null: false, default: 0
      t.column :other_money, 'DECIMAL(10,2) UNSIGNED', null: false, default: 0
      t.column :charge_count, 'INT(11) UNSIGNED', null: false, default: 0
      t.string :remark
    end
    add_index :bill_orders, :bill_id, name: :bill_id
    add_index :bill_orders, :order_id, name: :order_id, unique: true
  end
end
