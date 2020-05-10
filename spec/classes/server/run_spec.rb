require 'spec_helper'

describe 'gernox_keycloak::server::run' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          http_port: 4711,
          admin_user_name: 'admin',
          admin_password: 'password',
          db_user: 'db_user',
          db_password: 'db_password',
          db_name: 'db_name',
          keycloak_version: '123',
          postgresql_version: '456',
        }
      end

      let(:pre_condition) { 'contain ::gernox_docker' }

      it { is_expected.to compile }
      it {
        is_expected.to contain_docker__run('keycloak-postgres')
          .with(
            image: 'postgres:456',
          )
      }
      it {
        is_expected.to contain_docker__run('keycloak')
          .with(
            image: 'jboss/keycloak:123',
          )
      }
    end
  end
end
