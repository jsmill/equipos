# Usage

  # In your controller call acts_as_record_elf with an optional hash of parameters.
  # Then call record_elf(options_elf) on your model class to prepare the arel object 
  
  #   class ArticleController < ApplicationController 
  #     acts_as_record_elf :no_sort => 'telephone'
  #     def index
  #         @articles = Article.where(:active => true).record_elf(options_elf).paginate(:page => params[:page])
  #         ...
  #         

# acts_as_record_elf stores model details in the controller class and includes a number of
# controller instance methods providing search and sort values from the request parameters,
# for the model class to use to prepare the records and for views to display them.

# Dependencies:
  # RecordElf::Utils   

module RecordElf
  module ControllerElf
    def self.included(base)
      base.extend(ClassMethods)
      base.helper_method :col_methods, :unsortable_headers, :sort_method, :sort_direction, :search_term
      base.helper :record_elf
      # set instance var for controller actions / view helpers:
    end
   
    # Config class to hold model details needed to prepare records for display and for view helpers
    # The col_methods array is the crucial information, used to determine:
    #  - any associations that should be eager loaded (see acts_as_elfable.rb)
    #  - what data to display in the views (accessed via the col_methods helper method)
    #  The no_sort variable, accessed via the unsortable_headers helper, can be used in
    #  the view to determine any headers that are not to be links for sorting
    class Config
      attr_reader :model
      attr_reader :col_methods
      attr_reader :no_sort

      def initialize(model_name, options = {})
        model_name = model_name.to_s
        @model = model_name.camelize.constantize
        exclude = Array(options[:exclude])
        @col_methods = RecordElf::Utils.col_methods(@model, exclude)
        @no_sort = Array(options[:no_sort]).map {|col| col.to_s} # used by view helper, this header will not be a link
      end
    end # class Config

    module ClassMethods
      # Stores model details on the controller class and includes controller instance methods
      # Takes an optional options hash paramater, assuming normal convention for model_name unless supplied
      #  :model_name => 'article', :exclude => 'id', :no_sort => ['telephone', 'cellphone']
      def acts_as_record_elf(options = {})
        model_name = options.delete(:model_name) || controller_name.singularize.underscore
        @acts_as_elf_config = RecordElf::ControllerElf::Config.new(model_name, options)
        include RecordElf::ControllerElf::InstanceMethods
      end # def acts_as_record_elf

      def acts_as_elf_config # attr reader providing the Config object to instance methods
        @acts_as_elf_config || self.superclass.instance_variable_get('@acts_as_elf_config')
      end
    end # module ClassMethods

    module InstanceMethods

      protected
        
        def options_elf
          {:column_methods => col_methods,
           :search_term => search_term,
           :sort_method => sort_method,
           :sort_direction => sort_direction}
        end

        # View helper methods
        def col_methods
          self.class.acts_as_elf_config.col_methods
        end
        def unsortable_headers
          self.class.acts_as_elf_config.no_sort
        end
        def sort_method
          # Overwite in cotroller to something like: params[:sort_method] || 'surname' to achieve a default sort
          params[:sort_method]
        end
        def sort_direction
          params[:sort_direction]
        end
        def search_term
          params[:search]
        end

        def NOTretrieve_session_sort
          # If the session is found to have a saved sort for a table div id that corresponds to a collection initialised by the :index action, we will reapply that sort to the collecion.
          # We need to map collection instance variable from the :index action to table_div's in the session. When we find a match we sort the collection as per the session data.
          # The convention here is to take all controller instance variables and try to match to session keys names sort_#{instance_var_name}.
          # I.E. we assume controller instance variables have the same names as their corresponding table_div, e.g. @recent_articles matches session[:sort_recent_articles]. 
          # We'll only try this if the table_div param is present, otherwise we risk sorting a collection in :index that happens to have same name as a different table collection in the session
          if params[:table_div]
            instance_variable_names.each do |var|
              if session["sort_#{var[1..-1]}".to_sym] && params[:table_div] == var[1..-1]
                col_key = session["sort_#{var[1..-1]}".to_sym][0]
                direction = session["sort_#{var[1..-1]}".to_sym][1]
                col_key += "_reverse" if direction == "desc"
                params[:sort_method] = col_key # to mimic a sort request originating from a table header click
                instance_variable_set var, sort_table_collection(instance_variable_get(var))
              end
            end
          end
        end
        def NOTrender(*args)
        # remember user's last sort and apply it instead of (well, after) the default :index action sort
        # AQ change to avoid double sort performance hit
          retrieve_session_sort if self.action_name == 'index' 
          super(*args)
        end 
    end # module ControllerElf
  end # module RecordElf
end

ActionController::Base.send :include, RecordElf::ControllerElf
