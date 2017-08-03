#
# Be sure to run `pod lib lint DeckCollectionViewLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name                  = 'DeckCollectionViewLayout'
    s.version               = '1.0.0'
    s.summary               = 'Card stack layout for UICollectionView'
    s.description           = 'DeckCollectionViewLayout is another implementation of Tinder like cards for iOS.'
    s.homepage              = 'https://github.com/victor-pavlychko/DeckCollectionViewLayout'
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.author                = { 'Victor Pavlychko' => 'victor.pavlychko@gmail.com' }
    s.source                = { :git => 'https://github.com/victor-pavlychko/DeckCollectionViewLayout.git', :tag => s.version.to_s }
    s.social_media_url      = 'https://twitter.com/victorpavlychko'
    s.ios.deployment_target = '8.0'
    s.source_files          = 'DeckCollectionViewLayout/**/*'
end
