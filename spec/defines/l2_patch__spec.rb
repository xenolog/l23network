require 'spec_helper'

# NOTE: In this test 'p_39a440c1-N' is a patchcord name for
# ['br1', 'br2'] bridges. Central part of name calculated as
# CRC32 of patchcord resource name and depends ONLY of bridge
# names, that connected by patchcord.

describe 'l23network::l2::patch', :type => :define do
  let(:title) { 'Spec for l23network::l2::port' }
  let(:facts) { {
    :osfamily => 'Debian',
    :operatingsystem => 'Ubuntu',
    :kernel => 'Linux',
    :l23_os => 'ubuntu',
    :l3_fqdn_hostname => 'stupid_hostname',
  } }
  let(:pre_condition) { [
    "class {'l23network': }"
  ] }


  context 'Just a patch between two bridges' do
    let(:params) do
      {
        :bridges => ['br1', 'br2'],
      }
    end

    it do
      should compile.with_all_deps
    end

    it do
      should contain_l23_stored_config('p_39a440c1-0').with({
        'ipaddr'  => nil,
        'gateway' => nil,
        'onboot'  => true,
        'bridge'  => ['br1', 'br2'],
        'jacks'   => ['p_39a440c1-0', 'p_39a440c1-1']
      })
    end

    it do
      should contain_l2_patch('patch__br1--br2').with({
        'ensure'  => 'present',
        'bridges' => ['br1', 'br2'],
      }).that_requires('L23_stored_config[p_39a440c1-0]')
    end
  end

  context 'Just a patch between two bridges in reverse order' do
    let(:params) do
      {
        :bridges => ['br2', 'br1'],
      }
    end

    it do
      should compile.with_all_deps
    end

    it do
      should contain_l23_stored_config('p_39a440c1-0').with({
        'ipaddr'  => nil,
        'gateway' => nil,
        'onboot'  => true,
        'bridge'  => ['br2', 'br1'],
        'jacks'   => ['p_39a440c1-0', 'p_39a440c1-1']
      })
    end

    it do
      should contain_l2_patch('patch__br1--br2').with({
        'ensure'  => 'present',
        'bridges' => ['br2', 'br1'],
      }).that_requires('L23_stored_config[p_39a440c1-0]')
    end
  end

  context 'Just a patch between two OVS bridges' do
    let(:params) do
      {
        :bridges  => ['br1', 'br2'],
        :provider => 'ovs'
      }
    end

    it do
      should compile.with_all_deps
    end

    it do
      should contain_l23_stored_config('p_39a440c1-0').with({
        'ipaddr'  => nil,
        'gateway' => nil,
        'onboot'  => true,
        'bridge'  => ['br1', 'br2'],
        'jacks'   => ['p_39a440c1-0', 'p_39a440c1-1']
      })
    end

    it do
      should contain_l2_patch('patch__br1--br2').with({
        'ensure'  => 'present',
        'bridges' => ['br1', 'br2'],
        'jacks'   => ['p_39a440c1-0', 'p_39a440c1-1']
      }).that_requires('L23_stored_config[p_39a440c1-0]')
    end
  end

  context 'Patch, which has jumbo frames' do
    let(:params) do
      {
        :bridges => ['br1', 'br2'],
        :mtu     => 9000,
      }
    end

    it do
      should compile
      should contain_l23_stored_config('p_39a440c1-0').with({
        'bridge'  => ['br1', 'br2'],
        'jacks'   => ['p_39a440c1-0', 'p_39a440c1-1'],
        'mtu'     => 9000,
      })
      should contain_l2_patch('patch__br1--br2').with({
        'ensure'  => 'present',
        'mtu'     => 9000,
        'bridges' => ['br1', 'br2'],
      }).that_requires('L23_stored_config[p_39a440c1-0]')
    end
  end

  context 'Patch, which has vendor-specific properties' do
    let(:params) do
      {
        :bridges         => ['br1', 'br2'],
        :vendor_specific => {
            'aaa' => '111',
            'bbb' => {
                'bbb1' => 1111,
                'bbb2' => ['b1','b2','b3']
            },
        },
      }
    end

    it do
      should compile
      should contain_l23_stored_config('p_39a440c1-0').with({
        'bridge'          => ['br1', 'br2'],
        'jacks'           => ['p_39a440c1-0', 'p_39a440c1-1'],
        'vendor_specific' => {
            'aaa' => '111',
            'bbb' => {
                'bbb1' => 1111,
                'bbb2' => ['b1','b2','b3']
            },
        },
      })
      should contain_l2_patch('patch__br1--br2').with({
        'ensure'  => 'present',
        'bridges' => ['br1', 'br2'],
        'vendor_specific' => {
            'aaa' => '111',
            'bbb' => {
                'bbb1' => 1111,
                'bbb2' => ['b1','b2','b3']
            },
        },
      }).that_requires('L23_stored_config[p_39a440c1-0]')
    end
  end

  context 'Tagged patchcord between OVS bridges' do
    let(:params) do
      {
        :bridges  => ['br1', 'br2'],
        :vlan_ids => ['101', '202'],
        :provider => 'ovs'
      }
    end

    it do
      should compile.with_all_deps
    end

    it do
      should contain_l23_stored_config('p_39a440c1-0').with({
        'bridge'  => ['br1', 'br2'],
        'jacks'   => ['p_39a440c1-0', 'p_39a440c1-1']
      })
    end

    it do
      should contain_l2_patch('patch__br1--br2').with({
        'ensure'   => 'present',
        'vlan_ids' => ['101', '202'],
        'bridges'  => ['br1', 'br2'],
      }).that_requires('L23_stored_config[p_39a440c1-0]')
    end
  end


end
# vim: set ts=2 sw=2 et