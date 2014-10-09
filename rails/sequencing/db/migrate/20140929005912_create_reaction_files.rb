class CreateReactionFiles < ActiveRecord::Migration
  def change
    create_table :reaction_files, primary_key: :reaction_id do |t|
      t.datetime :uploaded_at
      t.column :code_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.string :proposal, null: false, default: ''
      t.string :status, null: false # interpreting interpreted sent
      t.column :interpreter_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.datetime :interpreted_at
    end
    add_index :reaction_files, :code_id, name: :code_id
    add_index :reaction_files, :interpreter_id, name: :interpreter_id
    add_index :reaction_files, :status, name: :status
  end
end
