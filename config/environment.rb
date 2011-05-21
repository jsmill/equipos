# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Equipos::Application.configure do
  options = {}
  options[:exclude_prefix] = "lg_"
  options[:excluded] = %w{ created_at }
  config.record_elf_options = options
end
Equipos::Application.initialize!
