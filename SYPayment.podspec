#
# Be sure to run `pod lib lint SYPayment.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SYPayment"
  s.version          = "0.1.0"
  s.summary          = "SYPayment."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "Integrate third-party payment SDKs like Alipay and WeChat payment."

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/SYPayment"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Yu Xulu" => "tonyfish@qq.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/SYPayment.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Plugins/Common/**/*'
  s.dependency 'Aspects'

  s.subspec "Alipay" do |sp|
    sp.source_files = 'Pod/Plugins/Alipay/**/*'
    sp.vendored_frameworks = 'Pod/Frameworks/Alipay/AlipaySDK.framework'
    sp.resource_bundles = {
      'Alipay' => ['Pod/Frameworks/Alipay/AlipaySDK.bundle']
    }
    sp.frameworks = 'CoreMotion','CoreTelephony','SystemConfiguration'
    sp.libraries = 'z','c++'
    sp.dependency 'OpenSSL'
  end

  s.subspec "WeChat" do |sp|
    sp.vendored_libraries = 'Pod/Frameworks/WeChat/libWeChatSDK.a'
    sp.source_files = 'Pod/Frameworks/WeChat/*.h','Pod/Plugins/WeChat/**/*'
    sp.frameworks = 'SystemConfiguration','CoreTelephony'
    sp.libraries = 'z','c++','sqlite3'
  end

end
