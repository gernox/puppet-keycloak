require 'spec_helper'

describe 'gernox_keycloak', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'compile' do
        let(:params) do
          {
            http_port: 4711,
            admin_password: 'admin',
            keycloak_version: '123',
            postgresql_version: '456',
            db_password: 'pwd',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('gernox_docker') }
      end
    end
  end
end
