class CreateKrakenprices < ActiveRecord::Migration
  def change
    create_table :krakenprices do |t|
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
