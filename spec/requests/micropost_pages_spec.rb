require 'spec_helper'

describe "MicropostPages" do
  let(:user) { FactoryGirl.create(:user) }

  subject { page }


  describe "创建微博" do
    
    let(:submit) { "创建微博" }
    before do
      sign_in user
      visit root_path
    end

    describe "信息无效时" do
      it "应该创建失败" do
        expect{ click_button submit }.not_to change(Micropost, :count)
      end

      describe "失败后" do
        before { click_button submit }
        it { should have_content('error') }
      end
    end

    describe "信息有效时" do
      before { fill_in "micropost_content", with:"welcome to randow app" }

      it "应该创建成功" do
        expect{ click_button submit }.to change(Micropost, :count).by(1)
      end

      describe "成功后" do
        before { click_button submit }
        it { should have_selector('div.alert.alert-success', text: "创建成功") }
      end
    end

    describe "删除微博" do
      before do 
        FactoryGirl.create(:micropost, user:user) 
        visit root_path
      end
      it "应该删除" do
        expect{ click_link "删除" }.to change(Micropost, :count).by(-1)
      end
      
      describe "删除后" do
        before { click_link "删除" }
        it { should have_selector('div.alert.alert-success', text:"删除成功") }
      end
    end
  end

end
