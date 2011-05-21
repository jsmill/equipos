class EntregaArticulo < ActiveRecord::Base

  belongs_to  :entrega
  belongs_to  :articulo
  
  belongs_to  :unidad,
              :class_name => "RefUnidad"

  belongs_to  :donacion_tipo,
              :class_name => "RefDonacionTipo"

  belongs_to  :unidad_devuelto,
              :class_name => "RefUnidad"

  def to_s
    self.articulo.to_s
  end
end
