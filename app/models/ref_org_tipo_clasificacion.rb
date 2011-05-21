#  create_table "ref_org_tipo_clasificaciones", :force => true do |t|
#    t.integer "tipo_id"
#    t.text    "clasificacion"
#    t.integer "lg_id"
#    t.integer "lg_tipo_id"
#  end
class RefOrgTipoClasificacion < ActiveRecord::Base

  belongs_to  :tipo, :foreign_key => "tipo_id",
              :class_name => "RefOrganizacionTipo"

  def to_s
    self.clasificacion
  end
end
