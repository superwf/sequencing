class CreateProcedures < ActiveRecord::Migration
  def change
    create_table :procedures do |t|
      t.string :name, null: false, default: ''
      t.string :record_name, null: false, default: ''
      t.string :remark, null: false, default: ''
      t.string :flow_type, null: false, limit: 100, default: 'sample'
      t.column :board, 'TINYINT(1) UNSIGNED', limit: 1, null: false, default: false
    end
    add_index :procedures, :name, name: :name, unique: true
  end
end
