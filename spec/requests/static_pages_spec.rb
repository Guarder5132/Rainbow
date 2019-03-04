require 'spec_helper'

describe "StaticPages" do

  subject { page }
  
  describe "Home page" do
    before { visit root_path }
    it { should have_title(full_title('')) }
    it { should have_content('欢迎来到彩虹世界') }
    it { should_not have_title('| Home') }
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
