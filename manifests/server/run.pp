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
# @param postgresql_version
#
class gernox_keycloak::server::run (
  Integer $http_port         = $gernox_keycloak::http_port,

  String $admin_user_name    = $gernox_keycloak::admin_user_name,
  String $admin_password     = $gernox_keycloak::admin_password,

  String $db_user            = $gernox_keycloak::db_user,
  String $db_password        = $gernox_keycloak::db_password,
  String $db_name            = $gernox_keycloak::db_name,

  String $keycloak_version   = $gernox_keycloak::keycloak_version,
  String $postgresql_version = $gernox_keycloak::postgresql_version,
) {
  $docker_environment = [
    'DB_VENDOR=POSTGRES',
    'DB_ADDR=db',
    'DB_PORT=5432',
    "DB_DATABASE=${db_name}",
    "DB_USER=${db_user}",
    "DB_PASSWORD=${db_password}",
    "KEYCLOAK_USER=${admin_user_name}",
    "KEYCLOAK_PASSWORD=${admin_password}",
    'PROXY_ADDRESS_FORWARDING=true',
  ]

  ::docker::run { 'keycloak-postgres':
    image                 => "postgres:${postgresql_version}",
    volumes               => [
      '/srv/docker/keycloak/postgresql/data:/var/lib/postgresql/data',
    ],
    health_check_interval => 30,
    env                   => [
      "POSTGRES_USER=${db_user}",
      "POSTGRES_PASSWORD=${db_password}",
      "POSTGRES_DB=${db_name}",
    ],
  }

  ::docker::run { 'keycloak':
    image                 => "jboss/keycloak:${keycloak_version}",
    env                   => $docker_environment,
    health_check_interval => 30,
    ports                 => [
      "${http_port}:8080",
    ],
    links                 => [
      'keycloak-postgres:db',
    ],
    depends               => [
      'keycloak-postgres',
    ],
  }¹
}
