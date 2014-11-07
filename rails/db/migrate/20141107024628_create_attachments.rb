class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :table_name, null: false
      t.column :record_id, 'INT(11) UNSIGNED', null: false
      t.string :url, null: false
      t.string :name, null: false
    end
    add_index :attachments, [:table_name, :record_id], name: :table_record
  end
end
