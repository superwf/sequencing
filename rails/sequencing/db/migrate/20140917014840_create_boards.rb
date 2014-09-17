class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.column :board_head_id, 'INT(11) UNSIGNED', null: false
      #t.column :flow_id, 'INT(11) UNSIGNED'
      t.column :number, 'INT(11) UNSIGNED', default: 1
      t.date :create_date, null: false
      t.string :status, null: false, default: ''
      t.string :sn, limit: 50, null: false
    end
    [:create_date, :board_head_id].each do |a|
      add_index :boards, a, name: a
    end
    add_index :boards, :sn, name: :sn, unique: true
  end
end
