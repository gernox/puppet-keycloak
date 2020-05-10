require 'spec_helper'

describe 'gernox_keycloak::server::images' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          keycloak_version: '123',
          postgresql_version: '456',
        }
      end

      it { is_expected.to compile.with_all_deps }
      it {
        is_expected.to contain_docker__image('keycloak')
          .with(
            image: 'jboss/keycloak',
            image_tag: '123',
          )
      }
      it {
        is_expected.to contain_docker__image('keycloak-postgres')
          .with(
            image: 'postgres',
            image_tag: '456',
          )
      }
    end
  end
end
