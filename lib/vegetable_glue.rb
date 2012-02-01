require "vegetable_glue/version"
require 'net/http'
require 'fileutils'

module VegetableGlue
  autoload :Runner, 'vegetable_glue/runner'

  ACCEPTANCE = '__acceptance__'
  CLEAN = '__clean__'

  class << self
    attr_accessor :url, :path, :env

    def shutdown
      Runner.new(options).shutdown
    end

    def clean
      Runner.new(options).clean
    end

    def env
      @env ||= :cucumber
    end

    private
    def options
      { :url => url, :path => path, :env => env }
    end
  end
end


