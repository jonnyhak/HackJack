class AddDefaultValueToUserBank < ActiveRecord::Migration[6.0]
  def change
    change_column(:users, :bank, :integer, {default: 20})
  end
end
