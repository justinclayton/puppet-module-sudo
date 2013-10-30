# Define: sudo::conf
#
define sudo::conf (
  $ensure  = present,
  $content = undef,
  $source  = undef
) {

  include sudo

  ## TODO: include validation to prevent passing both source *and* content

  if $content != undef {
    $content_real = "${content}\n"
  } else {
    $content_real = undef
  }

  file { $name:
    ensure  => $ensure,
    path    => "${sudo::sudoersd_path}/${name}",
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    source  => $source,
    content => $content_real,
  }
}
