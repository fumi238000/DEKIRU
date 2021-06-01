require "rails_helper"

RSpec.describe Review, type: :model do
  describe "validation" do
    subject { review.valid? }

    context "データが条件を満たす時" do
      let(:review) { build(:review) }
      it "保存ができる" do
        expect(subject).to eq true
      end
    end

    describe "comment" do
      context "入力さていない時" do
        let(:review) { build(:review, comment: "") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(review.errors[:comment]).to include "を入力してください"
        end
      end

      context "500文字以上の場合" do
        let(:review) { build(:review, comment: "1" * 501) }
        it "保存ができない" do
          expect(subject).to eq false
          expect(review.errors[:comment]).to include "は500文字以内で入力してください"
        end
      end

      describe "image" do
        context "入力さていない時" do
          let(:review) { build(:review, image: "") }
          it "保存ができない" do
            expect(subject).to eq false
            expect(review.errors[:image]).to include "を入力してください"
          end
        end
      end
    end
  end
end
