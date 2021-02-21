#
# Be sure to run `pod lib lint SQDifferenceKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.name = "SQDifferenceKit"
    s.summary = "Base data to implementig as UITableCell/UICollectionView\'s data."
    s.requires_arc = true

    s.version = "0.2.2"
    s.license  = { :type => "MIT", :file => "LICENSE" }
    s.author   = { 'lab-devoloper' => 'ivan.michaylovsky@sequenia.com' }
    s.homepage         = "https://github.com/sequenia/SQDifferenceKit"
    s.source           = { :git => 'https://github.com/sequenia/SQDifferenceKit.git', 
                           :tag => "#{s.version}" }

    s.framework = "UIKit"
    s.dependency 'DifferenceKit', '~> 1.1.5'
    s.swift_version = "4.2"

    s.source_files = "Sources/**/*.{swift}"

end


