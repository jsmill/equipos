class EntregasController < ApplicationController
  acts_as_record_elf

  def index
    @entregas = Entrega.record_elf(options_elf).paginate(:per_page => 12, :page => params[:page])
  end

end
