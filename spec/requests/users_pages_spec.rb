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
    before { visit user_path(user) }
    it { should have_title(full_title(user.name)) }
    it { should have_content(user.name) }
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
        it { should have_content('error') }
      end

    end

    describe "信息有效时" do

      before do
        fill_in "Name",       with: "Rainbow"
        fill_in "Email",      with: "rain@example.com"
        fill_in "Password",   with: "foobar"
        fill_in "Confirmat",  with: "foobar"
      end

      it "应该注册成功" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "注册成功后" do
        before { click_button submit }
        it { should have_selector('div.alert.alert-success', text:"注册成功") }  
      end
      
    end
  end
end
