# Define: sudo::defaults
# Parameters:
# $defaults_hash
#
define sudo::defaults ($ensure = present, $defaults_hash) {
  sudo::conf { $title:
    ensure  => $ensure,
    content => template('sudo/defaults.erb'),
  }
}