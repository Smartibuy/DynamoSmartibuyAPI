Dir.glob('./{config,models,controllers}/init.rb').each do |file|
  require file
end

run SmartibuyDynamo
