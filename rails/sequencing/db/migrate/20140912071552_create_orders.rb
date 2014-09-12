class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.column :client_id, 'INT(11) UNSIGNED', null: false
      t.column :day_number, 'INT(11) UNSIGNED', null: false, default: 1
      t.column :board_head_id, 'INT(11) UNSIGNED', null: false
      t.column :parent_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.date :receive_date, null: false
      t.string :sn, null: false
      t.column :urgent, 'TINYINT(1) UNSIGNED', null: false, default: false
      t.column :is_test, 'TINYINT(1) UNSIGNED', null: false, default: false
      t.string :transport_condition, null: false, default: ''
      t.string :status, null: false, default: ''
      t.text :remark
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.timestamps
    end
    [:client_id, :parent_id, :receive_date].each do |i|
      add_index :orders, i, name: i
    end
    add_index :orders, :sn, name: :sn, unique: true
  end
end
