# @summary
#   Manages the keycloak docker images
#
# @param keycloak_version
#
# @param postgresql_version
#
class gernox_keycloak::server::images (
  String $keycloak_version   = $gernox_keycloak::keycloak_version,
  String $postgresql_version = $gernox_keycloak::postgresql_version,
) {
  ::docker::image { 'keycloak':
    ensure    => present,
    image     => 'jboss/keycloak',
    image_tag => $keycloak_version,
  }

  ::docker::image { 'keycloak-postgres':
    ensure    => present,
    image     => 'postgres',
    image_tag => $postgresql_version,
  }
}
