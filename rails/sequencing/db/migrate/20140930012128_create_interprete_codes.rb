class CreateInterpreteCodes < ActiveRecord::Migration
  def change
    create_table :interprete_codes do |t|
      t.string :code, null: false
      t.string :result, null: false
      t.string :remark, null: false
      t.column :available, 'TINYINT(1) UNSIGNED', null: false, default: true
      t.column :charge, 'TINYINT(1) UNSIGNED', null: false, default: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.timestamps
    end
  end
end
