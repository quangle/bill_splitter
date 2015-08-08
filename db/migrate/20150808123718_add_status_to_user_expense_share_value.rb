class AddStatusToUserExpenseShareValue < ActiveRecord::Migration
  def change
    add_column :user_expense_share_values, :status, :string, default: "unresolved"
  end
end
