class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :description
      t.integer :quantity
      t.integer :group_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
