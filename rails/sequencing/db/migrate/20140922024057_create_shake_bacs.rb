class CreateShakeBacs < ActiveRecord::Migration
  def change
    create_table :shake_bacs do |t|
      t.column :board_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.string :remark, default: 'ok'
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.timestamps
    end
    add_index :shake_bacs, :board_id, name: :board_id, unique: true
  end
end
