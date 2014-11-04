class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :name, null: false
      t.column :order_id, 'INT(11) UNSIGNED', null: false
      t.column :vector_id, 'INT(11) UNSIGNED', default: 0
      t.string :fragment, default: 0, null: false
      t.string :resistance, default: '', null: false
      t.string :return_type, default: '', null: false
      t.column :board_id, 'INT(11) UNSIGNED', default: 0
      t.string :hole, null: false, default: ''
      t.string :splice_status, null: false, default: ''
      t.column :is_through, 'TINYINT(1) UNSIGNED', null: false, default: false
      t.column :parent_id, 'INT(11) UNSIGNED', default: 0
    end
    add_index :samples, [:order_id, :name], name: :order_id, unique: true
    add_index :samples, [:board_id, :hole], name: :board_hole
    add_index :samples, :splice_status, name: :splice_status
  end
end
