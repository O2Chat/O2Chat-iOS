#
# Be sure to run `pod lib lint O2Chat.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'O2Chat'
  s.version          = '0.2.9'
  s.summary          = 'Connect, Chat, and Cherish'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  "Discover a new way to stay connected with our feature-rich chat app. Whether you're catching up with old friends, making new connections, or collaborating with colleagues, our platform offers seamless messaging, file sharing, and group chat functionalities. Experience real-time conversations with lightning-fast performance, enhanced security, and a user-friendly interface designed to keep your interactions smooth and enjoyable. Connect, chat, and cherish every moment with us!"
  DESC

  s.homepage         = 'https://github.com/O2Chat/O2Chat-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'o2chat.io@gmail.com' => 'o2chat.io@gmail.com' }
  s.source           = { :git => 'https://github.com/O2Chat/O2Chat-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.platform = :ios, '13.0'

  
  #s.pod_target_xcconfig = {
  #'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  #}
  
  # Architecture exclusion and linker flags
    s.pod_target_xcconfig = {
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
      'OTHER_LDFLAGS' => '-ObjC'
    }
    s.user_target_xcconfig = {
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
    }
    
    
  
  
#  s.source_files = 'Classes/**/*.{swift,h,m}'
#  s.resources = 'Resources/**/*.{storyboard,xib,xcassets,png,jpeg,jpg,gif}'



  s.preserve_paths      = '**/O2ChatSDK.xcframework'
  s.vendored_frameworks = '**/O2ChatSDK.xcframework'
  
  s.frameworks = ['UIKit', 'Foundation', 'AVFoundation', 'AudioToolbox', 'CoreMedia', 'ImageIO', 'QuickLook', 'SystemConfiguration', 'Security', 'Photos', 'CoreServices', 'QuickLook', 'MobileCoreServices']
  
  s.static_framework = true
  
  s.subspec 'AlamofireSupport' do |sp|
    sp.dependency 'Alamofire', '>= 5.0', '< 6.0'
  end
  
  s.subspec 'SwiftyJSONSupport' do |sp|
    sp.dependency 'SwiftyJSON', '>= 5.0', '< 6.0'
  end
  
  s.subspec 'FMDBSupport' do |sp|
    sp.dependency 'FMDB', '>= 2.7', '< 3.0'
  end
  
  s.subspec 'SwiftSignalRClientSupport' do |sp|
    sp.dependency 'SwiftSignalRClient', '>= 0.8', '< 1.0'
  end
  
  s.subspec 'FirebaseCoreSupport' do |sp|
    sp.dependency 'Firebase/Core'
  end
  
  s.subspec 'FirebaseMessagingSupport' do |sp|
    sp.dependency 'Firebase/Messaging'
  end
  
  s.subspec 'CosmosSupport' do |sp|
    sp.dependency 'Cosmos', '>= 23.0', '< 24.0'
  end
  
#  s.ios.deployment_target = '10.0'
#
#  s.source_files = 'O2Chat/Classes/**/*'
  
  # s.resource_bundles = {
  #   'O2Chat' => ['O2Chat/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
