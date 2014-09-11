class CreatePrimers < ActiveRecord::Migration
  def change
    create_table :primers do |t|
      t.string :name, null: false
      t.column :origin_thickness, 'DECIMAL(10, 2) UNSIGNED NOT NULL', default: 5
      [:annealing, :seq].each do |a|
        t.string a, null: false, default: ''
      end
      t.column :client_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.column :primer_board_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.string :hole, null: false, default: ''
      t.string :status, null: false, default: ''
      t.string :store_type, null: false, default: ''
      t.string :receive_date, null: false, default: ''
      t.string :expire_date, null: false, default: ''
      t.string :operate_date, null: false, default: ''
      t.column :need_return, 'TINYINT(1) UNSIGNED', limit: 1, default: 0, null: false
      t.column :available, 'TINYINT(1) UNSIGNED', limit: 1, default: 1, null: false
      t.text :seq
      t.text :remark
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.timestamps
    end
  end
end
