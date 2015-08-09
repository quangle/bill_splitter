require 'rails_helper'

RSpec.describe UserExpenseShareValue, type: :model do
  let!(:expense) { create(:expense, cost: 10, owners: [user], user: user) }
  let(:user) { create(:user) }
  let(:user_expense) { build(:user_expense_share_value, status: 'resolved', expense: expense) }

  describe "#settle_expense" do
    it 'updates expense status if there is no user_expense unresolved left' do
      expect{
        user_expense.save
      }.to change(expense, :status).from('unresolved').to('resolved')
    end
  end
end
