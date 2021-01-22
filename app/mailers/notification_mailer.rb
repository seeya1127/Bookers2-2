class NotificationMailer < ApplicationMailer
  default :from => ENV['EMAIL']
  
  def send_signup_email(user)
      @user = user
      mail(:subject => "会員登録が完了しました。",to: user.email)
  end
end
