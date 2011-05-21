class CreateOrganizaciones < ActiveRecord::Migration
  def self.up
    create_table :organizaciones do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :organizaciones
  end
end
