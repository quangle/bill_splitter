require 'rails_helper'

describe User do
  it { expect(subject).to have_many(:users_groups) }
  it { expect(subject).to have_many(:groups).through(:users_groups) }
  it { expect(subject).to have_many(:expenses) }
  it { expect(subject).to have_many(:users_expenses) }
  it { expect(subject).to have_many(:owned_expenses).through(:users_expenses) }

  let!(:user) { create(:user) }
  let!(:expense) { create(:expense, status: 'unresolved', cost: 100, owners: [user1, user2], user: user, group: group) }
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:group) { create(:group, users: [user, user1, user2]) }

  describe "#create_personal_group" do
    let(:test_user) { build(:user) }
    let(:test_group) { test_user.groups.last }
    it "creates default group for personal expenses" do
      expect{
        test_user.save
      }.to change(test_user.groups, :count).by 1
      expect(test_group.name).to eq "My Personal Expenses"
    end
  end

  describe "#name" do
    let(:user) { create(:user, first_name: "first", last_name: "last") }
    it 'returns user full name' do
      expect(user.name).to eq "first last"
    end
  end

  describe "#current_debt_for(group, user)" do
    it 'returns current total debt of current_user' do
      expect(user1.current_debt_for(group, user)).to eq 50
      expect(user2.current_debt_for(group, user)).to eq 50
    end
  end

  describe "#current_loan_for(group, user)" do
    it 'returns current total debt of current_user' do
      expect(user.current_loan_for(group, user1)).to eq 50
      expect(user.current_loan_for(group, user2)).to eq 50
    end
  end

  describe "#confirm_debts_paid_with(group, user)" do
    it 'marks all user_expense_share_values as resolved' do
      expect{
        user.confirm_debts_paid_with(group, user1)
      }.not_to change(user1.user_expense_share_values.first, :status)
      expect{
        user.confirm_debts_paid_with(group, user2)
      }.not_to change(user2.user_expense_share_values.first, :status)
    end
  end
end
