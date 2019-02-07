#
# Be sure to run `pod lib lint ARMDevSuite.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ARMDevSuite'
  s.version          = '0.1.6'
  s.summary          = 'UI & Logic Pod containing many useful helpers and UI elements.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ARMDevSuite is a pod that contains many useful UIKit elements as well as useful logic libraries.
                       DESC

  s.homepage         = 'https://github.com/ajaymerchia/ARMDevSuite'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ajaymerchia' => 'ajaymerchia@berkeley.edu' }
  s.source           = { :git => 'https://github.com/ajaymerchia/ARMDevSuite.git', :tag => s.version.to_s }
  s.swift_version    = '4.2'
  
  s.ios.deployment_target = '12.1'

#  s.source_files = 'ARMDevSuite/Classes/LayoutManager/LayoutManager.swift', 'ARMDevSuite/Classes/LocalData/LocalDataManager.swift'

  # s.resource_bundles = {
  #   'ARMDevSuite' => ['ARMDevSuite/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.subspec 'LayoutManager' do |layout|
    layout.source_files = 'ARMDevSuite/Classes/LayoutManager/LayoutManager.swift'
  end
  
  s.subspec 'LocalData' do |localdata|
    localdata.source_files = 'ARMDevSuite/Classes/LocalData/LocalDataManager.swift'
  end
  
  
  
  
end
