
#
# cidr_to_netmask.rb
#
require 'ipaddr'
module Puppet::Parser::Functions
  newfunction(:cidr_to_netmask, :type => :rvalue, :doc => <<-EOS
This function get cidr-notated IP addresses and return netmask.
EOS
  ) do |arguments|
    if arguments.size != 1
      raise(Puppet::ParseError, "cidr_to_netmask(): Wrong number of arguments " +
        "given (#{arguments.size} for 1)") 
    end

    cidr = arguments[0]
    re_groups = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/(\d{1,2})$/.match(cidr)
    if ! re_groups
      raise(Puppet::ParseError, "cidr_to_netmask(): Wrong CIDR: '#{cidr}'.")
    end 
    return IPAddr.new('255.255.255.255').mask(re_groups[1]).to_s
  end
end
