class CreateRefOrgTipoClasificaciones < ActiveRecord::Migration
  def self.up
    create_table :ref_org_tipo_clasificaciones do |t|
      t.integer :tipo_id
      t.text :clasificacion

      t.timestamps
    end
  end

  def self.down
    drop_table :ref_org_tipo_clasificaciones
  end
end
