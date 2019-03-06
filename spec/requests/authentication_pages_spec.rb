require 'spec_helper'

describe "AuthenticationPages" do
    let(:user) { FactoryGirl.create(:user) }
    subject { page }

    describe "未登录用户" do

        describe "访问编辑页面" do
            before { visit edit_user_path(user) }
            it { should have_title(full_title('登录')) }
        end

        describe "向用户提交更新操作" do
            before { patch user_path(user) }
            specify{ expect(response).to redirect_to(signin_path) }
        end
        
        describe "访问所有用户列表" do
            before { visit users_path }
            it { should have_title(full_title('登录')) }
        end
    end

    describe "已登录用户" do
        let(:other_user) { FactoryGirl.create(:user) }
        before { sign_in user, no_capybara:true }
        describe "访问别人的编辑页面" do
            before { visit edit_user_path(other_user)}
            it { should_not have_title(full_title('更改信息')) }
        end

        describe "向别的用户提交更新操作" do
            before { patch user_path(other_user) }
            specify{ expect(response).to redirect_to(root_path) }
        end
    end

    describe "非管理员用户" do
        let(:other_user) { FactoryGirl.create(:user) }
        before { sign_in user, no_capybara:true }
        describe "向用户提交删除操作" do
            before { delete user_path(other_user) }
            specify { expect(response).to redirect_to(root_path) }
        end
    end
end
