class CreateFlows < ActiveRecord::Migration
  def change
    create_table :flows do |t|
      t.column :board_head_id, 'INT(11) UNSIGNED', null: false
      t.column :procedure_id, 'INT(11) UNSIGNED', null: false
    end
    add_index :flows, :board_head_id, name: :board_head_id
    add_index :flows, :procedure_id, name: :procedure_id
  end
end
