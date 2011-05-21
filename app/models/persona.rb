#  create_table "personas", :force => true do |t|
#    t.text    "nombre"
#    t.text    "apellido"
#    t.text    "cin"
#    t.text    "telefono"
#    t.text    "telefono_cell"
#    t.text    "direccion"
#    t.boolean "staff"
#    t.integer "lg_id"
#  end
class Persona < ActiveRecord::Base
  def to_s
    self.nombre || "" + " " + self.apellido || ""
  end
end
