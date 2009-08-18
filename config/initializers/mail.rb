ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :enable_starttls_auto => true,
  :domain => "gmail.com",
  :authentication => :plain,
  :user_name => "gaoxh04@gmail.com",
  :password => "20041065"
}
