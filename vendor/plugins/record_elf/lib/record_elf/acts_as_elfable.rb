# Extends ActiveRecord::Base
#
# Optionally call acts_as_elfable from your model to specify available columns (or you can specify exlcuded columns)
#   acts_as_elfable :columns => [:created_at, :title, :category_id], :search_column => :title
# If acts_as_elfable is not called, all columns are available and your controller can specify any to be excluded
#
# Model.record_elf(options) provides the record collection prepared for your controller 
# 
module RecordElf 
  module ElfableModel
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      
      # Sets class variables that specify the model columns and optional search column for the plugin
      def acts_as_elfable(options = {})
        # If the included_columns option is passed, these are the set in a class variable
        # Otherwise we set the fields to exclude:
        #   - fields to exclude from all tables can be defined in the rails app config object
        #   - fields to exclude from individual models can be defined as options in the acts_as_sortable_table call
        cattr_accessor :included_columns
        cattr_accessor :excluded_columns
        cattr_accessor :search_column
        merged_options = options
        global_options = {} # define in environment.rb
        db_cols = self.column_names
        if options[:columns]
          #included_cols = Array(options[:columns]).select {|c| db_cols.include? c.to_s}.map {|c| c.to_s}
          included_cols = Array(options[:columns]).map { |c| c.to_s }
          self.included_columns = included_cols
        else
          if Rails.application.config.respond_to? 'record_elf_options'
            global_options = Rails.application.config.record_elf_options
            merged_options = options.merge(global_options)
          end
          prefix = merged_options[:exclude_prefix]
          suffix = merged_options[:exclude_suffix]
          excluded = (Array(global_options[:excluded]) | Array(options[:excluded])).map { |c| c.to_s }
          force_include = Array(options[:force_include]).map { |c| c.to_s } # to include a column excluded by the global variable
          excluded_cols = []
          self.column_names.each do |col|
            if (prefix && col =~ /^#{prefix}./) || (suffix && col =~ /.#{suffix}$/) ||
             (excluded.include?(col) && !force_include.include?(col))
              excluded_cols << col
            end
          end
          self.excluded_columns = excluded_cols
        end

        self.search_column = merged_options[:search_column].to_s if db_cols.include?(merged_options[:search_column])

        send :include, InstanceMethods
      end # def acts_as_elfable

      def record_elf(options = {})
        # Returns searched, eager loaded, sorted records:
        #   - search if search_term is provided and search method is implemented
        #   - eager load each association in col_methods
        #   - sort if sort_method is provided and it's in col_methods (avoiding sql injection)
        # Can be called on a ready prepared ActiveRecord::Relation object or an array
        col_methods = Array(options[:column_methods])
        search_term = options[:search_term]
        sort_method = options[:sort_method]
        sort_direction = options[:sort_direction]

        recs = self.scoped # builds on top of any existing arel object
        recs = recs.search(search_term) if recs.respond_to?('search') 

        assocs = self.reflect_on_all_associations.collect{|mac| mac.name}
        col_methods.each do |mtd|
          recs = recs.includes(mtd) if assocs.include?(mtd.to_sym)
        end

        # Sort the records if we're given a recognised sort method
        return recs unless sort_method && col_methods.include?(sort_method)
        if sort_direction.upcase == 'DESC'
          direction = ' DESC'
          rev = true
        else
          direction = ' ASC'
          rev = false
        end
        # If possible use arel sort to avoid database hit
        if recs.kind_of?(ActiveRecord::Relation) && self.column_names.include?(sort_method)
            recs = recs.order(sort_method + direction)
        else
          if rev
            recs = recs.sort_by{ |o| (o.send(sort_method) || "").to_s }.reverse
          else
            recs = recs.sort_by{ |o| (o.send(sort_method) || "").to_s }
          end
        end
        return recs 
      end # def record_elf

      def search(search)
        # A default search method for your model class
        # relies on acts_as_elfable specifying the search_column
        if search && self.respond_to?('search_column') && self.search_column
          where("#{self.scoped.table.name}.#{self.search_column} LIKE ?", "%#{search}%")  
        else  
          scoped # no search performed 
        end  
      end # def self.search
    end # Module ClassMethods

    module InstanceMethods

      # A default to_s method for your model
      # returns the value in the search_column if a search_column has been defined by acts_as_elfable
      def to_s
        if self.class.respond_to?('search_column') && self.class.search_column
          self.send(self.class.search_column)
        else
          super
        end
      end # def to_s
    end # module InstanceMethods

  end # module ElfableModel
end # module RecordElf

ActiveRecord::Base.send :include, RecordElf::ElfableModel
