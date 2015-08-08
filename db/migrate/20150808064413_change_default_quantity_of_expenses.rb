class ChangeDefaultQuantityOfExpenses < ActiveRecord::Migration
  def change
    change_column_default :expenses, :quantity, 1
  end
end
