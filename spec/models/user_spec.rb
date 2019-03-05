require 'spec_helper'

describe User do
  
  before { @user = User.new(name:"Rainbow", email:"rain@example.com", password:"foobar", password_confirmation:"foobar") }

  subject { @user } 

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should be_valid }

  describe "name" do
    describe "当名字为空时" do
      before { @user.name = "" }
      it { should_not be_valid }
    end
    
    describe "当名字过长时" do
      before { @user.name = "a"*21 }
      it { should_not be_valid }
    end
  end

  describe "email" do
    describe "邮箱为空时" do
      before { @user.email = "" }
      it { should_not be_valid }
    end
    
    describe "邮箱的有效性" do
      it "邮箱无效时" do
        address = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
        address.each do |invalid|
          @user.email = invalid
          expect(@user).not_to be_valid
        end
      end

      it "邮箱有效时" do
        address = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        address.each do |valid|
          @user.name = valid
          expect(@user).to be_valid
        end
      end
    end

    describe "邮箱唯一性,不区分大小写" do
      before do
        new_user = @user.dup
        new_user.email = @user.email.upcase
        new_user.save
      end

      it { should_not be_valid }
    end

    describe "邮箱保存后变小写" do
      let(:new_email) { "RainBow@example.COm" }
      it "应该变成小写" do
        @user.email = new_email
        @user.save
        expect(@user.reload.email).to eq new_email.downcase
      end
    end
  end

  describe "password" do
    describe "当密码为空时" do
      before { @user.password = @user.password_confirmation = "" }
      it { should_not be_valid }
    end

    describe "当密码不相同时" do
      before { @user.password_confirmation = "invalid" }
      it { should_not be_valid }
    end

    describe "密码不小于6位" do
      before { @user.password=@user.password_confirmation="a"*5 }
      it { should_not be_valid }
    end

    describe "authenticate" do
      before { @user.save }
      let(:other_user) { User.find_by(email: @user.email) }

      describe "信息有效时" do
        it { should eq other_user.authenticate(@user.password) }
      end

      describe "信息无效时" do
        let(:invalid_password_user) { other_user.authenticate("invalid") }
        it { should_not eq invalid_password_user }
        specify { expect(invalid_password_user).to be_false }
      end
    end
  end
  
  describe "remember_token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
