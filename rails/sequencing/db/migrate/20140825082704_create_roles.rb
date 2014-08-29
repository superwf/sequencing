class CreateRoles < ActiveRecord::Migration
  def up
    if Rails.env.test?
      create_table :roles do |t|
        t.string :name, null: false, limit: 100
      end
    else
      execute "CREATE OR REPLACE VIEW roles AS SELECT * FROM user_passport.roles"
    end
  end

  def down
    if Rails.env.test?
      execute "DROP TABLE roles "
    else
      execute "DROP VIEW roles "
    end
  end
end
