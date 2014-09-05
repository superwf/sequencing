class CreateProcedures < ActiveRecord::Migration
  def change
    create_table :procedures do |t|
      t.string :name, null: false, default: ''
      t.string :remark, null: false, default: ''
      t.string :flow_type, null: false, limit: 100, default: 'sample'
      t.column :board, 'TINYINT(1) UNSIGNED', limit: 1, null: false, default: false
      t.column :attachment, 'TINYINT(1) UNSIGNED', limit: 1, null: false, default: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
    end
  end
end
