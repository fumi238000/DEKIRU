require "rails_helper"

RSpec.describe Make, type: :model do
  describe "validation" do
    subject { make.valid? }

    context "データが条件を満たす時" do
      let(:make) { build(:make) }
      it "保存ができる" do
        expect(subject).to eq true
      end
    end

    describe "detail" do
      context "入力さていない時" do
        let(:make) { build(:make, detail: "") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(make.errors[:detail]).to include "を入力してください"
        end
      end

      context "32文字以上の場合" do
        let(:make) { build(:make, detail: "1" * 33) }
        it "保存ができない" do
          expect(subject).to eq false
          expect(make.errors.messages[:detail]).to include "は32文字以内で入力してください"
        end
      end
    end
  end
end
