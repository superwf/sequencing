class CreateDilutePrimers < ActiveRecord::Migration
  def change
    create_table :dilute_primers do |t|
      t.column :primer_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.column :order_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.string :status, null: false
      t.string :remark, default: '', null: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.timestamps
    end
    add_index :dilute_primers, :primer_id, name: :primer_id
    add_index :dilute_primers, :created_at, name: :created_at
  end
end
