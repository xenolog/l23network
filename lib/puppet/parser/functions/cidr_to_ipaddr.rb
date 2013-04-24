#
# cidr_to_ipaddr.rb
#

module Puppet::Parser::Functions
  newfunction(:cidr_to_ipaddr, :type => :rvalue, :doc => <<-EOS
This function get cidr-notated IP addresses and return ip address.
EOS
  ) do |arguments|
    if arguments.size != 1
      raise(Puppet::ParseError, "cidr_to_ipaddr(): Wrong number of arguments " +
        "given (#{arguments.size} for 1)") 
    end

    cidr = arguments[0]
    re_groups = /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/\d{1,2}$/.match(cidr)
    if ! re_groups
      raise(Puppet::ParseError, "cidr_to_ipaddr(): Wrong CIDR: '#{cidr}'.")
    end 
    
    return re_groups[1]
  end
end
