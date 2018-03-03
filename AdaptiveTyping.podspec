#
# Be sure to run `pod lib lint AdaptiveTyping.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'AdaptiveTyping'
  s.version          = '1.0.0'
  s.summary          = 'Easily adjust layouts to make room for the iOS Keyboard.'

  s.description      = <<-DESC
AdaptiveTyping provides a view controller, KeyboardSafeAreaController, which will automatically
adjust its safe area to account for any changes in the presenation of the iOS Keyboard.
                       DESC

  s.homepage         = 'https://github.com/altece/AdaptiveTyping'
  s.license          = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author           = { 'Steven Brunwasser' => '' }
  s.source           = { :git => 'https://github.com/altece/AdaptiveTyping.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'AdaptiveTyping/**/*.{h,m,swift}'
  s.frameworks = [ 'UIKit' ]
end
