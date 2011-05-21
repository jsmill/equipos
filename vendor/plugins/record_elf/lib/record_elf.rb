# RecordElf

%w{ helpers }.each do |dir| # AQ not working
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.autoload_paths << path
  ActiveSupport::Dependencies.autoload_once_paths.delete(path)
end

require 'record_elf/acts_as_elfable'
require 'record_elf/acts_as_record_elf'
require 'record_elf/utils'
