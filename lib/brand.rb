
class Brand < ActiveRecord::Base
  has_and_belongs_to_many(:stores)
  before_save(:capitalize_brand_name)
  validates(:name, {:presence => true, :length => { :maximum => 20 }})
private

  define_method(:capitalize_brand_name) do
    self.name=(name().capitalize())
  end

end
