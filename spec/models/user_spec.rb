require "rails_helper"

RSpec.describe User, type: :model do
  describe "validation" do
    subject { user.valid? }

    context "データが条件を満たす時" do
      let(:user) { build(:user) }
      it "保存ができる" do
        expect(subject).to eq true
      end
    end

    describe "name" do
      context "入力さていない時" do
        let(:user) { build(:user, name: "") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(user.errors[:name]).to include "を入力してください"
        end
      end

      context "16文字の場合" do
        let(:user) { build(:user, name: "1" * 16) }
        it "保存できる" do
          expect(subject).to eq true
        end
      end

      context "17文字の場合" do
        let(:user) { build(:user, name: "1" * 17) }

        it "保存ができない" do
          expect(subject).to eq false
          expect(user.errors.messages[:name]).to include "は16文字以内で入力してください"
        end
      end

      context "他のユーザと重複している時" do
        before { create(:user, name: "名前") }

        let(:user) { build(:user, name: "名前") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(user.errors.messages[:name]).to include "はすでに存在します"
        end
      end
    end

    describe "email" do
      context "入力さていない時" do
        let(:user) { build(:user, email: "") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(user.errors[:email]).to include "を入力してください"
        end
      end

      context "他のユーザと重複している時" do
        before { create(:user, email: "sample@sample.com") }

        let(:user) { build(:user, email: "sample@sample.com") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(user.errors.messages[:email]).to include "はすでに存在します"
        end
      end
    end

    describe "password" do
      context "入力さていない時" do
        let(:user) { build(:user, password: "") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(user.errors[:password]).to include "を入力してください"
        end
      end

      context "7文字の場合" do
        let(:user) { build(:user, password: "1234567") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(user.errors.messages[:password]).to include "は8文字以上で入力してください"
        end
      end

      context "8文字の場合" do
        let(:user) { build(:user, password: "1-34_67@") }
        it "保存できる" do
          expect(subject).to eq true
        end
      end

      context "16文字の場合" do
        let(:user) { build(:user, password: "1234567890abcdef") }
        it "保存できる" do
          expect(subject).to eq true
        end
      end

      context "17文字の場合" do
        let(:user) { build(:user, password: "1234567890abcdefg") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(user.errors.messages[:password]).to include "は16文字以内で入力してください"
        end

        context "半角英数字と許可する記号('@','-','_')の場合" do
          let(:user) { build(:user, password: "1234567@90-23_56") }
          it "保存できる" do
            expect(subject).to eq true
          end
        end

        context "許可しない記号('%')が含まれているとき" do
          let(:user) { build(:user, password: "1234567%") }
          it "保存ができない" do
            expect(subject).to eq false
            expect(user.errors.messages[:password]).to include "で利用できるのは、半角英数字および記号(@, -, _)のみです。"
          end
        end
      end
    end
  end
end
