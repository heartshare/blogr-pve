class pve::profiles::reverseproxy(
  $app_hosts,
  $server_names
){

  package { 'nginx':
    ensure => purged,
  }
  package { 'nginx-common':
    ensure => purged,
  }

  include ::haproxy

  haproxy::balancermember { 'haproxy':
    listening_service => 'blogr_frontend',
    server_names      => $server_names,
    ipaddresses       => $app_hosts,
    options           => 'check fall 3 rise 2',
    ports             => '3000'
  }

  haproxy::frontend { 'blogr_frontend':
    ipaddress => '0.0.0.0',
    ports     => '80',
    mode      => 'http',
    options   => {
      'use_backend' => 'blogr_backend'
    }
  }

  haproxy::backend { 'blogr_backend':
    mode => 'http',
    options => {
      'option'  => [
        'httpchk HEAD /api/system/ping HTTP/1.1',
      ],
      'balance' => 'roundrobin',
    },
  }
}
