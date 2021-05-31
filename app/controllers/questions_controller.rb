class QuestionsController < ApplicationController
  # 質問できるのは、ログインユーザーのみ

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
      # 教材を見て、エラーを吐かせるようにする
      @question = current_user.question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:content_id, :question_content)
    end
end
