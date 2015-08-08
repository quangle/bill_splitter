class Expense < ActiveRecord::Base
  has_many :users_expenses
  has_many :owners, through: :users_expenses, source: :user
  belongs_to :user
end
