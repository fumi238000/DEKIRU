class HomesController < ApplicationController
  def index
    # ここに人気・おすすめ・カテゴリー・キーワードを表示する
    @popularity_contents = Content.first(3) # TODO: 人気ベスト3
    @recommend_contents = Content.first(3) # TODO: おすすめをランダムで3つ表示
  end
end
