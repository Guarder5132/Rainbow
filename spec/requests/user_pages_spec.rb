require 'spec_helper'

describe "UsersPages" do
  let(:user) { FactoryGirl.create(:user) }

  subject{ page }

  describe "Signup page" do
    before { visit signup_path }
    it { should have_title(full_title('注册')) }
    it { should have_content('注册新用户') }
  end

  describe "show page" do
    let!(:m1) { FactoryGirl.create(:micropost,user:user, content: "foo") }
    let!(:m2) { FactoryGirl.create(:micropost,user:user, content: "bar") }
    before { visit user_path(user) }

    it { should have_title(full_title(user.name)) }
    it { should have_content(user.name) }

    it { should have_content(m1.content) }
    it { should have_content(m2.content) }
    it { should have_content(user.microposts.count) }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "注册" }

    describe "信息无效时" do

      it "应该注册失败" do
        expect{ click_button submit }.not_to change(User, :count)
      end
      
      describe "注册失败后" do
        before { click_button submit }
        it { should have_title('注册') }
        it { should have_content('error') }
      end

    end

    describe "信息有效时" do

      before do
        fill_in "用户名",   with: "Rainbow"
        fill_in "邮箱",     with: "rain@example.com"
        fill_in "密码",     with: "foobar"
        fill_in "确认密码",  with: "foobar"
      end

      it "应该注册成功" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "注册成功后" do
        before { click_button submit }
        it { should have_selector('div.alert.alert-success', text:"注册成功") }  
        it { should have_title(full_title('Rainbow')) }
        it { should have_link('登出',href: signout_path) }
      end
      
    end
  end

  describe "signin page" do
    before { visit signin_path }
    it { should have_title(full_title('登录')) }
    it { should have_content('登录') }
  end

  describe "signin" do
    before { visit signin_path }
    let(:submit) { '登录' } 

    describe "信息无效" do
      before { click_button submit }
      it { should have_title(full_title('登录')) }
      it { should have_selector('div.alert.alert-error', text:"密码错误或者邮箱不存在") }
    end

    describe "信息有效" do
      before do
        fill_in "邮箱",  with: user.email
        fill_in "登录密码",  with: user.password
        click_button submit
      end

      it { should have_title(user.name) }
      it { should have_selector("div.alert.alert-success",text:"登录成功") }
      it { should have_link('个人信息', href: user_path(user)) }
      it { should have_link('登出', href: signout_path) }
      it { should have_link('更改信息', href: edit_user_path(user)) }
      it { should have_link('所有用户', href: users_path) }
      it { should_not have_link('登录', href: signin_path) }
      
      describe "退出" do
        before { click_link "登出" }
        it { should have_title('') }
        it { should_not have_link('登出', href: signout_path) }
        it { should have_link('登录', href: signin_path) }
      end
    end

  end

  describe "edit page" do
    before do 
      sign_in user
      visit edit_user_path(user)
    end
    it { should have_title('更改信息') }
    it { should have_content('更改信息') }
  end

  describe "edit" do
    before do 
      sign_in user
      visit edit_user_path(user)
    end
    let(:submit) { "确认更改" }

    describe "信息无效时" do
      before { click_button submit }
      it { should have_content('error') }
      it { should have_title('更改信息') }
    end

    describe "信息有效时" do
      let(:new_name) { "Guarder" }
      let(:new_email) { "guard@example.com" }
      
      before do
        fill_in "用户名", with: new_name
        fill_in "邮箱", with: new_email
        fill_in "密码", with: user.password
        fill_in "确认密码", with: user.password
        click_button submit
      end
      
      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success',text: "更改成功") }
      it { should have_link('登出', href:signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

  end

  describe "index page" do
    !let(:other_user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit users_path
    end

    it "应该显示所有用户/分页" do
      User.paginate(page: 1).each do |user|
        expect(page).to have_link(user.name)
      end
    end

    it { should have_title(full_title('所有用户')) }
    it { should have_content('所有用户') }
    it { should_not have_link('删除') }
    describe "显示删除链接" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in admin 
        visit users_path
      end
      it { should have_link('删除',href: user_path(User.first)) }

      it "应该删除成功" do
        expect { click_link "删除", match: :first }.to change(User, :count).by(-1)
      end 

      it { should_not have_link("删除", href: user_path(admin)) }
    end
  end
end