require 'rails_helper'

RSpec.describe Expense, type: :model do
  it { expect(subject).to have_many(:users_expenses) }
  it { expect(subject).to have_many(:owners).through(:users_expenses) }
  it { expect(subject).to belong_to(:user) }
end
