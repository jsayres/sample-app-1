require 'spec_helper'

describe 'User pages' do

  subject { page }

  describe 'signup page' do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe 'profile page' do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    
    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup" do
    
    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        let(:selector) { 'div#error_explanation li' }

        it { should have_content('error') }
        it { should have_title(full_title('Sign up')) }
        it { should have_selector(selector, text: "Name can't be blank") }
        it { should have_selector(selector, text: "Email can't be blank") }
        it { should have_selector(selector, text: "Email is invalid") }
        it { should have_selector(selector,
                      text: "Password confirmation doesn't match Password") }
        it { should have_selector(selector,
                      text: "Password confirmation can't be blank") }
        it { should have_selector(selector, text: "Password can't be blank") }
        it { should have_selector(selector, text: "Password is too short") }
      end
    end

    describe "with valid information" do

      let(:name) { 'Example User' }
      
      before do
        fill_in "Name", with: name
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_content(name) }
        it { should have_title(name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end
end
