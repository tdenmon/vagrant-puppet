class base {
    exec { "apt-get update":
      path => "/usr/bin",
    }

    service { 'puppet':
      ensure => 'running',
      enable => 'true',
    }
}
