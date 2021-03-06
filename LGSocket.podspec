#
# Be sure to run `pod lib lint LGSocket.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LGSocket'
  s.version          = '1.0.1'
  s.summary          = '兴哥的Socket.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
"基于ysocket、SwiftProtobuf的封装，实现的即时通讯工具类。"
                       DESC

  s.homepage         = 'https://github.com/lizhixingios/LGSocket'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lizhixingios' => '740157759@qq.com' }
  s.source           = { :git => 'https://github.com/lizhixingios/LGSocket.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LGSocket/**/*'
  
  # s.resource_bundles = {
  #   'LGSocket' => ['LGSocket/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SwiftProtobuf', '~> 1.0.2'
end
