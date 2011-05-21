#  create_table "organizaciones", :force => true do |t|
#    t.integer "tipo_id"
#    t.integer "clasificacion_id"
#    t.text    "organizacion_nombre"
#    t.text    "persona"
#    t.text    "cargo"
#    t.text    "cin"
#    t.text    "telefono"
#    t.text    "telefono_cell"
#    t.text    "direccion"
#    t.integer "lg_id"
#    t.integer "lg_tipo_id"
#    t.integer "lg_clasificacion_id"
#  end
class Organizacion < ActiveRecord::Base

  belongs_to  :tipo,
              :class_name => "RefOrganizacionTipo"

  belongs_to  :clasificacion,
              :class_name => "RefOrgTipoClasificacion"

  def to_s
    self.organizacion_nombre
  end
 end
