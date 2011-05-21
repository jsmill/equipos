#  create_table "entregas", :force => true do |t|
#    t.integer  "donacion_tipo_id"
#    t.integer  "recipiente_org_id"
#    t.integer  "recipiente_pers_id"
#    t.text     "recipiente_escribido"
#    t.text     "cin"
#    t.text     "telefono"
#    t.text     "telefono_cell"
#    t.date     "fecha_de_entrega"
#    t.integer  "beneficiaria_id"
#    t.text     "beneficiaria_escribido"
#    t.boolean  "ck_ben_id",              :default => false
#    t.boolean  "ck_ben_esc",             :default => false
#    t.integer  "entregado_por_id"
#    t.datetime "created_at"
#    t.datetime "updated_at"
#    t.integer  "lg_id"
#    t.integer  "lg_donacion_tipo_id"
#    t.integer  "lg_recipiente_org_id"
#    t.integer  "lg_recipiente_pers_id"
#    t.integer  "lg_beneficiaria_id"
#    t.integer  "lg_entregado_por_id"
#  end
class Entrega < ActiveRecord::Base

  acts_as_elfable :search_column => :fecha_de_entrega, 
        :columns => [:fecha_de_entrega,:recipiente_org_id,:recipiente_pers_id,:beneficiaria_id,:cin,:telefono,:entregado_por_id]

  belongs_to  :donacion_tipo,
              :class_name => "RefDonacionTipo"
   
  belongs_to  :recipiente_org,
              :class_name => "Organizacion"

  belongs_to  :recipiente_pers,
              :class_name => "Persona"

  belongs_to  :beneficiaria,
              :class_name => "Persona"

  belongs_to  :entregado_por,
              :class_name => "Persona"
  
end
