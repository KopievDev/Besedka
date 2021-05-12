# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
  end
 end
end

target 'Besedka' do

  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Besedka
  pod 'Firebase/Firestore', '7.8'
  pod 'SwiftLint'

end
