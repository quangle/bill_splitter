class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :users_groups
  has_many :groups, through: :users_groups
  has_many :expenses
  has_many :users_expenses
  has_many :owned_expenses, through: :users_expenses, source: :expense

  after_create :create_personal_group

  def name
    "#{first_name.to_s} #{last_name.to_s}"
  end
  private
  def create_personal_group
    group = groups.create(name: "My Personal Expenses", group_type: "personal")
  end
end
