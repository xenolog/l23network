Puppet::Type.type(:l2_ovs_bridge).provide(:ovs) do
  optional_commands :vsctl => "/usr/bin/ovs-vsctl"

  def exists?
    vsctl("br-exists", @resource[:bridge])
  rescue Puppet::ExecutionFailure
    return false
  end

  def create
    begin
      vsctl('br-exists', @resource[:bridge])
      if @resource[:skip_existing]
        notice("Bridge '#{@resource[:bridge]}' already exists, skip creating.")
        #external_ids = @resource[:external_ids] if @resource[:external_ids]
        set_port_properties()
        set_interface_properties()
        return true
      else
        raise Puppet::ExecutionFailure, "Bridge '#{@resource[:bridge]}' already exists."
      end
    rescue Puppet::ExecutionFailure
      # pass
      notice("Bridge '#{@resource[:bridge]}' not exists, creating...")
    end
    vsctl('add-br', @resource[:bridge])
    notice("bridge '#{@resource[:bridge]}' created.")
    set_port_properties()
    set_interface_properties()
    external_ids = @resource[:external_ids] if @resource[:external_ids]
  end

  def destroy
    vsctl("del-br", @resource[:bridge])
  end

  def _split(string, splitter=",")
    return Hash[string.split(splitter).map{|i| i.split("=")}]
  end

  def external_ids
    result = vsctl("br-get-external-id", @resource[:bridge])
    return result.split("\n").join(",")
  end

  def external_ids=(value)
    old_ids = _split(external_ids)
    new_ids = _split(value)

    new_ids.each_pair do |k,v|
      unless old_ids.has_key?(k)
        vsctl("br-set-external-id", @resource[:bridge], k, v)
      end
    end
  end

  private

  def set_port_properties()
    if @resource[:interface_properties]
      for option in Array(@resource[:interface_properties])
        begin
          vsctl('--', "set", "Port", @resource[:bridge], option.to_s)
        rescue Puppet::ExecutionFailure => error
          raise Puppet::ExecutionFailure, "Interface '#{@resource[:bridge]}' can't set option '#{option}':\n#{error}"
        end
      end
    end
    return true
  end

  def set_interface_properties()
    if @resource[:interface_properties]
      for option in Array(@resource[:interface_properties])
        begin
          vsctl('--', "set", "Interface", @resource[:bridge], option.to_s)
        rescue Puppet::ExecutionFailure => error
          raise Puppet::ExecutionFailure, "Interface '#{@resource[:bridge]}' can't set option '#{option}':\n#{error}"
        end
      end
    end
    return true
  end

end
