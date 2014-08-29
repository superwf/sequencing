class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name, null: false, default: ''
      t.string :url, null: false, default: ''
      t.integer :parent_id, null: false, default: 0
      t.text :remark, null: false, default: ''
    end
    add_index :menus, :parent_id, name: :parent_id
  end
end
