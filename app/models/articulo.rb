#  create_table "articulos", :force => true do |t|
#    t.integer  "num"
#    t.text     "articulo_detalle"
#    t.integer  "categoria_id"
#    t.integer  "cantidad"
#    t.integer  "unidad_id"
#    t.datetime "created_at"
#    t.datetime "updated_at"
#    t.integer  "lg_id"
#    t.integer  "lg_categoria_id"
#    t.integer  "lg_unidad_id"
#  end
class Articulo < ActiveRecord::Base
  acts_as_elfable :columns => [:categoria_id, :articulo_detalle, :cantidad, :unidad_id],
              :search_column => 'articulo_detalle'
  
  belongs_to  :categoria,
              :class_name => "RefInventarioCategoria"

  belongs_to  :unidad,
              :class_name => "RefUnidad"

end
