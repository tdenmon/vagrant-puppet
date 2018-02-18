node default {
    exec { "apt-get update":
      path => "/usr/bin",
    }
}

node 'puppetagent.puppetdebug.vlan' {
    include lamp
}
