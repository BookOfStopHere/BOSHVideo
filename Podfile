# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!!

source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'
#inhibit_all_warnings!

target 'BOSHVideo' do
#	pod 'SVProgressHUD'
	pod 'SDWebImage', '~> 3.7.6'
	pod 'GPUImage'
	pod 'MMDrawerController', '~> 0.5.7'
#	pod "MWPhotoBrowser"
	pod 'MBProgressHUD', '~> 1.0.0'
    pod 'FLAnimatedImage', '~> 1.0'
    pod 'Masonry'
    pod 'AFNetworking', '~> 3.0'
    pod 'YYModel'
#    pod 'FCAlertView'
    pod 'NYAlertViewController'
end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end
