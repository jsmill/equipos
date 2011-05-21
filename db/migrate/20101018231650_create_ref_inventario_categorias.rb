class CreateRefInventarioCategorias < ActiveRecord::Migration
  def self.up
    create_table :ref_inventario_categorias do |t|
      t.text :categoria

      t.timestamps
    end
  end

  def self.down
    drop_table :ref_inventario_categorias
  end
end
