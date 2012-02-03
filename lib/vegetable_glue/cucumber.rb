Before do
  if ENV['REGLUE']
    VegetableGlue.shutdown

    ENV.delete('REGLUE')
  end

  VegetableGlue.clean
end

