class CreateSampleHeads < ActiveRecord::Migration
  def change
    create_table :sample_heads do |t|
      t.string :name, null: false
      t.string :remark, null: false, default: ''
      #t.integer :parent_id, null: false, default: 0
      t.column :auto_precheck, 'TINYINT(1) UNSIGNED', limit: 1, null: false, default: false
      t.column :available, 'TINYINT(1) UNSIGNED', limit: 1, null: false, default: true
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
    end
  end
end
