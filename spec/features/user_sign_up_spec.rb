feature 'User sign up' do

  scenario "user should find an fill out a signup form" do
      visit '/sign_up'
      fill_in :user_email, with: "john.franco@franco.com"
      fill_in :password, with: "John"
      fill_in :password_confirmation, with: "John"
      click_button "submit"
      expect(current_path) == '/links'
      expect(page).to have_content("Welcome, john.franco@franco.com")
      visit ('/tags/news')
  end

  scenario 'requires a matching confirmation password' do
    expect{ sign_up(password_confirmation: 'wrong')}.not_to change(User, :count)
  end

  def sign_up(user_email: 'frank@franco.com',
              password: 'hello',
              password_confirmation: 'helo')
      visit '/sign_up'
      fill_in :user_email, with: user_email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password_confirmation
      click_button 'submit'
    end

  scenario "with a pasword that does not match" do
    expect {sign_up(password_confirmation: 'wrong')}.not_to change(User, :count)
    expect(current_path).to eq('/sign_up')
    expect(page).to have_content 'Password and confirmation password do not match'
  end

end
