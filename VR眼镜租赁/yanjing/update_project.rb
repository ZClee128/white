require 'xcodeproj'

project_path = 'yanjing.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

group = project.main_group.find_subpath(File.join('yanjing'), true)
files_to_add = [
  'Models.swift',
  'HomeView.swift',
  'ProductDetailView.swift',
  'CartView.swift',
  'OrdersView.swift',
  'SettingsView.swift',
  'CheckoutView.swift'
]

files_to_add.each do |file_name|
  unless group.children.find { |c| c.path == file_name }
    file_ref = group.new_file(file_name)
    target.source_build_phase.add_file_reference(file_ref)
    puts "Added #{file_name} to project."
  else
    puts "#{file_name} is already in the project."
  end
end

# Update Info.plist to add LSApplicationQueriesSchemes for weixin
# For modern SwiftUI apps, build settings often hold these
project.targets.each do |target|
  target.build_configurations.each do |config|
    config.build_settings['INFOPLIST_KEY_LSApplicationQueriesSchemes_0'] = 'weixin'
  end
end

project.save
puts "Project successfully updated and saved."
