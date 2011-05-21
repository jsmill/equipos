# Dependencies:
#   ActiveRecord
module RecordElf
  class Utils

     def self.col_methods(klass, except = [])
      # Receives a child class of ActiveRecord::Base
      # returns array of attribute reader methods or the association name in the case of a foreign key

      # If columns have been specifically included for the class use these,
      # otherwise use all db table columns bar any specifically excluded on the class
      # in either case the except parameter is an override that removes included columns
      methods = []
      fkey_hash = {}
      except = Array(except)
      if klass.respond_to?("included_columns") && klass.included_columns
        included_columns = klass.included_columns
      else
        included_columns = klass.column_names
        if klass.respond_to?("excluded_columns") && klass.exclcuded_columns
          except = except | klass.excluded_columns
        end
      end
      klass.reflect_on_all_associations.each { |mac| fkey_hash[mac.primary_key_name] = mac.name.to_s }
      included_columns.each do |col|
        unless except.include? col
          methods << (fkey_hash[col] || col) 
        end
      end
      methods
    end # def col_methods(klass)

  end # class Utils
end # module RecordElf
