if Rails.env.production?
  # メール配信に失敗した場合にエラーを発生
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.default_url_options = { host: ENV["HOST_FOR_MAIL"], protocol: "https" }
  ActionMailer::Base.smtp_settings = {
    user_name: "apikey",
    password: ENV["SENDGRID_APIKEY"],
    domain: "heroku.com",
    address: "smtp.sendgrid.net",
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true,
  }
elsif Rails.env.development?
  ActionMailer::Base.default_url_options = { host: "localhost:3000" }
  ActionMailer::Base.delivery_method = :letter_opener_web
end
