class sudo::params {

  $package_name           = 'sudo'
  $package_ensure         = 'present'
  $sudoers_file_path      = '/etc/sudoers'
  $sudoersd_path          = '/etc/sudoers.d'

  case $::osfamily {
    debian: {
      $env_keeps = [
        'LANG',
        'LANGUAGE',
        'LINGUAS',
        'LC_*',
        '_XKB_CHARSET',
        'XAPPLRESDIR',
        'XFILESEARCHPATH',
        'XUSERFILESEARCHPATH',
      ]
      $os_defaults = {
        'env_keep' => join($env_keeps, ' ')
      }
    }
    redhat: {
      $env_keeps = [
        'COLORS',
        'DISPLAY',
        'HOSTNAME',
        'HISTSIZE',
        'INPUTRC',
        'KDEDIR',
        'LS_COLORS',
        'MAIL',
        'PS1',
        'PS2',
        'QTDIR',
        'USERNAME',
        'LANG',
        'LC_ADDRESS',
        'LC_CTYPE',
        'LC_COLLATE',
        'LC_IDENTIFICATION',
        'LC_MEASUREMENT',
        'LC_MESSAGES',
        'LC_MONETARY',
        'LC_NAME',
        'LC_NUMERIC',
        'LC_PAPER',
        'LC_TELEPHONE',
        'LC_TIME',
        'LC_ALL',
        'LANGUAGE',
        'LINGUAS',
        '_XKB_CHARSET',
        'XAUTHORITY',
      ]
      $os_defaults = {
        'requiretty'      => true,
        'visiblepw'       => false,
        'always_set_home' => true,
        'env_reset'       => true,
        'env_keep'        => join($env_keeps, ' '),
        'secure_path'     => '/sbin:/bin:/usr/sbin:/usr/bin',
      }
    }
    default: {
      warning("Unsupported osfamily '${::osfamily}'")
    }
  }
}
