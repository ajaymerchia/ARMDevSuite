#
# Be sure to run `pod lib lint ARMDevSuite.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ARMDevSuite'
  s.version          = '0.1.76'
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
  s.swift_version    = '5.0'

  s.ios.deployment_target = '11.0'

	
	# Base
  s.subspec 'Layouts' do |layout|
    layout.source_files = 'ARMDevSuite/Classes/LayoutManager/*.swift'
		layout.dependency 'ARMDevSuite/Logic'
  end
  
  s.subspec 'LocalData' do |localdata|
    localdata.source_files = 'ARMDevSuite/Classes/LocalData/LocalDataManager.swift'
		localdata.dependency 'ARMDevSuite/Logic'
  end
	
	s.subspec 'Logic' do |logic|
    logic.source_files = 'ARMDevSuite/Classes/LogicSuite/*.swift'
    logic.dependency 'CryptoSwift'
  end
	
	s.subspec 'UISuite' do |ui|
    ui.source_files = 'ARMDevSuite/Classes/UISuite/*.swift'
    ui.dependency 'ARMDevSuite/Layouts'
		ui.dependency 'ARMDevSuite/Logic'
  end
	
	
  #  Begin UI Components
	
  
  s.subspec 'Alerts' do |alerts|
    alerts.source_files = 'ARMDevSuite/Classes/AlertManager/AlertManager.swift'
		alerts.dependency 'ARMDevSuite/Logic'
    alerts.dependency 'JGProgressHUD'
    alerts.dependency 'ARMDevSuite/ProgressHud'
  end

  s.subspec 'SegControl' do |seg|
    seg.source_files = 'ARMDevSuite/Classes/SegControl/*.swift'
    seg.dependency 'ARMDevSuite/Layouts'
    seg.dependency 'ARMDevSuite/UISuite'
		seg.dependency 'ARMDevSuite/Logic'
  end
  
  s.subspec 'SlideView' do |slideview|
    slideview.source_files = 'ARMDevSuite/Classes/SlideView/*.swift'
    slideview.dependency 'ARMDevSuite/Layouts'
    slideview.dependency 'ARMDevSuite/UISuite'
		slideview.dependency 'ARMDevSuite/Logic'
  end
  
  s.subspec 'TextField' do |textfield|
    textfield.source_files = 'ARMDevSuite/Classes/Textfield/*.swift'
    textfield.dependency 'SkyFloatingLabelTextField', '~> 3.0'
    textfield.dependency 'ARMDevSuite/UISuite'
		textfield.dependency 'ARMDevSuite/Logic'
  end
  
  s.subspec 'MultipleImagePicker' do |multipicker|
    multipicker.source_files = 'ARMDevSuite/Classes/MultipleImagePicker/*.swift'
    multipicker.resource_bundles = {
      'MultipleImagePickerBundle' => ['ARMDevSuite/Assets/MultipleImagePicker/*.png']
    }
    multipicker.dependency 'DKImagePickerController'
    multipicker.dependency 'ARMDevSuite/UISuite'
    multipicker.dependency 'ARMDevSuite/Logic'
  end
  
  s.subspec 'PhotoPicker' do |photopicker|
    photopicker.source_files = 'ARMDevSuite/Classes/PhotoPicker/*.swift'
    photopicker.resource_bundles = {
      'PhotoPickerBundle' => ['ARMDevSuite/Assets/PhotoPicker/*.png']
    }
    photopicker.dependency 'DKImagePickerController'
    photopicker.dependency 'ARMDevSuite/UISuite'
    photopicker.dependency 'ARMDevSuite/Alerts'
    photopicker.dependency 'ARMDevSuite/Layouts'
		photopicker.dependency 'ARMDevSuite/Logic'
  end
  
  s.subspec 'ProgressHud' do |progresshud|
    progresshud.source_files = 'ARMDevSuite/Classes/ProgressHud/*.swift'
    progresshud.resource_bundles = {
      'ProgressHudBundle' => ['ARMDevSuite/Assets/ProgressHud/*.png']
    }
    progresshud.dependency 'ARMDevSuite/UISuite'
    progresshud.dependency 'ARMDevSuite/Layouts'
		progresshud.dependency 'ARMDevSuite/Logic'
  end

  s.subspec 'Calendar' do |calendar|
    calendar.source_files = 'ARMDevSuite/Classes/Calendar/*.swift'
		calendar.dependency 'ARMDevSuite/,'
  end
  

  
  
end
