#
# Be sure to run `pod lib lint MKBeaconXTag.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKBeaconXTag'
  s.version          = '0.0.1'
  s.summary          = 'A short description of MKBeaconXTag.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/aadyx2007@163.com/MKBeaconXTag'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aadyx2007@163.com' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/aadyx2007@163.com/MKBeaconXTag.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  
  s.resource_bundles = {
    'MKBeaconXTag' => ['MKBeaconXTag/Assets/*.png']
  }
  
  s.subspec 'ConnectManager' do |ss|
    ss.source_files = 'MKBeaconXTag/Classes/ConnectManager/**'
    
    ss.dependency 'MKBeaconXTag/SDK'
    
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'CTMediator' do |ss|
    ss.source_files = 'MKBeaconXTag/Classes/CTMediator/**'
    
    ss.dependency 'MKBaseModuleLibrary'
    
    ss.dependency 'CTMediator'
  end
  
  s.subspec 'SDK' do |ss|
    ss.source_files = 'MKBeaconXTag/Classes/SDK/**'
    
    ss.dependency 'MKBaseBleModule'
  end
  
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKBeaconXTag/Classes/Target/**'
    
    ss.dependency 'MKBeaconXTag/Functions'
  end
  
  
  s.subspec 'Functions' do |ss|
    
    ss.subspec 'AboutPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/AboutPage/Controller/**'
      end
    end
    
    ss.subspec 'AccelerationPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/AccelerationPage/Controller/**'
      
        ssss.dependency 'MKBeaconXTag/Functions/AccelerationPage/Model'
        ssss.dependency 'MKBeaconXTag/Functions/AccelerationPage/View'
      
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/AccelerationPage/Model/**'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/AccelerationPage/View/**'
      end
    end
    
    ss.subspec 'DeviceInfoPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/DeviceInfoPage/Controller/**'
      
        ssss.dependency 'MKBeaconXTag/Functions/DeviceInfoPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/DeviceInfoPage/Model/**'
      end
    end
    
    ss.subspec 'HallSensorPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/HallSensorPage/Controller/**'
      
        ssss.dependency 'MKBeaconXTag/Functions/HallSensorPage/Model'
        ssss.dependency 'MKBeaconXTag/Functions/HallSensorPage/View'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/HallSensorPage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/HallSensorPage/View/**'
      end
    end
    
    ss.subspec 'QuickSwitchPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/QuickSwitchPage/Controller/**'
      
        ssss.dependency 'MKBeaconXTag/Functions/QuickSwitchPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/QuickSwitchPage/Model/**'
      end
    end
    
    ss.subspec 'ScanPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/ScanPage/Controller/**'
      
        ssss.dependency 'MKBeaconXTag/Functions/ScanPage/Model'
        ssss.dependency 'MKBeaconXTag/Functions/ScanPage/View'
        ssss.dependency 'MKBeaconXTag/Functions/ScanPage/Adopter'
        
        ssss.dependency 'MKBeaconXTag/Functions/TabBarPage/Controller'
        ssss.dependency 'MKBeaconXTag/Functions/AboutPage/Controller'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/ScanPage/View/**'
        
        ssss.dependency 'MKBeaconXTag/Functions/ScanPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/ScanPage/Model/**'
      end
      
      sss.subspec 'Adopter' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/ScanPage/Adopter/**'
        
        ssss.dependency 'MKBeaconXTag/Functions/ScanPage/Model'
        ssss.dependency 'MKBeaconXTag/Functions/ScanPage/View'
      end
    end
    
    ss.subspec 'SensorConfigPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/SensorConfigPage/Controller/**'
        
        ssss.dependency 'MKBeaconXTag/Functions/AccelerationPage/Controller'
        ssss.dependency 'MKBeaconXTag/Functions/HallSensorPage/Controller'
      end
    end
    
    ss.subspec 'SettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/SettingPage/Controller/**'
              
        ssss.dependency 'MKBeaconXTag/Functions/SensorConfigPage/Controller'
        ssss.dependency 'MKBeaconXTag/Functions/QuickSwitchPage/Controller'
        ssss.dependency 'MKBeaconXTag/Functions/UpdatePage/Controller'
      end
    end
    
    ss.subspec 'SlotConfigPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/SlotConfigPage/Controller/**'
      
        ssss.dependency 'MKBeaconXTag/Functions/SlotConfigPage/Model'
        ssss.dependency 'MKBeaconXTag/Functions/SlotConfigPage/View'
        ssss.dependency 'MKBeaconXTag/Functions/SlotConfigPage/Adopter'
        ssss.dependency 'MKBeaconXTag/Functions/SlotConfigPage/Defines'
        
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/SlotConfigPage/View/**'
        
        ssss.dependency 'MKBeaconXTag/Functions/SlotConfigPage/Adopter'
        ssss.dependency 'MKBeaconXTag/Functions/SlotConfigPage/Defines'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/SlotConfigPage/Model/**'
        
        ssss.dependency 'MKBeaconXTag/Functions/SlotConfigPage/Defines'
      end
      
      sss.subspec 'Adopter' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/SlotConfigPage/Adopter/**'
      end
      sss.subspec 'Defines' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/SlotConfigPage/Defines/**'
      end
    end
    
    ss.subspec 'SlotPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/SlotPage/Controller/**'
      
        ssss.dependency 'MKBeaconXTag/Functions/SlotPage/Model'
        
        ssss.dependency 'MKBeaconXTag/Functions/SlotConfigPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/SlotPage/Model/**'
      end
    end
    
    ss.subspec 'TabBarPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/TabBarPage/Controller/**'
        
        ssss.dependency 'MKBeaconXTag/Functions/SlotPage/Controller'
        ssss.dependency 'MKBeaconXTag/Functions/SettingPage/Controller'
        ssss.dependency 'MKBeaconXTag/Functions/DeviceInfoPage/Controller'
      end
    end
    
    ss.subspec 'UpdatePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/UpdatePage/Controller/**'
      
        ssss.dependency 'MKBeaconXTag/Functions/UpdatePage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXTag/Classes/Functions/UpdatePage/Model/**'
      end
    end
    
    ss.dependency 'MKBeaconXTag/SDK'
    ss.dependency 'MKBeaconXTag/CTMediator'
    ss.dependency 'MKBeaconXTag/ConnectManager'
  
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
    ss.dependency 'MKBeaconXCustomUI'
    ss.dependency 'HHTransition'
    ss.dependency 'MLInputDodger'
    
  end
  
end
