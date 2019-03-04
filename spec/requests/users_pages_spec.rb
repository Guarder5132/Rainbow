require 'spec_helper'

describe "UsersPages" do
  
  subject{ page }

  describe "Signup page" do
    before { visit signup_path }
    it { should have_title(full_title('注册')) }
    it { should have_content('注册新用户') }
  end

end
