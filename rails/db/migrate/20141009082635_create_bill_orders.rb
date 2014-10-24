class CreateBillOrders < ActiveRecord::Migration
  def change
    create_table :bill_orders, primary_key: :order_id do |t|
      t.column :bill_id, 'INT(11) UNSIGNED', null: false
      t.column :price, 'DECIMAL(10,2) UNSIGNED', null: false, default: 0
      t.column :money, 'DECIMAL(10,2) UNSIGNED', null: false, default: 0
      t.column :other_money, 'DECIMAL(10,2)', null: false, default: 0
      t.column :charge_count, 'INT(11) UNSIGNED', null: false, default: 0
      t.string :remark
    end
    add_index :bill_orders, :bill_id, name: :bill_id
  end
end
