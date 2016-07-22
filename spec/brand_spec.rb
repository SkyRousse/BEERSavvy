require('spec_helper')

describe Brand, type: :model do
  it { should have_and_belong_to_many :stores }
  it('validate the presence of name') do
    test_brand = Brand.new({:name => ""})
    expect(test_brand.save()).to(eq(false))
  end
  it('restricts the length of the name to 20 characters or less') do
    test_brand = Brand.new({:name => "a".*(21)})
    expect(test_brand.save()).to(eq(false))
  end
  it('capitalizes the name') do
    test_brand = Brand.create(:name => "capy")
    expect(test_brand.name()).to(eq("Capy"))
  end

end
