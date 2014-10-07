[![Build Status](https://travis-ci.org/justinclayton/puppet-module-sudo.png?branch=master)](https://travis-ci.org/justinclayton/puppet-module-sudo)

##Description
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/justinclayton/puppet-module-sudo?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This module allows you to easily manage sudo, no matter how complex or simple your configuration needs to be. It is fully backwards-compatible with those  ```sudo::conf``` defined types. It has been tested for quality using [puppet-lint](http://github.com/puppetlabs/puppet-lint), [rspec-puppet](http://github.com/rodjek/rspec-puppet), and [rspec-system](http://github.com/puppetlabs/rspec-system).

##Installation

If you're using librarian-puppet, add a line to your `Puppetfile`:

```ruby
mod 'justinclayton/sudo', '1.x'
```

##Usage

###Level 1

```puppet
include sudo
```

This will install sudo and add its own sudoers file, but don't worry; that sudoers file still matches your OS flavor's defaults.

```puppet
sudo::conf { 'dudr':
  content => 'dudr ALL=(ALL) NOPASSWD: ALL',
}
```

This will create a file called ```/etc/sudoers.d/dudr``` with the supplied content. Note that if you use ```sudo::conf``` you do not need to explicitly ```include sudo``` elsewhere.

###Level 2

```puppet
class { 'sudo':
  manage_sudoersd => false,
}
```

By default this module wants to manage the entire sudoers.d directory, which includes removing any files not explicitly managed by this module. While this can be very good for keeping a handle on configs outside of puppet, there are cases (particularly during an initial transition to puppet) where you will want to allow for both. Disabling ```manage_sudoersd``` allows for this.

```puppet
class { 'sudo':
  keep_os_defaults     => false,
  sudoers_file_content => template('mymodule/sudoers.erb'),
}
```

If you know what you're doing and want to build a sudoers file from scratch (including ignoring what the OS tries to do for you), the above code can make that happen for you.

###Level 3

```puppet
class { 'sudo':
  keep_os_defaults => false,
  defaults_hash    => {
    requiretty     => false,
    visiblepw      => true,
  },
  confs_hash       => {
    'dudr'         => {
      ensure       => present,
      content      => 'dudr ALL=(ALL) NOPASSWD: ALL',
    },
    'fudr'         => {
      ensure       => present,
      content      => 'fudr ALL=(ALL): /bin/echo',
    },
  },
}
```

As an alternative to sprinkling ```sudo::conf``` resources all throughout your codebase, you may wish to consolidate all your data into a single manifest, or be even more fancy and pull it in from something like hiera. This module makes this a snap by allowing you to pass a hash of ```sudo::conf``` resources as a class parameter. The below example shows how you can easily extract this data out of your manifests and into hiera, allowing you to do things like easily delegate sudoers.d content to other groups within your organization:

```yaml
---
sudo::confs_hash:
  dudr:
      ensure: present
      content: 'dudr ALL=(ALL) NOPASSWD: ALL'
  fudr:
    ensure: present,
    content: 'fudr ALL=(ALL): /bin/echo'
```

For more information on how you can do automated class parameter lookup via hiera, see [this doc](https://docs.puppetlabs.com/hiera/1/puppet.html#automatic-parameter-lookup).
