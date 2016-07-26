require('spec_helper')

describe('find a beer path', {:type => :feature}) do
  it('allows a user to find a beer by name') do
    visit('/')
    fill_in("beer_name", :with => "Aztec")
    click_button('beer_search')
    expect(page).to have_content("Aztec")
  end
end
