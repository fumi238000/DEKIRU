require "rails_helper"

RSpec.describe Response, type: :model do
  describe "validation" do
    subject { response.valid? }

    context "データが条件を満たす時" do
      let(:response) { build(:response) }
      it "保存ができる" do
        expect(subject).to eq true
      end
    end

    describe "response_content" do
      context "入力されていない時" do
        let(:response) { build(:response, response_content: "") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(response.errors[:response_content]).to include "を入力してください"
        end
      end

      context "100文字以上の場合" do
        let(:response) { build(:response, response_content: "1" * 101) }
        it "保存ができない" do
          expect(subject).to eq false
          expect(response.errors.messages[:response_content]).to include "は100文字以内で入力してください"
        end
      end
    end
  end
end
