class CreateSampleHeads < ActiveRecord::Migration
  def change
    create_table :sample_heads do |t|
      t.string :name, limit: 100, null: false
      t.string :remark, limit: 100, null: false, default: ''
      #t.integer :parent_id, null: false, default: 0
      t.column :auto_precheck, 'TINYINT(1) UNSIGNED', limit: 1, null: false, default: false
      t.column :available, 'TINYINT(1) UNSIGNED', limit: 1, null: false, default: true
    end
  end
end
