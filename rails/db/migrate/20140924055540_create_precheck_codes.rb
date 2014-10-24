class CreatePrecheckCodes < ActiveRecord::Migration
  def change
    create_table :precheck_codes do |t|
      t.string :code, null: false
      t.column :ok, 'TINYINT(1) UNSIGNED', limit: 1, null: false, default: true
      t.column :available, 'TINYINT(1) UNSIGNED', null: false, default: true
      t.string :remark, null: false, default: ''
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.timestamps
    end
  end
end
