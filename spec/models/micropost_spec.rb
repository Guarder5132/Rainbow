require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content:"和兔子的约定") }

  subject { @micropost }

  it { should respond_to(:user_id) }
  it { should respond_to(:content) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  
end
