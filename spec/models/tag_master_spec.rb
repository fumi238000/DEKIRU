require "rails_helper"

RSpec.describe TagMaster, type: :model do
  describe "validation" do
    subject { tag_master.valid? }

    context "データが条件を満たす時" do
      let(:tag_master) { build(:tag_master) }
      it "保存ができる" do
        expect(subject).to eq true
      end
    end

    describe "tag_name" do
      context "入力さていない時" do
        let(:tag_master) { build(:tag_master, tag_name: "") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(tag_master.errors[:tag_name]).to include "を入力してください"
        end
      end

      context "10文字の場合" do
        let(:tag_master) { build(:tag_master, tag_name: "1" * 10) }
        it "保存ができる" do
          expect(subject).to eq true
        end
      end

      context "11文字の場合" do
        let(:tag_master) { build(:tag_master, tag_name: "1" * 11) }
        it "保存ができない" do
          expect(subject).to eq false
          expect(tag_master.errors.messages[:tag_name]).to include "は10文字以内で入力してください"
        end
      end

      context "すでに同じ名前が存在してする場合" do
        before { create(:tag_master, tag_name: "タグ") }

        let(:tag_master) { build(:tag_master, tag_name: "タグ") }

        it "保存ができない" do
          expect(subject).to eq false
          expect(tag_master.errors[:tag_name]).to include "はすでに存在します"
        end
      end
    end
  end
end
