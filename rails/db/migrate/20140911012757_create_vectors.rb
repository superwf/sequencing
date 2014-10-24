class CreateVectors < ActiveRecord::Migration
  def change
    create_table :vectors do |t|
      [:name, :producer, :length, :resistance, :copy_number].each do |a|
        t.string a, null: false
      end
      t.column :creator_id, 'INT(11) UNSIGNED', null: false
      t.timestamps
    end
    [:name].each do |a|
      add_index :vectors, a, name: a
    end
  end
end
