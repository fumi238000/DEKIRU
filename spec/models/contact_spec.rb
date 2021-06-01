require "rails_helper"

RSpec.describe Contact, type: :model do
  describe "validation" do
    subject { contact.valid? }

    context "データが条件を満たす時" do
      let(:contact) { build(:contact) }
      it "保存ができる" do
        expect(subject).to eq true
      end
    end

    describe "title" do
      context "入力さていない時" do
        let(:contact) { build(:contact, title: "") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(contact.errors[:title]).to include "を入力してください"
        end
      end

      context "32文字の場合" do
        let(:contact) { build(:contact, title: "1" * 32) }
        it "保存ができる" do
          expect(subject).to eq true
        end
      end

      context "33文字の場合" do
        let(:contact) { build(:contact, title: "1" * 33) }
        it "保存ができない" do
          expect(subject).to eq false
          expect(contact.errors.messages[:title]).to include "は32文字以内で入力してください"
        end
      end

      describe "content" do
        context "入力さていない時" do
          let(:contact) { build(:contact, content: "") }
          it "保存ができない" do
            expect(subject).to eq false
            expect(contact.errors[:content]).to include "を入力してください"
          end
        end

        context "1000文字の場合" do
          let(:contact) { build(:contact, content: "1" * 1000) }
          it "保存ができる" do
            expect(subject).to eq true
          end
        end

        context "1001文字の場合" do
          let(:contact) { build(:contact, content: "1" * 1001) }
          it "保存ができない" do
            expect(subject).to eq false
            expect(contact.errors.messages[:content]).to include "は1000文字以内で入力してください"
          end
        end
      end
    end
  end
end
