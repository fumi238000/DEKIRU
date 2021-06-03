require "rails_helper"

RSpec.describe Material, type: :model do
  describe "validation" do
    subject { material.valid? }

    context "データが条件を満たす時" do
      let(:material) { build(:material) }
      it "保存ができる" do
        expect(subject).to eq true
      end
    end

    describe "name" do
      context "入力さていない時" do
        let(:material) { build(:material, name: "") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(material.errors[:name]).to include "を入力してください"
        end
      end

      context "16文字の場合" do
        let(:material) { build(:material, name: "1" * 16) }
        it "保存ができる" do
          expect(subject).to eq true
        end
      end

      context "17文字の場合" do
        let(:material) { build(:material, name: "1" * 17) }
        it "保存ができない" do
          expect(subject).to eq false
          expect(material.errors.messages[:name]).to include "は16文字以内で入力してください"
        end
      end
    end

    describe "amount" do
      context "入力さていない時" do
        let(:material) { build(:material, amount: "") }
        it "エラーが出力される" do
          expect(subject).to eq false
          expect(material.errors[:amount]).to include "を入力してください"
        end
      end

      context "5文字の場合" do
        let(:material) { build(:material, amount: "1" * 5) }
        it "保存ができる" do
          expect(subject).to eq true
        end
      end

      context "6文字の場合" do
        let(:material) { build(:material, amount: "1" * 6) }
        it "エラーが出力される" do
          expect(subject).to eq false
          expect(material.errors.messages[:amount]).to include "は5文字以内で入力してください"
        end
      end

      context "数字以外の場合" do
        let(:material) { build(:material, amount: "a" * 5) }
        it "エラーが出力される" do
          expect(subject).to eq false
          expect(material.errors.messages[:amount]).to include "は数値で入力してください"
        end
      end
    end

    describe "unit" do
      context "入力さていない時" do
        let(:material) { build(:material, unit: "") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(material.errors[:unit]).to include "を入力してください"
        end
      end

      context "5文字の場合" do
        let(:material) { build(:material, unit: "1" * 5) }
        it "保存ができる" do
          expect(subject).to eq true
        end
      end

      context "6文字の場合" do
        let(:material) { build(:material, unit: "1" * 6) }
        it "保存ができない" do
          expect(subject).to eq false
          expect(material.errors.messages[:unit]).to include "は5文字以内で入力してください"
        end
      end
    end
  end
end
