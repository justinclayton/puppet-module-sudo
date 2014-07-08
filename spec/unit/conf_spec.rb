require 'spec_helper'

describe 'sudo::conf', :type => :define do
  let(:title) { 'testing' }

  let(:facts) do
    { :osfamily => 'redhat' }
  end

  let(:params) do
    {
      :ensure          => 'present',
      :sudo_config_dir => '/etc/sudoers.d'
    }
  end

  context 'using source' do
    let(:params) do
      { :source => 'puppet:///testmodule/testsource' }
    end

    it do
      should contain_file('testing').with({
        :ensure  => 'present',
        :path    => '/etc/sudoers.d/testing',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0440',
        :source  => 'puppet:///testmodule/testsource',
      })
    end
  end

  context 'using content' do
    let(:params) do
      {
        :content => 'testuser ALL=(ALL) NOPASSWD: ALL'
      }
    end

    it do
      should contain_file('testing').with({
        :ensure  => 'present',
        :path    => '/etc/sudoers.d/testing',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0440',
        :content => /testuser ALL=\(ALL\) NOPASSWD: ALL\n/,
      })
    end
  end

  context 'using a priority of 42' do
    let(:params) do
      { :priority => '42' }
    end

    it do
      should contain_file('42_testing').with({
        :path => '/etc/sudoers.d/42_testing',
      })
    end
  end
end
