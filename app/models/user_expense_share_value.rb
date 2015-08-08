class UserExpenseShareValue < ActiveRecord::Base
  belongs_to :user
  belongs_to :expense

  monetize :share_value_cents
end
