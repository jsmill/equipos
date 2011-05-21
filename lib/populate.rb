module Populate
 
  def self.scaffold_models
    # Based on the table definitions provided (format to be determined):
    # 1) Create an active record class for each table to be imported, defining relationships
    # 2) Generate a schema.rb file
    # 3) run > rake db:schema:load
  end

  # Call the Loader class here for each table to be imported into the app 
  def self.import_all
    models = []
    models << :ref_inventario_categoria
    models << :ref_unidad
    models << :ref_organizacion_tipo
    models << :ref_org_tipo_clasificacion
    models << :ref_donacion_tipo
    models << :articulo
    models << :organizacion
    models << :persona
    models << :entrega
    models << :entrega_articulo
    
    load = Loader.new("legacy_tabledata", "lg_")
    models.each {|model| load.load_file(model)}
    models.each {|model| load.set_links(model)}
  end

end
