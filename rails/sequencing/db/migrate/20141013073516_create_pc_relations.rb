# means parent children relations
class CreatePcRelations < ActiveRecord::Migration
  def change
    create_table :pc_relations, id: false do |t|
      t.column :parent_id, 'INT(11) UNSIGNED', null: false
      t.string :table_name, null: false
      t.column :child_id, 'INT(11) UNSIGNED', null: false
    end
    add_index :pc_relations, [:parent_id, :child_id, :table_name], name: :parent_id, unique: true
    add_index :pc_relations, [:child_id, :table_name], name: :child_id
  end
end
