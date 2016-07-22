require('spec_helper')

describe('create a shoe store route', {:type => :feature}) do
  it('allows a user to save a shoe store in the database') do
    visit('/')
    click_link('See the stores')
    expect(page).to have_content("The C.R.U.D.L database doesn't have any stores")
    fill_in("name", :with => "stabbys")
    click_button('Add Store')
    expect(page).to have_content("Stabbys")
  end
end

describe('list all shoe stores route', {:type => :feature}) do
  it('allows a user to see all of the stores in the database') do
    visit('/')
    click_link('See the stores')
    fill_in("name", :with => "stabbys")
    click_button('Add Store')
    expect(page).to have_content("Stabbys")
  end
end
