class ContactsController < ApplicationController
  def index
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      # ユーザーにメールを送信
      # ContactMailer.user_email(@contact).deliver_now
      # 管理者にメールを送信
      # ContactMailer.admin_email(@contact).deliver_now
      redirect_to root_path, notice: "お問い合わせ内容を受け付けました。"
    else
      render :index
    end
  end

  private

    def contact_params
      params.require(:contact).
        permit(:title, :content, :submitted, :confirmed).
        merge(user_id: current_user.id, remote_ip: request.remote_ip)
    end
end
