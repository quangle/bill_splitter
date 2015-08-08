class GroupsController < InheritedResources::Base
  custom_actions resource: :balance
  before_filter :set_group
  
  def balance
  end

  def detail_balance
  end

  protected
  def set_group
    @group = Group.find_by_id(params[:id])
  end
end
