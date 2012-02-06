Before do |scenario|
  if ENV['REGLUE']
    VegetableGlue.shutdown

    ENV.delete('REGLUE')
  end

  VegetableGlue.clean(scenario.to_sexp[3])
end

