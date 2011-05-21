# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101016232140) do

  create_table "articulos", :force => true do |t|
    t.integer  "num"
    t.text  "articulo_detalle"
    t.integer  "categoria_id"
    t.integer  "cantidad"
    t.integer  "unidad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entregas", :force => true do |t|
    t.integer  "donacion_tipo_id"
    t.integer  "recipiente_org_id"
    t.integer  "recipiente_pers_id"
    t.text  "recipiente_escribido"
    t.text  "cin"
    t.text  "telefono"
    t.text  "telefono_cell"
    t.date  "fecha_de_entrega"
    t.integer  "beneficiaria_id"
    t.text  "beneficiaria_escribido"
    t.boolean  "ck_ben_id",     :default => false
    t.boolean  "ck_ben_esc",     :default => false
    t.integer "entregado_por_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entrega_articulos", :force => true do |t|
    t.integer  "entrega_id"
    t.integer  "articulo_id"
    t.integer  "cantidad"
    t.integer  "unidad_id"
    t.integer  "donacion_tipo_id"
    t.text "detalle_para_entrega"
    t.date "fecha_por_devolver"
    t.date "fecha_devuelto"
    t.integer "cantidad_devuelto"
    t.integer "unidad_devuelto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizaciones", :force => true do |t|
    t.integer  "tipo_id"
    t.integer "clasificacion_id"
    t.text  "organizacion_nombre"
    t.text  "persona"
    t.text  "cargo"
    t.text  "cin"
    t.text  "telefono"
    t.text  "telefono_cell"
    t.text "direccion"
    t.boolean "staff"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personas", :force => true do |t|
    t.text "nombre"
    t.text "apellido"
    t.text "cin"
    t.text "telefono"
    t.text "telefono_cell"
    t.text "direccion"
    t.boolean "staff"
  end

  create_table "ref_inventario_categorias", :force => true do |t|
    t.text "categoria"
  end

  create_table "ref_org_tipo_clasificaciones", :force => true do |t|
    t.integer "tipo_id"
    t.text "clasificacion"
  end

  create_table "ref_donacion_tipos", :force => true do |t|
    t.text "donacion_tipo"
  end
  
  create_table "ref_organizacion_tipos", :force => true do |t|
    t.text "tipo"
  end

  create_table "ref_unidades", :force => true do |t|
    t.text "unidad"
  end
end
