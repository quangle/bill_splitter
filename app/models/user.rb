class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :users_groups
  has_many :groups, through: :users_groups
  has_many :expenses
  has_many :users_expenses
  has_many :owned_expenses, through: :users_expenses, source: :expense
  has_many :user_expense_share_values

  after_create :create_personal_group

  def name
    "#{first_name.to_s} #{last_name.to_s}"
  end

  def current_debt_for(group, user)
    total_debt = 0
    if group.users.include?(user) && user != self
      owned_expenses.where(group: group, user: user, status: 'active').each do |expense|
        unless expenses.include? expense
          total_debt += expense.share_for(self)
        end
      end
    end
    total_debt
  end

  def current_loan_for(group, user)
    total_loan = 0
    if group.users.include?(user) && user != self
      expenses.where(group: group, status: 'active').each do |expense|
        total_loan += expense.share_for(user)
      end
    end
    total_loan
  end

  private
  def create_personal_group
    group = groups.create(name: "My Personal Expenses", group_type: "personal")
  end
end
