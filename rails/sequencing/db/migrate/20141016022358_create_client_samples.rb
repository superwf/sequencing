class CreateClientSamples < ActiveRecord::Migration
  def change
    create_table :client_samples do |t|
      t.string :name
      t.column :client_id, 'INT(11) UNSIGNED', null: false
      t.string :head, null: false, default: ''
      t.string :structure, null: false, default: ''
      t.string :vector, null: false, default: ''
      t.string :resistance, null: false, default: ''
      t.string :length, null: false, default: ''
      t.string :primer, null: false, default: ''
      t.column :universal_primer, 'TINYINT(1) UNSIGNED', null: false, default: false
      t.column :is_splice, 'TINYINT(1) UNSIGNED', null: false, default: false
      t.text :remark
      t.string :status, null: false
      t.column :reaction_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.timestamps
    end
    add_index :client_samples, :client_id, name: :client_id
    add_index :client_samples, :reaction_id, name: :reaction_id
  end
end
