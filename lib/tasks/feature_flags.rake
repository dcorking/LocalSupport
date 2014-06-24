desc 'ff[:volunteer_ops_list][:on] turns on a feature flag, creating it if necessary'
task :ff, [:feature, :action] => :environment do |t, args|
  flag_name = args.feature
  state = (args.action == 'on')
  if f = Feature.find_by_name(args[:feature]) then
    f.active = state
    puts 'Found a flag and changing its state'
  else
    Feature.create!(name: flag_name, active: state)
    puts "Didn't find a '#{flag_name}' flag. Created it"
  end
  puts "Feature '#{flag_name}' is #{Feature.find_by_name(flag_name).active?}"
end
