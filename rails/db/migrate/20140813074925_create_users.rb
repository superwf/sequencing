class CreateUsers < ActiveRecord::Migration
  def up
    if Rails.env.test?
      create_table :users do |t|
        t.string :name, null: false, limit: 100
        t.column :department_id, 'INT UNSIGNED', null: false
        t.column :role_id, 'INT UNSIGNED', null: false
        t.column :active, 'TINYINT(1) UNSIGNED', null: false, default: 1
        t.string :signature
        t.timestamps
        ## Database authenticatable
        t.string :email, null: false
        t.string :encrypted_password, null: false, default: ''

        ## Recoverable
        t.string   :reset_password_token
        t.datetime :reset_password_sent_at

        ## Rememberable
        t.datetime :remember_created_at

        ## Trackable
        t.column  :sign_in_count, 'INT UNSIGNED', default: 0, null: false
        t.datetime :current_sign_in_at
        t.datetime :last_sign_in_at
        t.string   :current_sign_in_ip
        t.string   :last_sign_in_ip

        ## Confirmable
        t.string   :confirmation_token
        t.datetime :confirmed_at
        t.datetime :confirmation_sent_at
        t.string   :unconfirmed_email # Only if using reconfirmable

        # Lockable
         t.column  :failed_attempts, 'INT UNSIGNED', default: 0, null: false # Only if lock strategy is :failed_attempts
         t.string   :unlock_token # Only if unlock strategy is :email or :both
         t.datetime :locked_at

      end
      add_index :users, :department_id
      add_index :users, :role_id
      add_index :users, :email, unique: true
    else
      execute "CREATE OR REPLACE VIEW users AS SELECT * FROM user_passport.users"
    end
  end

  def down
    if Rails.env.test?
      execute "DROP TABLE users "
    else
      execute "DROP VIEW users "
    end
  end
end
