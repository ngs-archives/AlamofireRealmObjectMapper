#
# Be sure to run `pod lib lint SwiftyDraft.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "AlamofireRealmObjectMapper"
  s.version          = "0.0.2"
  s.summary          = "Alamofire ressponse handler for Realm objects with ObjectMapper"
  s.homepage         = "https://github.com/ngs/AlamofireRealmObjectMapper"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "ngs" => "a@ngs.io" }
  s.source           = { :git => "https://github.com/ngs/AlamofireRealmObjectMapper.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.dependency 'Alamofire', '~> 4.2'
  s.dependency 'ObjectMapper', '~> 2.2'
  s.dependency 'RealmSwift',   '~> 2.1'

  s.source_files = 'AlamofireRealmObjectMapper/AlamofireRealmObjectMapper.swift'

end
