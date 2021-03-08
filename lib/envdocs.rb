require 'envdocs/railtie'

module Envdocs
  class << self
    attr_reader :environment, :filename, :opts

    def configure(filename:, environment:, opts: {})
      @configured = true
      @environment = environment
      @filename = filename
      @opts = opts
      @sampler = Sampler.new(filename, environment)
    end

    # @param [String] filename
    # @param [String] environment
    # @param [Hash] opts
    #   => [Booleam] include_optional
    # @return [Array[String]]
    def find_missing_keys
      unless @configured
        raise StandardError, 'Envdocs environment must be configured before running this command'
      end
      # If optionals included, return all. 
      # Otherwise, return only keys that are marked as required.
      result = {}
      keys_to_search = @sampler.env_keys.select { |ek| @opts[:include_optional] || ek['required'] }

      keys_to_search.each { |ek| result[ek['key']] = ENV.fetch(ek['key'], nil) }

      result.reject { |k,v| !v.nil? }.keys
    end
  end

  # Retrieves keys for an environment from a sample template
  class Sampler
    attr_reader :filename, :template, :curr_env, :env_keys

    def initialize(filename, curr_env)
      @filename = filename
      @curr_env = curr_env
      @template = retrieve_keys_template(filename)
      @env_keys = retrieve_keys_for_env_from_template(curr_env)
    end

    private

    def retrieve_keys_template(filename)
      YAML.load(File.read(Rails.root.join('config', filename)))
    end

    def retrieve_keys_for_env_from_template(curr_env)
      @template.find { |k| k[curr_env].present? }[curr_env]
    end
  end
end
