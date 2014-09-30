class CreateInterpretes < ActiveRecord::Migration
  def change
    create_table :interpretes, primary_key: :reaction_id do |t|
      t.column :code_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.column :submit, 'TINYINT(1) UNSIGNED', null: false, default: false
      t.timestamps
    end
    add_index :interpretes, :code_id, name: :code_id
  end
end
