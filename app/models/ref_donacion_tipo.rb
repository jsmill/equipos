#  create_table "ref_donacion_tipos", :force => true do |t|
#    t.text    "donacion_tipo"
#    t.integer "lg_id"
#  end
class RefDonacionTipo < ActiveRecord::Base
  def to_s
    donacion_tipo
  end
end
