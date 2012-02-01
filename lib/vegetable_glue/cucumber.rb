Before do
  if ENV['GLUE_RESTART']
    VegetableGlue.shutdown

    ENV.delete('GLUE_RESTART')
  end

  VegetableGlue.clean
end


