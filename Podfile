# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'SBC' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  pod 'Alamofire'
  pod 'IQKeyboardManagerSwift'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'FBSDKLoginKit'
  pod 'FBSDKCoreKit'
  pod 'SwiftKeychainWrapper'
  pod 'SwiftLint'
  pod 'JVFloatLabeledTextField'
  pod 'BRYXBanner'
  pod 'MSPeekCollectionViewDelegateImplementation'
  pod 'EasyTipView'
  pod 'SDWebImage'
  
  # Pods for SBC

  target 'SBCTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Cuckoo'
  end

  target 'SBCUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                  config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
            end
      end
  end

end
