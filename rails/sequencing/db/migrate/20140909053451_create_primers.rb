class CreatePrimers < ActiveRecord::Migration
  def change
    create_table :primers do |t|
      t.string :name, null: false
      t.column :origin_thickness, 'DECIMAL(10, 2) UNSIGNED NOT NULL', default: 5
      [:annealing, :seq].each do |a|
        t.string a, null: false, default: ''
      end
      t.column :client_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.column :board_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.string :hole, null: false, default: ''
      t.string :status, null: false, default: 'ok'
      t.string :store_type, null: false, default: ''
      t.date :create_date, null: false
      t.date :expire_date, null: false
      t.date :operate_date, null: false
      t.column :need_return, 'TINYINT(1) UNSIGNED', limit: 1, default: 0, null: false
      t.column :available, 'TINYINT(1) UNSIGNED', limit: 1, default: 1, null: false
      t.text :seq
      t.text :remark
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.timestamps
    end
    add_index :primers, [:board_id, :hole], name: :board_hole, unique: true
  end
end
