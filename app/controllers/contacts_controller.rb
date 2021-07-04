class ContactsController < ApplicationController
  before_action :admin_checker, only: %i[index]

  def index
    @contacts = Contact.order(created_at: :desc)
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      # ユーザーにメールを送信
      ContactMailer.user_email(@contact).deliver_now
      # 管理者にメールを送信
      ContactMailer.admin_email(@contact).deliver_now
      redirect_to root_path, notice: "お問い合わせ内容を受け付けました。"
    else
      render :new
    end
  end

  private

    def contact_params
      if user_signed_in?
        # ログインユーザーの場合
        params.require(:contact).
          permit(:title, :content, :submitted, :confirmed).
          merge(user_id: current_user.id, name: current_user.name, email: current_user.email, remote_ip: request.remote_ip)
      else
        # 未ログインユーザーの場合
        params.require(:contact).
          permit(:title, :content, :submitted, :confirmed, :email, :name).
          merge(user_id: "", remote_ip: request.remote_ip)
      end
    end
end
