class CreateOrderMails < ActiveRecord::Migration
  def change
    create_table :order_mails do |t|
      t.column :order_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.column :sent, 'TINYINT(1) UNSIGNED', null: false, default: 0
      t.string :mail_type, null: false
      t.string :remark, default: '', null: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.timestamps
    end
    add_index :order_mails, [:order_id, :mail_type], name: :order_id
    add_index :order_mails, :sent, name: :sent
  end
end
