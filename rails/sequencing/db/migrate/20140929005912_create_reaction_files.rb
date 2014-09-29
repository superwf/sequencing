class CreateReactionFiles < ActiveRecord::Migration
  def change
    create_table :reaction_files, primary_key: :reaction_id do |t|
      t.timestamps
    end
  end
end
