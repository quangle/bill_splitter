require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:other_user) { create(:user) }
  before do
    sign_in user
  end

  describe "GET new" do
    it "builds a new expense" do
      get :new, group_id: group.id
      expect(assigns(:expense)).to be_a_new Expense
      expect(assigns(:group)).to eq group
    end
  end

  describe 'GET edit' do
    let!(:expense) { create(:expense, cost: 10, owners: [user], user: user) }
    let(:user) { create(:user) }
    let(:user_expense) { build(:user_expense_share_value, status: 'resolved', expense: expense) }

    it 'get the expense for edit' do
      get :edit, group_id: group.id, id: expense.id
      expect(assigns(:expense)).to eq expense
      expect(assigns(:group)).to eq group
    end
  end

  describe "POST create" do
    context "params is valid" do
      let(:params) {
        {
          group_id: group.id,
          expense: {
            group_id: group.id,
            description: "food for thought",
            cost: 10.00,
            quantity: 1,
            user_values: [ ["0", {user_id: user.id, user_value: 2.00}], ["1", {user_id: other_user.id, user_value: 8.00}]]
          }
        }
      }
      it "saves expense" do
        expect {
          post :create, params
        }.to change(user.expenses, :count).by(1)
        expect(assigns(:expense).owners).to eq [user, other_user]
        expect(response).to redirect_to group_path(group)
        expect(flash[:notice]).to eq "Expense created successfully"
      end
    end

    context "params is not valid" do
      let(:params) {
        {
          group_id: group.id,
          expense: {
            group_id: group.id,
            description: "food for thought",
            cost: 0,
            quantity: 1,
            user_values: [ ["0", {user_id: user.id, user_value: 2.00}], ["1", {user_id: other_user.id, user_value: 8.00}]]
          }
        }
      }
      it "renders new page" do
        expect {
          post :create, params
        }.not_to change(user.expenses, :count)
        expect(response).to render_template :new
      end
    end
  end

  describe "POST update" do
    let!(:expense) { create(:expense, cost: 10, owners: [user], user: user, group: group) }
    let(:user_expense) { build(:user_expense_share_value, status: 'resolved', expense: expense, share_value: 10.00) }

    context "params is valid" do
      let(:params) {
        {
          group_id: group.id,
          id: expense.id,
          expense: {
            group_id: group.id,
            description: "food for thought",
            cost: 10.00,
            quantity: 1,
            user_values: [ ["0", {user_id: user.id, user_value: 2.00}], ["1", {user_id: other_user.id, user_value: 8.00}]]
          }
        }
      }
      it "updates expense" do
        expect {
          post :update, params
        }.not_to change(user.expenses, :count)
        expect(assigns(:expense).owners).to eq [user]
        expect(response).to redirect_to group_path(group)
        expect(flash[:notice]).to eq "Expense updated successfully"
      end
    end
  end
end
