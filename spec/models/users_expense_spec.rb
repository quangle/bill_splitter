require 'rails_helper'

RSpec.describe UsersExpense, type: :model do
  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:expense) }
end
