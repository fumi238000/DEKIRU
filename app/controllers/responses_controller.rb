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
      redirect_to content_show_path(@response.question.content.id), notice: "質問に対して返信しました"
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
