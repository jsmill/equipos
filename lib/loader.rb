class Loader # a non-ActiveRecord class for loading text files into active record model tables
# TO USE:
  # 1) Create a text file for each table you want to populate, with the same name as the table:
  #     - quote all field values (you can try without) and use bar delimter: |
  # 2) Define an ActiveRecord model for each table to load into
  #     - when defining the table fields, add an extra field at the end to strore the old primary key and each foreign key,
  #       name the field with the same prefix on each of these.
  #     - define the ActiveRecord associations as normal in each model class
  # 3) Instantiante a Loader object as: loader = Loader.new(import_file_path, prefix_of_field_with_legacy_key)
  # 4) call loader.load_file(model) for each model that has a file to import
  # 5) call loader.set_links(model) for each model that has foreign keys to be populated
  # Note: Load all tables first and then call set_links on each model that has a foreign key (or on all)

  def initialize(data_files_path, legacy_key_prefix)
    @path = data_files_path
    @legacy_key_prefix = legacy_key_prefix
    @delimeter = '|' # Change text file field delimeter here if necessary
  end
  
  def load_file(model)
    # Loads file into specified model
    # expects quote at end of line (so basically quote all fields in export)
    klass = model_klass(model)
    klass.delete_all
    cols = klass.columns
    num_real_cols = get_num_real_cols(klass)
    fkeys = klass.reflect_on_all_associations.map{|mac| mac.primary_key_name}.compact
    file = File.new(@path + (@path[-1] == '/' ? '' : '/') + klass.to_s.tableize, "r")
    while (line = file.gets)
      unless /"$/ =~ line # if no quote at line end, join with next line 
        while /\r|\n$/ =~ line # strip lf and cr's from end of line
          line = line[0..-2]
        end
        line2 = file.gets
        line = line + " " + line2 if line2
      end
      l = line.split(@delimeter) # l is 1 record array of vals for each field
      load_record(klass.new, l, cols, num_real_cols, fkeys)
    end
    file.close
  end

  def set_links(model)
    # Populates any ActiveRecord foreign keys on the model given
    me = model.to_s.tableize
    klass = model_klass(model)
    statements = []
    klass.reflect_on_all_associations.each do |assoc|
      fk = assoc.primary_key_name
      fk_table = assoc.class_name.tableize

      statement = "Update #{me} set #{fk} = "
      statement += " (Select #{fk_table}.id From #{fk_table}"
      statement += " Where #{fk_table}.#{@legacy_key_prefix}id = #{me}.#{@legacy_key_prefix}#{fk})"

      statements << statement
    end
    run_statements statements
  end  

private

  def run_statements(statements) 
    unless statements.blank?
      statements.each do |statement|
        ActiveRecord::Base.connection.execute(statement)
      end
    end
  end

  def strip_all_quotes(model)
    # For every field in every record
    # remove any end cr's and wrapped quotes
    klass = model.to_s.pluralize.classify.constantize
    klass.all.each do |o|
      updated = false
      klass.column_names.each do |col|
        val = o.send(col)
        val.chomp! if val.class == String
        if val && val[0] == 34 && val[-1] == 34
          o.send "#{col}=", val[1..-2] 
          updated = true
        end
      end
      o.save! if updated
    end
  end

  def dequote(inStr)
    return inStr unless inStr
    inStr.chomp! if inStr.class == String
    if inStr[0] == ?" && inStr[-1] == ?"
      inStr = inStr[1..-2]
    end
    inStr
  end

  def model_klass(model)
    model.to_s.pluralize.classify.constantize # classify shouldn't be called on singular string
  end

 def load_record(o, rec_arr, cols, num_real_cols, fkeys)
    fk = []
    #o.class.columns.each_with_index do |col, i|
    cols.each_with_index do |col, i|  
      val = nil

      if i < num_real_cols # real data columns
        #if col.name == "id" or col.name[-3..-1] == "_id" # we don't populate key fields in the initial load
        if col.primary || fkeys.include?(col.name) # we don't populate key fields in the initial load
          fk << i # note position of key field in array (fk[0] == 0 for id field)
        else # set real data fields here, but not key fields (or the legacy fields at the end)
          rec_arr[i] = dequote rec_arr[i]
          o.send "#{col.name}=", rec_arr[i]
        end

      else # legacy fk cols - set legacy key values, fk holds their position in our record array
        val = rec_arr[fk[i-num_real_cols]] if fk[i-num_real_cols]
        if col.type == :integer && val # || col.type == double
          val = dequote(val)
        end
        o.send("#{col.name}=", val) if val
      end # i < num_real_cols
    end # each column
    o.save!
  end

  def get_num_real_cols(klass)
    # returns the numbers of table columns excluding any starting 'lg_' 
    # (they are assumed to be come after real columns as the column_names order is as def'd in schema.rb)
    num = 0
    klass.column_names.each do |c|
      len = @legacy_key_prefix.to_s.size - 1
      if c[0..len] == @legacy_key_prefix # stop counting
        break
      end
      num += 1
    end
    return num
  end

end
