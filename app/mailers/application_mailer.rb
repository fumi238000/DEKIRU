class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_SYSTEM") { "system@example.com" }
  layout "mailer"
end
