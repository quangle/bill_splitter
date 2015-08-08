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

  describe "POST create" do
    context "params is valid" do
      let(:params) {
        {
          group_id: group.id,
          expense: {
            group_id: group.id,
            description: "food for thought",
            cost_cents: 100,
            quantity: 1,
            user_ids: [user.id, other_user.id]
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
            cost_cents: 0,
            quantity: 1,
            user_ids: [user.id, other_user.id]
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
end
