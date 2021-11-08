require 'cocoapods-catalyst-support'

# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Casical' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'SideMenu'
  pod 'Charts'
  pod 'PKHUD'
  pod 'Alamofire'
  pod 'Kanna'
  pod 'ReachabilitySwift'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'

end

catalyst_configuration do
  verbose!
  ios 'Firebase/Analytics'
end

# Pods for Casical

target 'CasicalTests' do
  inherit! :search_paths
  # Pods for testing
end

target 'CasicalUITests' do
  # Pods for testing
end


# Configure your macCatalyst App
post_install do |installer|
	installer.configure_catalyst
end












