class CreatePrimerBoards < ActiveRecord::Migration
  def change
    create_table :primer_boards do |t|
      t.column :primer_head_id, 'INT(11) UNSIGNED', null: false
      t.date :create_date, null: false
      t.column :number, 'INT(11) UNSIGNED', null: false
      t.string :sn, null: false, null: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.timestamps
    end
    [:primer_head_id, :created_date].each do |a|
      add_index :primer_boards, a, name: a
    end
    add_index :primer_boards, :sn, name: :sn, unique: true
  end
end
