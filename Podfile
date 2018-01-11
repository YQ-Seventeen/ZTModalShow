# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
        end
    end
end

target 'ZTModalShow' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for ZTModalShow
#   pod 'ZTModalShow', :git => 'https://github.com/YQ-Seventeen/ZTModalShow.git'
   pod 'ZTModalShow', :path => '../ZTModalShow'
end
