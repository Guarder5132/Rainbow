require 'spec_helper'

describe "StaticPages" do

  subject { page }
  
  describe "Home page" do
    before { visit root_path }
    it { should have_title(full_title('')) }
    it { should have_content('欢迎来到彩虹世界') }
    it { should_not have_title('| Home') }
  end

  

end
