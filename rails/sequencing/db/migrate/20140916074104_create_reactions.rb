class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.column :sample_id, 'INT(11) UNSIGNED', null: false
      t.column :order_id, 'INT(11) UNSIGNED', null: false
      t.column :primer_id, 'INT(11) UNSIGNED', null: false
      t.column :quadrant, 'SMALLINT(1) UNSIGNED', default: 1
      t.column :primer_dilution_id, 'INT(11) UNSIGNED'
      t.column :reaction_board_id, 'INT(11) UNSIGNED'
      t.string :hole, default: ''
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.text :remark
      t.timestamps
    end
    [:sample_id, :order_id, :parent_id, :quality_code_id].each do |i|
      add_index :reactions, i, name: i
    end
    add_index :reactions, [:reaction_board_id, :hole], name: :board_hole, unique: true
  end
end
