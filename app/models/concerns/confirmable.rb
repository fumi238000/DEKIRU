module Confirmable
  extend ActiveSupport::Concern

  included do
    # ***** 処理の流れ *****
    # 「確認」ボタンを押す --> エラー（submitted: ""） --> new
    # 「確認」ボタンを押す --> エラー無し（submitted: "1"） --> new（確認画面）

    # 「戻る」ボタンを押す（confirmed: ""） --> submitted: "" --> new
    # 「送信」ボタンを押す（submitted: "1", confirmed: "1"） --> create
    validates :submitted, acceptance: true
    validates :confirmed, acceptance: true

    after_validation :confirming

    private

      def confirming
        # 「送信」ボタンをクリックして，ユーザーの入力にエラーが存在しないとき
        if self.submitted == "" && self.errors.keys == [:submitted]
          self.submitted = "1"
        end
        # 「戻る」ボタンをクリックしたとき
        self.submitted = "" if self.confirmed == ""

        errors.delete :submitted
        errors.delete :confirmed
      end
  end
end
