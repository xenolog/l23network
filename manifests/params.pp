class l23network::params {
  if is_float($::kernelmajversion) {
    $kernelmajversion_f = 0 + $::kernelmajversion  # just a hack for convert string to float
  } else {
    $kernelmajversion_f = -1
  }
  case $::osfamily {
    /(?i)debian/: {
      $ovs_service_name   = 'openvswitch-switch'
      $ovs_status_cmd     = '/etc/init.d/openvswitch-switch status'
      $lnx_vlan_tools     = 'vlan'
      $lnx_bond_tools     = 'ifenslave'
      $lnx_ethernet_tools = 'ethtool'
      if $kernelmajversion_f > 0 and $kernelmajversion_f < 3.13 {
        $ovs_packages       = ['openvswitch-datapath-dkms', 'openvswitch-switch']
      } else {
        $ovs_packages       = ['openvswitch-switch']
      }
    }
    /(?i)redhat/: {
      $ovs_service_name   = 'openvswitch' #'ovs-vswitchd'
      $ovs_status_cmd     = '/etc/init.d/openvswitch status'
      $lnx_vlan_tools     = 'vconfig'
      $lnx_bond_tools     = undef
      $lnx_ethernet_tools = 'ethtool'
      if $kernelmajversion_f > 0 and $kernelmajversion_f < 3.10 {
        $ovs_packages       = ['kmod-openvswitch', 'openvswitch']
      } else {
        $ovs_packages       = ['openvswitch']
      }
    }
    /(?i)linux/: {
      case $::operatingsystem {
        /(?i)archlinux/: {
          $ovs_service_name   = 'openvswitch.service'
          $ovs_status_cmd     = 'systemctl status openvswitch'
          $ovs_packages       = ['aur/openvswitch']
          $lnx_vlan_tools     = 'aur/vconfig'
          $lnx_bond_tools     = 'core/ifenslave'
          $lnx_ethernet_tools = 'extra/ethtool'
        }
        default: {
          fail("Unsupported OS: ${::osfamily}/${::operatingsystem}")
        }
      }
    }
    default: {
      fail("Unsupported OS: ${::osfamily}/${::operatingsystem}")
    }
  }
}
