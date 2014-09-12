class CreateBoardHeads < ActiveRecord::Migration
  def change
    create_table :board_heads do |t|
      t.string :name, null: false
      t.string :remark, null: false, default: ''
      t.string :board_type, null: false, default: '' # should be sample, primer or reaction
      t.string :cols, null: false, default: '' # should like 1,2,3,4 or 01,02,03,04
      t.string :rows, null: false, default: '' # should like A,B,C,D, max is Z
      t.column :with_date, 'TINYINT(1) UNSIGNED', null: false, default: 0
      t.column :available, 'TINYINT(1) UNSIGNED', null: false, default: 1
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.timestamps
    end
    add_index :board_heads, [:name, :board_type], name: :board_type_name, unique: true
  end
end
