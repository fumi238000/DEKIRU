class QuestionsController < ApplicationController
  before_action :admin_checker, only: %i[destroy]
  before_action :user_general_checker, only: %i[create]
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_question, only: %i[destroy]

  def index
    # 質問一覧画面
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to content_show_path(@question.content.id), notice: "質問を作成しました。返信をお待ちください。"
    else
      redirect_to content_show_path(@question.content.id), alert: "エラーが発生しました。100文字以内で再度入力してください。"
    end
  end

  def destroy
    if @question.response_nil?  # 返信が存在している場合、削除できない
      @question.destroy!
      redirect_to content_show_path(@question.content.id), alert: "質問を削除しました"
    else
      redirect_to content_show_path(@question.content.id), alert: "この質問は削除することができません"
    end
  end

  private

    def set_question
      case current_user.user_type
      when "admin"
        @question = Question.find(params[:id])
      when "general"
        @question = current_user.questions.find_by(id: params[:id])
        redirect_to root_path, alert: "権限がありません" if @question.nil?
      end
    end

    def question_params
      params.require(:question).permit(:content_id, :question_content)
    end
end
