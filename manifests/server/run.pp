# @summary
#   Manages the Keycloak docker containers
#
# @param http_port
#
# @param admin_user_name
#
# @param admin_password
#
# @param db_user
#
# @param db_password
#
# @param db_name
#
# @param keycloak_version
#
class gernox_keycloak::server::run (
  String $base_url         = $gernox_keycloak::base_url,
  Integer $http_port       = $gernox_keycloak::http_port,

  String $admin_user_name  = $gernox_keycloak::admin_user_name,
  String $admin_password   = $gernox_keycloak::admin_password,

  String $db_user          = $gernox_keycloak::db_user,
  String $db_password      = $gernox_keycloak::db_password,
  String $db_name          = $gernox_keycloak::db_name,
  String $db_host          = $gernox_keycloak::db_host,
  Integer $db_port         = $gernox_keycloak::db_port,

  String $keycloak_version = $gernox_keycloak::keycloak_version,

  String $log_level        = $gernox_keycloak::log_level,
) {
  $docker_environment = [
    'DB_VENDOR=POSTGRES',
    "DB_ADDR=${db_host}",
    "DB_PORT=${db_port}",
    "DB_DATABASE=${db_name}",
    "DB_USER=${db_user}",
    "DB_PASSWORD=${db_password}",
    "KEYCLOAK_USER=${admin_user_name}",
    "KEYCLOAK_PASSWORD=${admin_password}",
    'PROXY_ADDRESS_FORWARDING=true',
    "KEYCLOAK_FRONTEND_URL=${base_url}",
    "KEYCLOAK_LOGLEVEL=${log_level}",
    "ROOT_LOGLEVEL=${log_level}",
  ]

  $network_name = 'keycloak-network'

  docker_network { $network_name:
    ensure  => present,
    options => 'com.docker.network.bridge.name=br-keycloak',
  }

  firewall { '002 - IPv4: accept all br-keycloak':
    iniface => 'br-keycloak',
    action  => 'accept',
  }

  ::docker::run { 'keycloak':
    image                 => "jboss/keycloak:${keycloak_version}",
    env                   => $docker_environment,
    health_check_interval => 30,
    ports                 => [
      "${http_port}:8080",
    ],
    net                   => $network_name,
  }
}
