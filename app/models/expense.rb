class Expense < ActiveRecord::Base
  has_many :users_expenses
  has_many :owners, through: :users_expenses, source: :user
  belongs_to :user

  monetize :cost_cents

  validates :cost_cents, numericality: { greater_than: 0, only_integer: true }
end
