class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.column :parent_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.string :price, 'DECIMAL(10, 2) UNSIGNED', null: false, default: 0
      t.string :full_name, null: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.timestamps
    end
    %i[name code parent_id].each do |a|
      add_index :companies, a, name: a
    end
  end
end
