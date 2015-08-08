class ExpensesController < ApplicationController
  before_filter :authenticate_user!, :get_group

  def new
    @expense = current_user.expenses.new(group: @group)
  end

  def create
    @expense = current_user.expenses.new(permitted_params)
    params[:expense][:user_values].each do |user_value|
      user_id = user_value.last[:user_id]
      share_value = user_value.last[:user_value]
      if user_id.present?
        @expense.users_expenses.new(user_id: user_id)
        if permitted_params[:split_method] == "manually"
          @expense.user_expense_share_values.new(share_value: share_value, user_id: user_id)
        end
      end
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
    params.require(:expense).permit(:group_id, :description, :cost, :quantity, :split_method, :user_values)
  end
end
