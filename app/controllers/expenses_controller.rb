class ExpensesController < ApplicationController
  before_filter :authenticate_user!, :get_group

  def new
    @expense = current_user.expenses.new(group: @group)
  end

  def create
    @expense = current_user.expenses.new(permitted_params)
    permitted_params[:user_ids].each do |user_id|
      @expense.users_expenses.new(user_id: user_id)
    end
    if @expense.save
      redirect_to group_path(@group), notice: "Expense created successfully"
    else
      render :new, group_id: params[:group_id]
    end
  end

  protected
  def get_group
    @group = Group.find_by_id(params[:group_id])
  end

  def permitted_params
    params.require(:expense).permit(:group_id, :description, :cost_cents, :quantity, user_ids: [])
  end
end
