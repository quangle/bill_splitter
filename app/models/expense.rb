class Expense < ActiveRecord::Base
  has_many :users_expenses, inverse_of: :expense
  has_many :owners, through: :users_expenses, source: :user
  belongs_to :user
  belongs_to :group

  attr_accessor :user_ids

  monetize :cost_cents

  validates :cost_cents, numericality: { greater_than: 0, only_integer: true }

  accepts_nested_attributes_for :users_expenses
end
