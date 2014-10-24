class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.column :record_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.column :sent, 'TINYINT(1) UNSIGNED', null: false, default: 0
      t.string :email_type, null: false
      t.string :remark, default: '', null: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.timestamps
    end
    add_index :emails, [:record_id, :email_type], name: :record_id
    add_index :emails, :sent, name: :sent
  end
end
