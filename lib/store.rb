class Store < ActiveRecord::Base
  has_and_belongs_to_many(:brands)
  validates(:name, {:presence => true, :length => { :maximum => 20 }})
  before_save(:downcase_store_name, :capitalize_store_name)


private

  define_method(:capitalize_store_name) do
    self.name=(name().capitalize())
  end

  define_method(:downcase_store_name) do
    self.name=(name().downcase())
  end

end
