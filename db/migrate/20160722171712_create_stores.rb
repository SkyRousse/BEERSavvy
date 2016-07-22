class CreateStores < ActiveRecord::Migration
  def change
    create_table(:stores) do |t|
      t.column(:name, :string)

      t.timestamps()
    end
  end
end
