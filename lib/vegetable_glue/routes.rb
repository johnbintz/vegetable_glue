class ActionDispatch::Routing::Mapper
  def acceptance_helper_routes
    acceptance_helper_routes_for
  end

  def acceptance_helper_routes_for(env = :acceptance)
    if Rails.env.to_sym == env
      get VegetableGlue::ACCEPTANCE => lambda { |env| [ 200, {}, [ VegetableGlue::ACCEPTANCE ] ] }

      get VegetableGlue::CLEAN => lambda { |env|
        require 'database_cleaner'

        DatabaseCleaner.clean_with :truncation

        if scenario_name = URI.decode_www_form(env['QUERY_STRING']).first
          Rails.logger.info "Cleaning database for #{scenario_name.last}"
        end

        [ 200, {}, [ VegetableGlue::CLEAN ] ]
      }
    end
  end
end

