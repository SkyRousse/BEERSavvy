require('spec_helper')

describe('find a beer path', {:type => :feature}) do
  it('allows a user to find a beer by name') do
    visit('/')
    fill_in("beer_name", :with => " Breakside IPA ")
    click_button('beer_search')
    expect(page).to have_content("Breakside IPA")
  end
end
