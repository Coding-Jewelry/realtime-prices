class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :company_id
      t.string :company_name
      t.string :address
      t.string :city
      t.string :country
      t.string :zip_code
      t.string :tax_office
      t.string :vat_number
      t.string :telephone1
      t.string :telephone2
      t.string :fax1
      t.string :fax2

      t.timestamps null: false
    end
  end
end
