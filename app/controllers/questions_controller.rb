class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  # 質問できるのは、ログインユーザーのみ

  def index
    # 質問一覧画面
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to content_show_path(@question.content.id), notice: "質問を作成しました。返信をお待ちください。"
    else
      render :new
    end
  end

  def destroy
    @question.destroy!
    redirect_to content_show_path(@question.content.id), alert: "質問をを削除しました"
  end

  private

    def set_question
      # エラーを吐かせるようにする
      @question = current_user.question.find(params[:id])
      # @post = current_user.posts.find_by(id: params[:id])
      # redirect_to root_path, alert: "権限がありません" if @post.nil?
    end

    def question_params
      params.require(:question).permit(:content_id, :question_content)
    end
end
