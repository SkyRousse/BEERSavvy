require('spec_helper')

describe Store, type: :model do
  it { should have_and_belong_to_many :brands }

  it { should validate_presence_of(:name) }

  it { should validate_length_of(:name)}

  it('downcases the name') do
    test_store = Store.create({:name => "joNNy"})
    expect(test_store.name()).to(eq("Jonny"))
  end
  it('capitalizes the name') do
    test_store = Store.create({:name => "jonny"})
    expect(test_store.name()).to(eq("Jonny"))
  end
end
