class CreatePersonas < ActiveRecord::Migration
  def self.up
    create_table :personas do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :personas
  end
end
