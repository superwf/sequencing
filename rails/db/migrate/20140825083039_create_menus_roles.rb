class CreateMenusRoles < ActiveRecord::Migration
  def change
    create_table :menus_roles, id: false do |t|
      t.integer :menu_id, null: false
      t.integer :role_id, null: false
    end
    add_index :menus_roles, [:role_id, :menu_id], unique: true, name: :role_menu
  end
end
