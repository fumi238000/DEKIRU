class ResponsesController < ApplicationController
  before_action :admin_checker, only: %i[new create update edit destroy]
  before_action :set_response, only: %i[update edit destroy]

  def new
    @response = Response.new
    @question_id = params[:question_id]
  end

  def create
    @response = Response.new(response_params)
    if @response.save
      # TODO: リダイレクト先を条件分岐する(content/show or question/index)
      redirect_to questions_path, notice: "質問に対して返信しました"
    else
      @question_id = response_params[:question_id]
      render :new
    end
  end

  def update
    if @response.update(response_params)
      redirect_to content_show_path(@response.question.content.id), notice: "返信内容を更新しました"
    else
      @question_id = response_params[:question_id]
      render :edit
    end
  end

  def edit
    @question_id = params[:question_id]
  end

  def destroy
    @response.destroy!
    @response.question.update!(status: "before")
    redirect_to content_show_path(@response.question.content.id), alert: "返信内容を削除しました"
  end

  private

    def set_response
      @response = Response.find(params[:id])
    end

    def response_params
      params.require(:response).permit(:question_id, :response_content)
    end
end
