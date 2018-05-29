# restless-wallet-ios
Restless iOS Wallet

## Installation

### via CocoaPods

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```
* Podfile

``` bash
platform :ios, '9.0'

use_frameworks!
target 'NRLWallet' do
  # Pods for NRLWallet
  pod 'TagListView', '~> 1.0'
  pod 'SWRevealViewController', '~> 2.3'
  
end

```

Change to the directory of your Xcode project

``` bash
$ pod install

```

* Open XCode project

>Double click the 'NRLWallet.xcworkspace' file

* Run project
