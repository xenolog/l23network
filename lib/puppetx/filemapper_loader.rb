begin
    require 'puppetx/filemapper'
rescue LoadError
    # try to load the filemapper directy
    ['../../../filemapper/lib/puppetx/filemapper', '../../spec/fixtures/modules/filemapper/lib/puppetx/filemapper'].each do |ll|
        begin
          require_relative ll
        rescue LoadError
          # try to load the filemapper directy
          next
        end
        break
    end
end
