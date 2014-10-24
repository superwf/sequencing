class CreateClientReactions < ActiveRecord::Migration
  def change
    create_table :client_reactions do |t|
      t.string :sample, null: false
      t.string :sample_type, null: false, default: ''
      t.string :structure, null: false, default: ''
      t.column :client_id, 'INT(11) UNSIGNED', null: false
      t.string :structure, null: false, default: ''
      t.string :fragment, null: false, default: ''
      t.string :vector, null: false, default: ''
      t.string :resistance, null: false, default: ''
      t.string :primer, null: false, default: ''
      t.column :universal_primer, 'TINYINT(1) UNSIGNED', null: false, default: false
      t.column :is_splice, 'TINYINT(1) UNSIGNED', null: false, default: false
      t.string :remark, default: '', null: false
      t.column :reaction_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.timestamps
    end
    add_index :client_reactions, :sample, name: :sample
    add_index :client_reactions, :client_id, name: :client_id
    add_index :client_reactions, :reaction_id, name: :reaction_id
  end
end
