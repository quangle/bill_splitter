require 'rails_helper'

describe User do
  it { expect(subject).to have_many(:users_groups) }
  it { expect(subject).to have_many(:groups).through(:users_groups) }
  it { expect(subject).to have_many(:expenses) }
  it { expect(subject).to have_many(:users_expenses) }
  it { expect(subject).to have_many(:owned_expenses).through(:users_expenses) }

  describe "#create_personal_group" do
    let(:user) { build(:user) }
    let(:group) { user.groups.last }
    it "creates default group for personal expenses" do
      expect{
        user.save
      }.to change(user.groups, :count).by 1
      expect(group.name).to eq "My Personal Expenses"
    end
  end

  describe "#name" do
    let(:user) { create(:user, first_name: "first", last_name: "last") }
    it 'returns user full name' do
      expect(user.name).to eq "first last"
    end

  end
end
