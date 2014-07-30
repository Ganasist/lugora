require 'spec_helper'

describe 'LayoutLinks' do

  it 'should have the right title' do
    visit root_path
    page.should have_title('Splash')
  end

  it 'should have a Root link' do
    visit root_path
    page.should have_link('TF Home', root_path)
  end

  it 'should have a User Register link' do
    visit root_path
    page.should have_link('User Sign Up', new_user_registration_path)
  end

  it 'should have a Vendor Register link' do
    visit root_path
    page.should have_link('Vendor Sign Up', new_vendor_registration_path)
  end

  it 'should have a Sign-in link' do
    visit root_path
    page.should have_link('User Log in', new_user_session_path)
  end

  it 'should have a Sign-in link' do
    visit root_path
    page.should have_link('Vendor Log in', new_vendor_session_path)
  end

  it 'should have an About link' do
    visit root_path
    page.should have_link('About', page_path('about'))
  end

  it 'should have an About page at /about' do
    visit('/about')
    page.should have_content 'About'
  end

  it 'should have the right links in the layout' do
    visit root_path
    click_link 'About'
    page.should have_content 'About'
    page.should have_link('TF Home', root_path)

    # click_link('Privacy', page_path('privacy'))
    # expect(page).to have_content('TF Home', root_path)
    # expect(page).to have_content 'Privacy Policy'   
  end

  it 'should have an User sign-in page at /user_login', focus: true do
    visit root_path
    click_link 'User Log in'
    page.should have_content 'User Log in'
    page.should have_field 'Email'
    page.should have_field 'Password'
    page.should have_link 'Forgot password?'
    page.should have_unchecked_field 'user[remember_me]'
    page.should have_button('Log in', new_user_session_path)
  end

  it 'should have an Vendor sign-in page at /vendor_login' do
    visit root_path
    click_link 'Vendor Log in'
    page.should have_content 'Vendor Log in'
    page.should have_field 'Email'
    page.should have_field 'Password'
    page.should have_link 'Forgot password?'
    page.should have_unchecked_field 'vendor[remember_me]'
    page.should have_button('Log in', new_vendor_session_path)
  end

  it 'should have an User sign-up page at /user_register', focus: true do
    visit root_path
    click_link 'User Sign Up'
    page.should have_content 'User Log in'
    page.should have_field 'Email'
    page.should have_field 'Password'
    page.should have_button('User Sign Up', new_user_registration_path)
    page.should have_link('Sign in', new_user_session_path)
    page.should have_link "Didn't receive confirmation instructions?"
    page.should have_link "Didn't receive unlock instructions?"  
  end

  it 'should have an Vendor sign-up page at /vendor_register' do
    visit root_path
    click_link 'Vendor Sign Up'
    page.should have_field 'Email'
    page.should have_field 'Password'
    page.should have_button('Vendor Sign Up', new_vendor_registration_path)
    page.should have_link('Sign in', new_vendor_session_path)
    page.should have_link "Didn't receive confirmation instructions?"
    page.should have_link "Didn't receive unlock instructions?" 
  end

  describe 'when not signed in' do    
    it 'should have a brand link pointing to the Splash page' do      
      visit root_path
      expect(page).to have_content("INFINITORY", root_path)
    end

    it 'should have a sign-in and sign-up link' do
      visit root_path
      expect(page).to have_link('SIGN-IN', new_user_session_path) 
      expect(page).to have_link('Sign-up', new_user_registration_path)  
    end

    it 'should not have a sign out link' do
      visit root_path
      expect(page).to_not have_link("Sign-out", destroy_user_session_path)
    end

    it 'should not have an Invitation page at /invitation/new' do
      get '/invitation/new'
      assert_redirected_to '/login'
    end    

    it 'should not have a Feedback page at /messages/new' do
      get '/messages/new'
      assert_redirected_to '/login'
    end
  end

  describe 'when signed in' do

    let(:user) { create(:admin) }

    before(:each) do
      visit root_path
      click_link "SIGN-IN"
      fill_in 'Email',    with: user.email
      fill_in 'Password', with: user.password
      click_button('Sign in')
    end

    it 'should redirect to a User profile page' do      
      expect(page).to have_content("#{user.fullname}")
    end

    it 'should have the right title on the profile page' do      
      expect(page).to have_title("Infinitory | People: #{user.fullname}")
    end

    it 'should have a link to edit the current user' do
      expect(page).to have_link("Edit", edit_user_registration_path(user))
    end

    it 'should not have a link to edit users other than the current user' do
      member = create(:user, lab: user.lab, institute: user.institute)
      visit user_path(member)
      expect(page).to_not have_link("Edit")
    end

    it 'should have a brand link pointing to their profile page' do      
      expect(page).to have_link("INFINITORY", user_path(user))
      click_link("INFINITORY")
      expect(page).to have_title("Infinitory | People: #{user.fullname}")
    end

    it 'should have a new root path redirecting to the User profile page' do
      visit root_path
      expect(page).to have_content("#{user.fullname}")
    end

    it 'should have a Feedback link on the current User profile page' do
      get '/'
      expect(page).to have_link("Feedback", new_message_path)
    end

    # it 'should not have a Feedback link on other Users profile pages' do
    #   get '/'
    #   expect(page).to have_link("Feedback", new_message_path)
    # end

    it 'should have a Feedback page at /messages/new' do
      get '/messages/new'
      expect(page).to have_content('Send feedback')
    end

    it 'should have an Invitation page at /invitation/new' do
      visit new_user_invitation_path
      expect(page).to have_content('Invite another scientist or lab member')
    end 

    it 'should have a sign out link' do
      visit new_messages_path
      expect(page).to have_link("Sign-out", destroy_user_session_path)
    end

    it 'should not have sign-in or sign-up links at the root path' do
      visit root_path
      expect(page).to_not have_link('SIGN-IN', new_user_session_path)
      expect(page).to_not have_link('Sign up', new_user_registration_path)   
    end
  end
end
