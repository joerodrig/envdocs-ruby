require "envdocs/railtie"

module Envdocs
  # @param [String] filename
  # @param [String] curr_env
  # @param [Hash] opts
  #   => [Booleam] include_optional
  # @return [Array[String]]
  def self.find_missing_keys(filename, curr_env, opts={})
    expected_keys = retrieve_keys_template(filename)
    expected_keys_for_env = retrieve_keys_for_env_from_template(expected_keys, curr_env)
    missing_keys(expected_keys_for_env, opts)
  end

  private 

  def self.retrieve_keys_template(filename)
    YAML.load(File.read(Rails.root.join("config", filename)))
  end

  def self.retrieve_keys_for_env_from_template(template, curr_env)
    template.find { |k| k[curr_env].present? }[curr_env]
  end

  def self.missing_keys(expected_keys, opts)
    result = {}

    # If optionals included, return all. 
    # Otherwise, return only keys that are marked as required.
    keys_to_search = expected_keys.select do |ek|
      opts[:include_optional] || ek["required"]
    end

    keys_to_search.each do |ek| 
      result[ek["key"]] = ENV.fetch(ek["key"], nil) 
    end

    result.reject { |k,v| !v.nil? }.keys
  end
end
