#  create_table "ref_inventario_categorias", :force => true do |t|
#    t.text    "categoria"
#    t.integer "lg_id"
#  end
class RefInventarioCategoria < ActiveRecord::Base
  def to_s
    self.categoria
  end
end
