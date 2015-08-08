class Expense < ActiveRecord::Base
  has_many :users_expenses, inverse_of: :expense
  has_many :owners, through: :users_expenses, source: :user
  has_many :user_expense_share_values
  belongs_to :user
  belongs_to :group

  attr_accessor :user_ids, :user_values

  monetize :cost_cents

  validates :cost_cents, numericality: { greater_than: 0, only_integer: true }
  validate :check_total_manual_cost

  accepts_nested_attributes_for :users_expenses

  def equal_share
    (cost_cents / owners.count) / 100.00
  end

  def unequal_share_for(user)
    (user_expense_share_values.where(user: user).first.share_value_cents) / 100.00
  end

  def share_for(user)
    if owners.include?(user)
      if split_method == 'equally'
        equal_share
      elsif split_method == 'manually'
        unequal_share_for(user)
      end
    else
      0
    end
  end

  def check_total_manual_cost
    if split_method == "manually"
      if user_expense_share_values.map(&:share_value_cents).sum != cost_cents
        errors.add(:base, "Please make sure total share amount adds up to total cost")
      end
    end
  end
end
