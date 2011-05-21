# View helper for the record_elf plugin
module RecordElfHelper
  # Uses helper_methods from the controller to create a link with url parameters for the
  # details of how to sort the records
  # Plain text is returned if the column method is one of the unsortable_headers
	def build_header(col_method, title = nil)
      title ||= col_method.titleize
      return title if unsortable_headers.include?(col_method)
      direction = (col_method == sort_method && sort_direction == "ASC") ? "DESC" : "ASC"  
      css_class = (col_method == sort_method) ? "current #{sort_direction}" : nil  
      link_to title, 
        params.merge(:sort_method => col_method, :sort_direction => direction, :page => nil),
        {:class => css_class}
  end
end # module RecordElfHelper
