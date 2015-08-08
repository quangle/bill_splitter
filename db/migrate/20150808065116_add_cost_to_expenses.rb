class AddCostToExpenses < ActiveRecord::Migration
  def change
    add_monetize :expenses, :cost
  end
end
