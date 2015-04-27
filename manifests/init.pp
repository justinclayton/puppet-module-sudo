# Class: sudo
#
class sudo (
  $manage_sudoers_file   = true,
  $manage_sudoersd       = true,
  $keep_os_defaults      = true,
  $package_name          = $sudo::params::package_name,
  $package_ensure        = $sudo::params::package_ensure,
  $sudoers_file_path     = $sudo::params::sudoers_file_path,
  $sudoersd_path         = $sudo::params::sudoersd_path,
  $sudo_check_cmd        = $sudo::params::sudo_check_cmd,
  $sudoers_file_content  = undef,
  $defaults_hash         = undef,
  $confs_hash            = undef
) inherits sudo::params {

  package { $package_name:
    ensure => $package_ensure,
  }

  if $manage_sudoers_file {

    if $sudoers_file_content {
      $content_real = $sudoers_file_content
    } else {
      $content_real = template('sudo/sudoers_file.erb')
    }

    file { $sudoers_file_path:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      replace => $manage_sudoers_file,
      content => $content_real,
      require => Package[$package_name],
    }
  }

  if $manage_sudoersd {
    file { $sudoersd_path:
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0550',
      recurse => $manage_sudoersd,
      purge   => $manage_sudoersd,
      require => Package[$package_name],
    }
  }

  if $keep_os_defaults {
    sudo::defaults { 'os_defaults':
      defaults_hash => $sudo::params::os_defaults,
    }
  }

  if $defaults_hash {
    sudo::defaults { 'custom_defaults':
      defaults_hash => $defaults_hash,
    }
  }

  if $confs_hash {
    create_resources('sudo::conf', $confs_hash)
  }
}
