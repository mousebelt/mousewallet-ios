# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

use_frameworks!
target 'NRLWallet' do
  # Pods for NRLWallet
  pod 'TagListView', '~> 1.0'
  pod 'SWRevealViewController', '~> 2.3'
  pod 'XLPagerTabStrip', '~> 8.0'
  pod 'DropDown'
  pod 'Toast-Swift', '~> 3.0.1'
  pod 'QRCode'
  pod 'TPKeyboardAvoiding', '~> 1.3'
  pod 'Alamofire'
  pod 'RNCryptor', '~> 5.0'
  post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
          config.build_settings.delete('CODE_SIGNING_ALLOWED')
          config.build_settings.delete('CODE_SIGNING_REQUIRED')
      end
  end
end
