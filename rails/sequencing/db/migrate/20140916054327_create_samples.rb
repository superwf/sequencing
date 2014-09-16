class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :name, null: false
      t.column :order_id, 'INT(11) UNSIGNED', null: false
      t.column :vector_id, 'INT(11) UNSIGNED', default: 0
      t.string :length, default: 0, null: false
      t.string :resistance, default: '', null: false
      t.string :return_type, default: '', null: false
      t.column :sample_board_id, 'INT(11) UNSIGNED', default: 0
      t.string :hole, null: false, default: ''
      t.column :is_splice, 'TINYINT(1) UNSIGNED', null: false, default: false
      t.string :splice_status, null: false, default: ''
      t.column :is_through, 'TINYINT(1) UNSIGNED', null: false, default: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.text :remark
      t.timestamps
    end
    [:order_id, :vector_id].each do |i|
      add_index :samples, i, name: i
    end
    add_index :samples, [:sample_board_id, :hole], name: :board_hole, unique: true
  end
end
