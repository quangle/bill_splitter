class AddStatusToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :status, :string, default: 'active'
  end
end
