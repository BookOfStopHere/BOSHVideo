# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!!

source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'
#inhibit_all_warnings!

target 'BOSHVideo' do
	pod 'SVProgressHUD'
	pod 'SDWebImage', '3.7.6'
end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end