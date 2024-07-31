#
# Be sure to run `pod lib lint O2Chat.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'O2Chat'
  s.version          = '0.1.0'
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
  s.author           = { 'sanjay.khatri02@outlook.com' => 'sanjay.khatri02@outlook.com' }
  s.source           = { :git => 'https://github.com/O2Chat/O2Chat-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
  
  
  s.source_files = 'Classes/**/*.{swift,h,m}'
  s.resources = 'Resources/**/*.{storyboard,xib,xcassets,png,jpeg,jpg,gif}'
  
  
  s.frameworks = ['UIKit', 'Foundation', 'QuickLook', 'Photos', 'MobileCoreServices']
  
  s.dependency 'Alamofire', '>= 5.8.1', '< 6.0'
  s.dependency 'SwiftyJSON'
  s.dependency 'FMDB'
  s.dependency 'SwiftSignalRClient'
  s.dependency 'IQKeyboardManager'
  s.dependency 'Firebase/Core'
  s.dependency 'Firebase/Messaging'
  s.dependency 'Kingfisher'
  
  s.dependency 'Cosmos'
  
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
