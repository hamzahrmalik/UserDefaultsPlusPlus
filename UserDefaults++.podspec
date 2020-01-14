#
# Be sure to run `pod lib lint UserDefaults.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UserDefaults++'
  s.version          = '1.0.0'
  s.summary          = 'A wrapper around UserDefaults to make managing keys and their types easier'

  s.description      = <<-DESC
A wrapper around UserDefaults which allows you to specify keys in a type safe way and persist/retrieve values from a key with its type. Avoids having to repeat the key in multiple places in your project
                       DESC

  s.homepage         = 'https://github.com/hamzahrmalik/UserDefaultsPlusPlus'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hamzah Malik' => 'hamzahrmalik@yahoo.co.uk' }
  s.source           = { :git => 'https://github.com/hamzahrmalik/UserDefaultsPlusPlus.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'UserDefaultsPlusPlus/Classes/**/*'

  s.swift_version = "4.0"

end
