class AddSplitMethodToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :split_method, :string, default: 'equally'
  end
end
