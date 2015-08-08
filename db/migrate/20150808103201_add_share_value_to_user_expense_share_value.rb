class AddShareValueToUserExpenseShareValue < ActiveRecord::Migration
  def change
    add_monetize :user_expense_share_values, :share_value
  end
end
