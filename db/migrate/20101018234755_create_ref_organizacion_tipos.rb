class CreateRefOrganizacionTipos < ActiveRecord::Migration
  def self.up
    create_table :ref_organizacion_tipos do |t|
      t.text :tipo

      t.timestamps
    end
  end

  def self.down
    drop_table :ref_organizacion_tipos
  end
end
