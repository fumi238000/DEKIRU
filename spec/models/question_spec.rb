require "rails_helper"

RSpec.describe Question, type: :model do
  describe "validation" do
    subject { question.valid? }

    context "データが条件を満たす時" do
      let(:question) { build(:question) }
      it "保存ができる" do
        expect(subject).to eq true
      end
    end

    describe "question_content" do
      context "入力されていない時" do
        let(:question) { build(:question, question_content: "") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(question.errors[:question_content]).to include "を入力してください"
        end
      end

      context "100文字の場合" do
        let(:question) { build(:question, question_content: "1" * 100) }
        it "保存ができる" do
          expect(subject).to eq true
        end
      end

      context "101文字の場合" do
        let(:question) { build(:question, question_content: "1" * 101) }
        it "保存ができない" do
          expect(subject).to eq false
          expect(question.errors.messages[:question_content]).to include "は100文字以内で入力してください"
        end
      end
    end
  end
end
