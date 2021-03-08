require "minitest/spec"
require 'test_helper'

class Envdocs::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Envdocs
  end

  describe '#configure' do
    it 'Envdocs configure' do
      Envdocs.configure(filename:'sample_keys.yml', environment:'test', opts:{include_optional: false})
      assert_equal 'sample_keys.yml', Envdocs.filename
      assert_equal 'test', Envdocs.environment
      assert_equal Hash, Envdocs.opts.class
    end

    it 'Envdocs configure, default opts' do
      Envdocs.configure(filename:'sample_keys.yml', environment:'test')
      assert_equal 'sample_keys.yml', Envdocs.filename
      assert_equal 'test', Envdocs.environment
      assert_equal Hash, Envdocs.opts.class
    end
  end

  describe '#find_missing_keys' do
    describe 'when an invalid template is provided' do
      it 'raises' do
        assert_raises Errno::ENOENT do 
          Envdocs.configure(filename:'invalid_file.yml', environment:'test', opts:{include_optional: false})
          Envdocs.find_missing_keys
        end
      end
    end

    describe 'when getting only required keys' do
      it 'returns any required keys missing' do
        Envdocs.configure(filename:'sample_keys.yml', environment:'test', opts:{include_optional: false})

        ENV.replace('RAILS_ENV' => 'test', 'foo' => '1')
        assert_equal [], Envdocs.find_missing_keys

        ENV.replace('foo' => '1')
        assert_equal ['RAILS_ENV'], Envdocs.find_missing_keys
      end
    end

    describe 'when getting required and optional keys' do
      it 'returns any keys missing' do
        Envdocs.configure(filename:'sample_keys.yml', environment:'test', opts:{include_optional: true})
        
        ENV.replace('RAILS_ENV' => 'test', 'foo' => '1')
        assert_equal ["FOO"], Envdocs.find_missing_keys

        ENV.replace('RAILS_ENV' => 'test', 'FOO' => '1')
        assert_equal [], Envdocs.find_missing_keys
      end
    end

    describe 'when getting keys with mismatched cases' do
      it 'returns any mismatched keys as if they are missing' do
        Envdocs.configure(filename:'sample_keys.yml', environment:'test', opts:{include_optional: true})
        
        ENV.replace('rails_env' => 'test', 'foo' => '1')
        assert_equal ["RAILS_ENV", "FOO"], Envdocs.find_missing_keys
      end
    end
  end
end
