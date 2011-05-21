class CreateEntregas < ActiveRecord::Migration
  def self.up
    create_table :entregas do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :entregas
  end
end
