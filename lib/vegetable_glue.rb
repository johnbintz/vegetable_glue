require "vegetable_glue/version"
require 'net/http'
require 'fileutils'

module VegetableGlue
  autoload :Runner, 'vegetable_glue/runner'

  ACCEPTANCE = '__acceptance__'
  CLEAN = '__clean__'

  class << self
    attr_accessor :url, :path, :env, :cleaning_style

    def shutdown
      Runner.new(options).shutdown
    end

    def clean(name = nil)
      Runner.new(options).clean(name)
    end

    def env
      @env ||= :cucumber
    end

    private
    def options
      { :url => url, :path => path, :env => env }
    end
  end

  if defined?(::Rails) && defined?(::Rails::Railtie)
    class Railtie < ::Rails::Railtie
      rake_tasks do
        self.class.send(:include, Rake::DSL)

        desc "Stop the dependent application"
        task "vegetable:unglue" => :environment do
          VegetableGlue.shutdown
        end

        desc "Restart the dependent application"
        task "vegetable:reglue" => :environment do
          VegetableGlue.shutdown
          VegetableGlue.clean
        end
      end
    end
  end
end

