class CreateBoardRecords < ActiveRecord::Migration
  def change
    create_table :board_records do |t|
      t.column :board_id, 'INT(11) UNSIGNED', null: false
      t.column :procedure_id, 'INT(11) UNSIGNED', null: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.text :data
      t.timestamps
    end
    add_index :board_records, :board_id, name: :board_id
  end
end
