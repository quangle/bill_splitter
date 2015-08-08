class ChangeDefaultValueExpenseStatus < ActiveRecord::Migration
  def change
    change_column_default :expenses, :status, "unresolved"
  end
end
