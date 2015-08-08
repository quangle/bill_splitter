class CreateUserExpenseShareValues < ActiveRecord::Migration
  def change
    create_table :user_expense_share_values do |t|
      t.integer :user_id
      t.integer :expense_id
      t.timestamps null: false
    end
  end
end
