class CreateRefDonacionTipos < ActiveRecord::Migration
  def self.up
    create_table :ref_donacion_tipos do |t|
      t.text :donacion_tipo

      t.timestamps
    end
  end

  def self.down
    drop_table :ref_donacion_tipos
  end
end
