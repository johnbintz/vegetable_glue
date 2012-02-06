module VegetableGlue
  class Runner
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def ensure_running
      port = options[:url].port

      result = nil
      was_running = false

      begin
        result = get_acceptance
        was_running = true
      rescue Errno::ECONNREFUSED => e
        $stdout.puts "Starting #{app_name}..."

        Bundler.with_clean_env do
          system %{cd #{options[:path]} && bundle exec rails server -p #{port} -d -e #{options[:env]} -P #{pid_path}}
        end

        raise StandardError.new("#{app_name} did not start up in 30 seconds!") if !(result = wait_for_up)
      end

      if result == VegetableGlue::ACCEPTANCE
        $stdout.puts "#{app_name} running on port #{port}" if !was_running
      else
        raise StandardError.new("Is #{app_name} running? You should have included the routes with `acceptance_helper_routes`")
      end
    end

    def shutdown
      if File.file?(pid_path)
        system %{kill -INT #{File.read(pid_path)}}

        wait_for_down

        $stdout.puts "#{app_name} shut down"
      end

      FileUtils.rm_f pid_path
    end

    def clean(name = nil)
      ensure_running

      uri = options[:url].merge(URI("/#{VegetableGlue::CLEAN}"))
      uri.query = URI.encode_www_form(:scenario => name) if name

      result = Net::HTTP.get(uri)

      raise StandardError.new("#{app_name} database not cleaned") if result != VegetableGlue::CLEAN
    end

    def pid_path
      File.join(File.expand_path(options[:path]), "tmp/pids/#{options[:env]}.pid")
    end

    private
    def get_acceptance
      Net::HTTP.get(options[:url].merge(URI("/#{VegetableGlue::ACCEPTANCE}")))
    end

    def app_name
      File.basename(options[:path])
    end

    def wait_for_down
      times = 30

      while times > 0
        begin
          Net::HTTP.get(options[:url])
        rescue Errno::ECONNREFUSED, Errno::ECONNRESET
          return true
        end

        times -= 1

        sleep 1
      end

      raise StandardError.new("#{app_name} did not shut down")
    end

    def wait_for_up
      times = 30
      result = nil

      while times > 0
        begin
          result = get_acceptance
        rescue Errno::ECONNREFUSED, Errno::ECONNRESET
        end

        break if result

        sleep 1

        times -= 1
      end

      result
    end
  end
end

