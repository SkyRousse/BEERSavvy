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
    test_store = Store.create({:name => "stabbys"})
    test_store = Store.create({:name => "stumpys"})
    visit('/stores')
    expect(page).to have_content("Stabbys Stumpys")
  end
end

describe('see store details path', {:type => :feature}) do
  it('allows a user to view the stores details') do
    test_store = Store.create({:name => "stumpys"})
    visit('/stores')
    click_link('Stumpys')
    expect(page).to have_content("Current Store Name: Stumpys")
  end
end

describe('update store path', {:type => :feature}) do
  it('allows a user to rename the store') do
    test_store = Store.create({:name => "stumpys"})
    visit('/stores')
    click_link('Stumpys')
    fill_in('new_name', :with => "rens")
    click_button('Update')
    expect(page).to have_content("Rens")
  end
end

describe('delete store path', {:type => :feature}) do
  it('allows a user to delete a store from the database') do
    test_store = Store.create({:name => "stumpys"})
    visit('/stores')
    click_link('Stumpys')
    click_button('Delete')
    expect(page).to have_no_content('Stumpys')
  end
end
