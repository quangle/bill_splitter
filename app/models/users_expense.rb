class UsersExpense < ActiveRecord::Base
  belongs_to :user
  belongs_to :expense
end
