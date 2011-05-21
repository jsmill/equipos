class CreateEntregaArticulos < ActiveRecord::Migration
  def self.up
    create_table :entrega_articulos do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :entrega_articulos
  end
end
