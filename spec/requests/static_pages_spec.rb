require 'spec_helper'

describe "StaticPages" do

  subject { page }
  
  describe "Home page" do
    before { visit root_path }
    it { should have_title(full_title('')) }
    it { should have_content('欢迎来到彩虹世界') }
    it { should_not have_title('| Home') }

    describe "显示微博" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user:user, content:"rain")
        FactoryGirl.create(:micropost, user:user, content:"bow" )
        sign_in user
        visit root_path
      end

      it "应该显示所有微博" do
        user.feed.each do |fed|
          expect(page).to have_content(fed.content)
        end
      end
    end

    describe "显示关注/被关注数量" do
      let(:user) { FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        user.follow!(other_user)
        visit root_path
      end

      it { should have_link("1 关注") }
      it { should have_link("0 粉丝") }

      describe "关注列表" do
        before { visit following_user_path(user) }
        it { should have_title(full_title('关注列表')) }
        it { should have_content('关注列表') }
        it { should have_link(other_user.name) }
      end
      
      describe "粉丝列表" do
        before do
          sign_in other_user
          visit followers_user_path(other_user) 
        end
        it { should have_title(full_title('粉丝列表')) }
        it { should have_content('粉丝列表') }
        it { should have_link(user.name) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    it { should have_title(full_title('帮助')) }
    it { should have_content('帮助') }
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_title(full_title('联系')) }
    it { should have_content('联系') }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_title(full_title('关于我们')) }
    it { should have_content('关于我们') }
  end
  

end
