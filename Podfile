platform :ios, '10.3'

target 'BackPortal' do
  use_frameworks!

  pod 'CMHealth', :git => 'git@github.com:cloudmine/CMHealthSDK-iOS.git', :branch => 'photo-share'
  pod 'CareKit', :git => 'git@github.com:cloudmine/CareKit.git', :branch => 'cm-patched-pull'
  pod 'CloudMine', :git => 'git@github.com:apbendi/cloudmine-ios.git', :branch => 'img-acl'

  pod 'TPKeyboardAvoiding', '~> 1.3'
  pod 'SwiftValidator', :git => 'git@github.com:jpotts18/SwiftValidator.git', :branch => 'swift3-dave'

  target 'BackPortalTests' do
    inherit! :search_paths
  end

  target 'BackPortalUITests' do
    inherit! :search_paths
  end
end
