require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content:"和兔子的约定") }

  subject { @micropost }

  it { should respond_to(:user_id) }
  it { should respond_to(:content) }
  it { should respond_to(:user) }
  its(:user) { should eq user }
  it { should be_valid }
  
  describe "user_id" do

    describe "当user_id不存在时" do
      before { @micropost.user_id = nil }
      it { should_not be_valid }
    end

  end

  describe "content" do

    describe "当内容为空时" do
      before { @micropost.content = nil }
      it { should_not be_valid }
    end

    describe "当内容过长时" do
      before { @micropost.content = "a"*151 }
      it { should_not be_valid }
    end
  end

end
