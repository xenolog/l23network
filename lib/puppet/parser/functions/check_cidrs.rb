#
# check_cidrs.rb
#

module Puppet::Parser::Functions
  newfunction(:check_cidrs, :doc => <<-EOS
This function get array of cidr-notated IP addresses and check it syntax.
Raise exception if syntax not right. 
EOS
  ) do |arguments|
    if arguments.size != 1
      raise(Puppet::ParseError, "check_cidrs(): Wrong number of arguments " +
        "given (#{arguments.size} for 1)") 
    end

    cidrs = arguments[0]

    if ! cidrs.is_a?(Array)
      raise(Puppet::ParseError, 'check_cidrs(): Requires array of IP addresses.')
    end
    if cidrs.length < 1
      raise(Puppet::ParseError, 'check_cidrs(): Must given one or more IP address.')
    end

    for cidr in cidrs do
      re_groups = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\/(\d{1,2})$/.match(cidr)
      if ! re_groups
        raise(Puppet::ParseError, "check_cidrs(): Wrong CIDR: '#{cidr}'.")
      end 
      for i in 1..4
        octet = re_groups[i]
        if ! ((octet =~ /\d+/) and (octet.to_i >= 0) and (octet.to_i <= 255))
          raise(Puppet::ParseError, "check_cidrs(): Wrong IP addr: '#{cidr}'.")
        end 
      end
      if ! ((re_groups[5] =~ /\d+/) and (re_groups[5].to_i >= 0) and (re_groups[5].to_i <= 255))
        raise(Puppet::ParseError, "check_cidrs(): Wrong masklen in: '#{cidr}'.")
      end
    end

    return true
  end
end

# vim: set ts=2 sw=2 et :
