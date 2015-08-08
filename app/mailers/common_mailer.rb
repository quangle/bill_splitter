class CommonMailer < ActionMailer::Base
  def send_settle_debt_email(current_user, user, group)
    @current_user = current_user
    @user = user
    @group = group
    mail(
      to: user.email,
      from: current_user.email,
      subject: "Congratulations! #{current_user.name} is requesting you to confirm his payment!"
    )
  end
end
