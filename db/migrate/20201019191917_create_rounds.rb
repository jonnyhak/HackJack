class CreateRounds < ActiveRecord::Migration[6.0]
  def change
    create_table :rounds do |t|
      t.integer :user_id
      t.integer :dealer_id
      t.integer :wager
      t.integer :user_card_total
      t.integer :dealer_card_total
      t.timestamps
    end
  end
end
