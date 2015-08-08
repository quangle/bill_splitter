require 'rails_helper'

RSpec.describe Expense, type: :model do
  it { expect(subject).to have_many(:users_expenses) }
  it { expect(subject).to have_many(:owners).through(:users_expenses) }
  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:group) } 
  it { expect(subject).to validate_numericality_of(:cost_cents).is_greater_than(0).only_integer }
end
