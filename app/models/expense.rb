class Expense < ActiveRecord::Base
  has_many :users_expenses, inverse_of: :expense, dependent: :destroy
  has_many :owners, through: :users_expenses, source: :user
  has_many :user_expense_share_values, dependent: :destroy
  belongs_to :user
  belongs_to :group

  attr_accessor :user_ids, :user_values

  monetize :cost_cents

  validates :cost_cents, numericality: { greater_than: 0, only_integer: true }
  validate :check_total_manual_cost

  accepts_nested_attributes_for :users_expenses

  after_create :save_equal_share, :mark_self_expense_value_as_resolved

  def share_for(user, view_settled = false)
    view_settled ? status = ['resolved', 'unresolved'] : status = 'unresolved'
    if owners.include?(user)
      (user_expense_share_values.where(user: user, status: status).first.try(:share_value_cents).to_i) / 100.00
    else
      0
    end
  end

  def resolved(user)
    share = user_expense_share_values.find_by_user_id(user.id)
    if share.present?
      share.status == 'resolved'
    else
      false
    end
  end

  def check_total_manual_cost
    if split_method == "manually"
      if user_expense_share_values.map(&:share_value_cents).sum != cost_cents
        errors.add(:base, "Please make sure total share amount adds up to total cost")
      end
    end
  end

  def delete_all_share
    owners.each do |owner|
      owner.user_expense_share_values.where(expense_id: self.id).destroy_all
    end
  end

  private
  def save_equal_share
    if split_method == 'equally'
      share_value = cost_cents / owners.count
      owners.each do |owner|
        owner.user_expense_share_values.create(share_value_cents: share_value, expense_id: self.id)
      end
    end
  end

  def mark_self_expense_value_as_resolved
    user_expense_share_values.where(user: self.user).each { |ue| ue.update_column(:status, 'resolved') }
  end
end
