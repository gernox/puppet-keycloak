# @summary
#   Manages a keycloak instance within docker
#
# @param http_port
#
# @param admin_user_name
#
# @param admin_password
#
# @param keycloak_version
#
# @param postgresql_version
#
# @param db_user
#
# @param db_password
#
# @param db_name
#
class gernox_keycloak (
  Integer $http_port,

  String $admin_user_name,
  String $admin_password,

  String $keycloak_version,
  String $postgresql_version,

  String $db_user,
  String $db_password,
  String $db_name,
) {
  contain ::gernox_docker
  contain ::gernox_keycloak::server::images
  contain ::gernox_keycloak::server::run

  # Order of execution
  Class['::gernox_docker']
  -> Class['::gernox_keycloak::server::images']
  ~> Class['::gernox_keycloak::server::run']

  # Script for database backup
  file { '/gernox/keycloak_psql_backup.sh':
    ensure  => present,
    mode    => '0750',
    content => template('gernox_keycloak/keycloak_psql_backup.sh.erb'),
  }

  # Systemd service and timer for database backup
  file { '/etc/systemd/system/docker-keycloak-postgres-pgdump.service':
    ensure  => present,
    content => file('gernox_keycloak/docker-keycloak-postgres-pgdump.service'),
    notify  => Service['docker-keycloak-postgres-pgdump'],
  }

  file { '/etc/systemd/system/docker-keycloak-postgres-pgdump.timer':
    ensure  => present,
    content => file('gernox_keycloak/docker-keycloak-postgres-pgdump.timer'),
    notify  => Service['docker-keycloak-postgres-pgdump'],
  }

  service { 'docker-keycloak-postgres-pgdump':
    ensure  => running,
    enable  => true,
    name    => 'docker-keycloak-postgres-pgdump.timer',
    require => [
      File['/gernox/keycloak_psql_backup.sh'],
      File['/etc/systemd/system/docker-keycloak-postgres-pgdump.timer'],
      File['/etc/systemd/system/docker-keycloak-postgres-pgdump.service'],
    ],
  }
}
