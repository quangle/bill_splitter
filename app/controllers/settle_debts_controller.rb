class SettleDebtsController < ApplicationController
  before_filter :authenticate_user!

  def new
    group = Group.find_by_id(params[:group_id])
    user = User.find_by_id(params[:user_id])
    CommonMailer.send_settle_debt_email(current_user, user, group).deliver
    redirect_to detail_balance_group_path(group), notice: "Please wait for your friend to confirm your payment."
  end

  def index
    current_user = User.find_by_id(params[:current_user_id])
    user = User.find_by_id(params[:user_id])
    group = Group.find_by_id(params[:group_id])
    user.confirm_debts_paid_with(group, current_user)
    redirect_to root_path, notice: "You have confirmed #{current_user.name}'s debt payment. He owes you nothing now."
  end
end
