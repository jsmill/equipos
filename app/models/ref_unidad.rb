#  create_table "ref_unidades", :force => true do |t|
#    t.text    "unidad"
#    t.integer "lg_id"
#  end
class RefUnidad < ActiveRecord::Base
  
  def to_s
    self.unidad || ""
  end
end
