Puppet::Type.newtype(:l2_ovs_bridge) do
    @doc = "Manage a Open vSwitch bridge (virtual switch)"
    desc @doc

    ensurable

    newparam(:bridge) do
      isnamevar
      desc "The bridge to configure"
      #
      validate do |val|
        if not val =~ /^[a-z][0-9a-z\.\-\_]*[0-9a-z]$/
          fail("Invalid bridge name: '#{val}'")
        end
      end
    end

    newparam(:port_properties) do
      defaultto([])
      desc "Array of port properties"
      validate do |val|
        if not (val.is_a?(Array) or val.is_a?(String)) # String need for array with one element. it's a puppet's feature
          fail("port_properties must be an array (not #{val.class}).")
        end
      end
    end

    newparam(:interface_properties) do
      defaultto([])
      desc "Array of port interface properties"
      validate do |val|
        if not (val.is_a?(Array) or val.is_a?(String)) # String need for array with one element. it's a puppet's feature
          fail("interface_properties must be an array (not #{val.class}).")
        end
      end
    end

    newparam(:skip_existing) do
      defaultto(false)
      desc "Allow to skip existing bridge"
    end

    newproperty(:external_ids) do
      desc "External IDs for the bridge"
    end
end
