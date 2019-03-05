**
spec/requests/users_pages_spec.rb    #密码的authenticate方法 需要在看下
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


**
spec/factories.rb   #预构件 为了测试方便
FactoryGirl.define do
  factory :user do
      sequence(:name)        {|n| "Rainbow_#{n}"}         
      sequence(:email)       {|n| "rain_#{n}@example.com"}
      password               "foobar"
      password_confirmation  "foobar"
  end
end
