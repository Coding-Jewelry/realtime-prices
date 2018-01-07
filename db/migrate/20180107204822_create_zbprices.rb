class CreateZbprices < ActiveRecord::Migration
  def change
    create_table :zbprices do |t|
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
