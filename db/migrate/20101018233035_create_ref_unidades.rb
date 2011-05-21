class CreateRefUnidades < ActiveRecord::Migration
  def self.up
    create_table :ref_unidades do |t|
      t.text :unidad

      t.timestamps
    end
  end

  def self.down
    drop_table :ref_unidades
  end
end
