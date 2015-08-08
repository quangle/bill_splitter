class GroupsController < InheritedResources::Base
  custom_actions resource: :balance
  def balance
    @group = Group.find_by_id(params[:id])
  end
end
