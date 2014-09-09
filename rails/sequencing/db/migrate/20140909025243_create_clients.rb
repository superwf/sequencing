class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name, null: false, default: ''
      t.column :company_id, 'INT(11) UNSIGNED', null: false, default: 0
      t.string :email, null: false, default: ''
      t.string :address, null: false, default: ''
      t.string :tel, null: false, default: ''
      t.text :remark, null: false
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.timestamps
    end

    [:name, :email, :company_id].each do |a|
      add_index :clients, a, name: a
    end
  end
end
