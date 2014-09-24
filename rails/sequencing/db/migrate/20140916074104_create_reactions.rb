class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.column :sample_id, 'INT(11) UNSIGNED', null: false
      t.column :primer_id, 'INT(11) UNSIGNED', null: false
      t.column :dilute_primer_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.column :board_id, 'INT(11) UNSIGNED'
      t.string :hole, default: ''
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.text :remark
      t.timestamps
    end
    [:sample_id, :primer_id].each do |i|
      add_index :reactions, i, name: i
    end
    add_index :reactions, [:board_id, :hole], name: :board_hole
    add_index :reactions, :dilute_primer_id, name: :dilute_primer_id
  end
end
