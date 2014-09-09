class CreatePrimerHeads < ActiveRecord::Migration
  def change
    create_table :primer_heads do |t|
      t.string :name, null: false
      t.string :remark, null: false, default: ''
      t.column :with_date, 'TINYINT(1) UNSIGNED', null: false, default: 0
      t.column :available, 'TINYINT(1) UNSIGNED', null: false, default: 1
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.timestamps
    end
  end
end
