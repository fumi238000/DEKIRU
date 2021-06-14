require "rails_helper"

RSpec.describe Content, type: :model do
  describe "validation" do
    subject { content.valid? }

    context "データが条件を満たす時" do
      let(:content) { build(:content) }
      it "保存ができる" do
        expect(subject).to eq true
      end
    end

    describe "title" do
      context "入力さていない時" do
        let(:content) { build(:content, title: "") }
        it "保存ができない" do
          expect(subject).to eq false
          expect(content.errors[:title]).to include "を入力してください"
        end
      end

      context "16文字の場合" do
        let(:content) { build(:content, title: "1" * 16) }
        it "保存ができる" do
          expect(subject).to eq true
        end
      end

      context "17文字の場合" do
        let(:content) { build(:content, title: "1" * 17) }
        it "保存ができない" do
          expect(subject).to eq false
          expect(content.errors.messages[:title]).to include "は16文字以内で入力してください"
        end
      end

      describe "subtitle" do
        context "入力さていない時" do
          let(:content) { build(:content, subtitle: "") }
          it "保存ができない" do
            expect(subject).to eq false
            expect(content.errors[:subtitle]).to include "を入力してください"
          end
        end

        context "32文字の場合" do
          let(:content) { build(:content, subtitle: "1" * 16) }
          it "保存ができる" do
            expect(subject).to eq true
          end
        end

        context "33文字の場合" do
          let(:content) { build(:content, subtitle: "1" * 33) }
          it "保存ができない" do
            expect(subject).to eq false
            expect(content.errors.messages[:subtitle]).to include "は32文字以内で入力してください"
          end
        end
      end

      describe "comment" do
        context "入力さていない時" do
          let(:content) { build(:content, comment: "") }
          it "保存ができない" do
            expect(subject).to eq false
            expect(content.errors[:comment]).to include "を入力してください"
          end
        end

        context "32文字の場合" do
          let(:content) { build(:content, comment: "1" * 32) }
          it "保存ができる" do
            expect(subject).to eq true
          end
        end

        context "33文字の場合" do
          let(:content) { build(:content, comment: "1" * 33) }
          it "保存ができない" do
            expect(subject).to eq false
            expect(content.errors.messages[:comment]).to include "は32文字以内で入力してください"
          end
        end
      end

      describe "point" do
        context "入力さていない時" do
          let(:content) { build(:content, point: "") }
          it "保存ができない" do
            expect(subject).to eq false
            expect(content.errors[:point]).to include "を入力してください"
          end
        end

        context "32文字の場合" do
          let(:content) { build(:content, point: "1" * 32) }
          it "保存ができる" do
            expect(subject).to eq true
          end
        end

        context "33文字以上の場合" do
          let(:content) { build(:content, point: "1" * 33) }
          it "保存ができない" do
            expect(subject).to eq false
            expect(content.errors.messages[:point]).to include "は32文字以内で入力してください"
          end
        end
      end

      describe "movie_url" do
        context "urlが空の場合" do
          let(:content) { build(:content, movie_url: "") }
          it "エラーが発生する" do
            expect(subject).to eq false
            expect(content.errors.messages[:movie_url]).to include "を入力してください"
          end
        end

        context "urlがyouyubeのURLでない場合" do
          let(:content) { build(:content, movie_url: "https://www.yahoo.co.jp/") }
          it "エラーが発生する" do
            expect(content.save).to eq false
            expect(content.errors.messages[:movie_url]).to include "YouTubeのURL以外は無効です"
          end
        end
      end

      describe "content_delete" do
        context "コンテンツが削除された時" do
          subject { content.destroy }

          create_num = 5
          let(:content) { create(:content) }

          context "そのカテゴリーの作り方が存在する場合" do
            before { create_list(:make, create_num, content_id: content.id) }

            it "紐づいている作り方が削除される" do
              expect { subject }.to change { Make.count }.by(-create_num)
            end
          end

          context "そのカテゴリーの材料が存在する場合" do
            before { create_list(:material, create_num, content_id: content.id) }

            it "紐づいている材料が削除される" do
              expect { subject }.to change { Material.count }.by(-create_num)
            end
          end
        end
      end
    end
  end
end
