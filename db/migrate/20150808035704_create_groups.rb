class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :group_type

      t.timestamps null: false
    end
  end
end
