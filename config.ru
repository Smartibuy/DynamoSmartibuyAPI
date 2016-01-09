Dir.glob('./{config,models,controllers,helpers,form}/init.rb').each do |file|
  require file
end

run SmartibuyDynamo
