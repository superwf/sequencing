class CreateElectros < ActiveRecord::Migration
  def change
    create_table :electros do |t|
      t.column :board_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.string :remark, default: 'ok'
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.timestamps
    end
    add_index :electros, :board_id, name: :board_id
  end
end
