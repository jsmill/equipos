#  create_table "ref_organizacion_tipos", :force => true do |t|
#    t.text    "tipo"
#    t.integer "lg_id"
#  end
class RefOrganizacionTipo < ActiveRecord::Base
  def to_s
    self.tipo   
  end
end
