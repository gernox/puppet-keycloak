# @summary
#   Manages a keycloak instance within docker
#
# @param base_url
#
# @param http_port
#
# @param admin_user_name
#
# @param admin_password
#
# @param keycloak_version
#
# @param db_user
#
# @param db_password
#
# @param db_name
#
# @param db_host
#
# @param db_port
#
class gernox_keycloak (
  String $base_url,
  Integer $http_port,

  String $admin_user_name,
  String $admin_password,

  String $keycloak_version,

  String $db_user,
  String $db_password,
  String $db_name,
  String $db_host,
  Integer $db_port,

  String $log_level,
) {
  contain ::gernox_docker
  contain ::gernox_keycloak::server::images
  contain ::gernox_keycloak::server::run

  # Order of execution
  Class['::gernox_docker']
  -> Class['::gernox_keycloak::server::images']
  ~> Class['::gernox_keycloak::server::run']
}
