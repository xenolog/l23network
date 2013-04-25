class l23network::l2::centos_upndown_scripts {
  file {'/sbin/ifup-local':
    ensure  => present,
    owner   => 'root',
    mode    => '0755',
    recurse => true,
    content => template("l23network/centos_ifup-local.erb"),
  } ->
  file {'/sbin/ifdown-local':
    ensure  => present,
    owner   => 'root',
    mode    => '0755',
    recurse => true,
    content => template("l23network/centos_ifdown-local.erb"),
  } ->
  anchor { 'l23network::l2::centos_upndown_scripts': } 
  Anchor <| title == 'l23network::l2::centos_upndown_scripts' |> -> L23network::L3::Ifconfig <||>
}