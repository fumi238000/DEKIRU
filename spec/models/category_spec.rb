require "rails_helper"

RSpec.describe Category, type: :model do
  describe "validation" do
    subject { category.valid? }

    context "データが条件を満たす時" do
      let(:category) { build(:category) }
      it "保存ができる" do
        expect(subject).to eq true
      end
    end

    describe "name" do
      context "入力さていない時" do
        let(:category) { build(:category, name: "") }

        it "保存ができない" do
          expect(subject).to eq false
          expect(category.errors[:name]).to include "を入力してください"
        end
      end

      context "8文字以上の場合" do
        let(:category) { build(:category, name: "1" * 8) }
        it "保存ができる" do
          expect(subject).to eq true
        end
      end

      context "9文字の場合" do
        let(:category) { build(:category, name: "1" * 9) }
        it "保存ができない" do
          expect(subject).to eq false
          expect(category.errors.messages[:name]).to include "は8文字以内で入力してください"
        end
      end

      describe "category_delete" do
        context "カテゴリーが削除された時" do
          subject { category.destroy }

          let(:category) { create(:category) }

          context "そのカテゴリーを持つコンテンツが存在する場合" do
            before { create_list(:content, 5, category_id: category.id) }

            it "紐づいているコンテンツが削除されない" do
              expect { subject }.to change { Content.count }.by(0)
            end

            it "紐づいているコンテンツのcategory_idがnilになる" do
              content = Content.first
              expect { subject }.to change { content.reload.category_id }.from(content.category_id).to(nil)
            end
          end
        end
      end
    end
  end
end
