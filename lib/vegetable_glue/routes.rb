class ActionDispatch::Routing::Mapper
  def acceptance_helper_routes
    acceptance_helper_routes_for
  end

  def acceptance_helper_routes_for(env = :acceptance)
    if Rails.env.to_sym == env
      get VegetableGlue::ACCEPTANCE => lambda { |env| [ 200, {}, [ VegetableGlue::ACCEPTANCE ] ] }

      get VegetableGlue::CLEAN => lambda { |env|
        require 'database_cleaner'

        params = Hash[URI.decode_www_form(env['QUERY_STRING'])]

        DatabaseCleaner.clean_with :truncation
        DatabaseCleaner.clean_with :deletion

        if params[:scenario]
          Rails.logger.info "Cleaning database for #{params[:scenario]}"
        end

        [ 200, {}, [ VegetableGlue::CLEAN ] ]
      }
    end
  end
end

