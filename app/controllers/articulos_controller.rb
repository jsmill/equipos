class ArticulosController < ApplicationController
  acts_as_record_elf :no_sort => ['id', 'unidad_id']

  def index
    @articulos = Articulo.where('cantidad > 100').record_elf(options_elf).paginate(:per_page => 25, :page => params[:page])
  end
  
 end
