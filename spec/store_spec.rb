require('spec_helper')

describe(Store) do
  it('validates presence of name') do
    test_store = Store.new({:name => ""})
    expect(test_store.save()).to(eq(false))
  end
  it('restricts the length of a name to 20 characters or less') do
    test_store = Store.new({:name => "a".*(21)})
    expect(test_store.save()).to(eq(false))
  end
  it('capitalizes the name') do
    test_store = Store.create({:name => "jonny"})
    expect(test_store.name()).to(eq("Jonny"))
  end
end
