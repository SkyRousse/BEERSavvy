require('spec_helper')

describe('add a brand to a store route', {:type => :feature}) do
  it('allows a user to add a specific brand to a store') do
    test_store = Store.create({:name => "stumpys"})
    visit('/stores')
    click_link('Stumpys')
    fill_in('brand_name', :with => "test_brand")
    click_button('Add Brand')
    expect(page).to have_content("Test_brand")
  end
end
