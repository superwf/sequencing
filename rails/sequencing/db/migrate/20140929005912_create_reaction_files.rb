class CreateReactionFiles < ActiveRecord::Migration
  def change
    create_table :reaction_files do |t|
      t.column :reaction_id, 'INT(11) UNSIGNED', null: false
      t.string :files, null: false, default: ''
      t.timestamps
    end
    add_index :reaction_files, :reaction_id, name: :reaction_id
  end
end
