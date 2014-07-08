# Define: sudo::conf
#
define sudo::conf (
  $ensure   = present,
  $content  = undef,
  $source   = undef,
  $priority = undef,
) {

  include sudo

  ## TODO: include validation to prevent passing both source *and* content

  if $content != undef {
    $content_real = "${content}\n"
  } else {
    $content_real = undef
  }

  if $priority != undef {
    $name_real = "${priority}_${name}"
  } else {
    $name_real = $name
  }

  file { $name_real:
    ensure  => $ensure,
    path    => "${sudo::sudoersd_path}/${name_real}",
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    source  => $source,
    content => $content_real,
  }
}
