platform :ios, '8.0'
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
        config.build_settings['DYLIB_COMPATIBILITY_VERSION'] = ''
    end
  end
end
pod 'Alamofire', '~> 3.0'
pod 'Kingfisher', '~> 1.6’
#pod 'GTScrollNavigationBar'
pod 'youtube-ios-player-helper', :path => 'SocialMediaChannel/youtube-ios-player-helper.podspec'
pod 'SVPullToRefresh'
pod 'SVProgressHUD'
#pod 'ReachabilitySwift', git: 'https://github.com/ashleymills/Reachability.swift'
#pod 'iDate'
pod 'TLYShyNavBar'
use_frameworks!