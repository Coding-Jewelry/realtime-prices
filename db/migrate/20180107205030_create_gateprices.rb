class CreateGateprices < ActiveRecord::Migration
  def change
    create_table :gateprices do |t|
      t.text :eth
      t.text :btc
      t.text :bch
      t.text :ltc
      t.text :dash
      t.text :etc
      t.text :zec

      t.timestamps null: false
    end
  end
end
