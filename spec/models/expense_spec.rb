require 'rails_helper'

RSpec.describe Expense, type: :model do
  it { expect(subject).to have_many(:users_expenses) }
  it { expect(subject).to have_many(:owners).through(:users_expenses) }
  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:group) }
  it { expect(subject).to validate_numericality_of(:cost_cents).is_greater_than(0).only_integer }

  let(:expense) { create(:expense, status: 'unresolved', cost: 100, owners: [user1, user2]) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user_expense_share_value1) { expense.user_expense_share_values.where(user_id: user1.id).first }
  let(:user_expense_share_value2) { expense.user_expense_share_values.where(user_id: user1.id).first }

  describe "#share_for(user)" do
    context 'view only unsettled share' do
      before do
        user_expense_share_value1.update_column(:status, 'resolved')
      end

      it 'only returns value of unsettled share' do
        expect(expense.share_for(user1)).to eq 0
        expect(expense.share_for(user2)).to eq 50
      end
    end

    context 'view settled share' do
      before do
        user_expense_share_value1.update_column(:status, 'resolved')
      end

      it 'returns value of settled share' do
        expect(expense.share_for(user1, true)).to eq 50
        expect(expense.share_for(user2, true)).to eq 50
      end
    end
  end

  describe "#resolved?(user)" do
    before do
      user_expense_share_value1.update_column(:status, 'resolved')
    end

    it 'returns appropriate results' do
      expect(expense.resolved?(user1)).to be true
      expect(expense.resolved?(user2)).to be false
    end
  end

  describe "#check_total_manual_cost" do
    before do
      expense.update_column(:split_method, 'manually')
      user_expense_share_value1.share_value = 49
      user_expense_share_value1.save
    end

    it 'invalidate expense object when sum does not match cost' do
      expect(expense.valid?).to be false
    end
  end

  describe "#delete_all_shares" do
    before do
      expense
    end
    
    it 'destroy all shares' do
      expect{
        expense.delete_all_shares
      }.to change(UserExpenseShareValue, :count).by(-2)
    end
  end

  describe "#save_equal_shares" do
    it 'creates shares for each owner' do
      expect(expense.user_expense_share_values.count).to eq 2
    end
  end
end
