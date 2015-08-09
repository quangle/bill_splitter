class UserExpenseShareValue < ActiveRecord::Base
  belongs_to :user
  belongs_to :expense

  monetize :share_value_cents

  after_save :settle_expense

  private
  def settle_expense
    if expense.present?
      unless expense.user_expense_share_values.map(&:status).include? 'unresolved'
        expense.update_column(:status, 'resolved')
      end
    end
  end
end
