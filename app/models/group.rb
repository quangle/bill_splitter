class Group < ActiveRecord::Base
  has_many :users_groups, dependent: :destroy
  has_many :users, through: :users_groups
  has_many :expenses
end
