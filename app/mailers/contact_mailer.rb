class ContactMailer < ApplicationMailer
  def user_email(contact)
    @contact = contact
    subject = "【deKiRU】お問い合わせを受付いたしました"
    mail(
      to: @contact.email,
      subject: subject,
    )
  end

  def admin_email(contact)
    @contact = contact
    subject = "【deKiRU】お問い合わせがありました"
    mail(
      to: ENV.fetch("MAIL_ADMIN") { "admin@example.com" },
      subject: subject,
    )
  end
end
