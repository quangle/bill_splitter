class GroupsController < InheritedResources::Base
  custom_actions resource: :balance
  before_filter :set_group

  def balance
  end

  def detail_balance
  end

  def update
    user = User.find_by_email(params[:email])
    if user.present? && !user.groups.include?(@group)
      @group.users << user
      redirect_to action: :show, id: @group.id
      flash[:notice] = "User has been added to the group"
    elsif !user.present?
      CommonMailer.send_invitation_email(params[:email], @group).deliver
      redirect_to action: :show, id: @group.id
      flash[:notice] = "Invitation email has been sent"
    else
      redirect_to action: :show, id: @group.id
      flash[:notice] = "User has already been in group"
    end
  end

  def add_user
    group = Group.find_by_id(params[:group_id])
    if group.present?
      mail_addr = Mail::Address.new(params[:email])
      first_name = mail_addr.local.split(".").first
      last_name = mail_addr.local.split(".").last
      user = User.create(email: params[:email], password: 'password', first_name: first_name, last_name: last_name)
      group.users << user
      redirect_to new_user_session_url, notice: "Default password is \"password\""
    end
  end

  protected
  def set_group
    @group = Group.find_by_id(params[:id])
  end
end
