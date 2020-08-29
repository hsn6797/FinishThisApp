# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'FinishThisApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FinishThisApp
   pod 'FBSDKCoreKit','~> 4.19.0'
   pod 'FBSDKShareKit','~> 4.19.0'
   pod 'FBSDKLoginKit','~> 4.19.0'
  pod 'Firebase/Auth','~> 5.17.0'
  pod 'Firebase/Analytics','~> 5.17.0'
  pod 'Firebase/Firestore','~> 5.17.0'
  pod 'Firebase/Storage','~> 5.17.0'
  pod 'SVProgressHUD'
  pod 'ChameleonFramework'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
    end
  end
end

