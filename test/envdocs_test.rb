require 'test_helper'

class Envdocs::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Envdocs
  end
  
  test "find_missing_keys, file not found" do
    assert_raises Errno::ENOENT do 
      Envdocs.find_missing_keys('invalid_file.yml', 'test', {include_optional: false})
    end
  end

  test "find_missing_keys, required only" do
    ENV.replace('RAILS_ENV' => 'test', 'foo' => '1')
    assert_equal [], Envdocs.find_missing_keys('sample_keys.yml', 'test', {include_optional: false})

    ENV.replace('foo' => '1')
    assert_equal ["RAILS_ENV"], Envdocs.find_missing_keys('sample_keys.yml', 'test', {include_optional: false})
  end

  test "find_missing_keys, include optional" do
    ENV.replace('RAILS_ENV' => 'test', 'foo' => '1')
    assert_equal ["FOO"], Envdocs.find_missing_keys('sample_keys.yml', 'test', {include_optional: true})
  end

  test "retrieve_keys_template, file not found" do
    assert_raises Errno::ENOENT do 
      Envdocs.retrieve_keys_template('invalid_file.yml')
    end
  end

  test "retrieve_keys_template, file found" do
    assert_equal Array, Envdocs.retrieve_keys_template('sample_keys.yml').class
  end
end
