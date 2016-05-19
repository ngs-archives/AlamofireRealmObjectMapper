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
  s.version          = "0.0.1"
  s.summary          = "Alamofire ressponse handler for Realm objects with ObjectMapper"
  s.homepage         = "https://github.com/ngs/AlamofireRealmObjectMapper"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "ngs" => "a@ngs.io" }
  s.source           = { :git => "https://github.com/ngs/AlamofireRealmObjectMapper.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.dependency 'Alamofire', '~> 3.4'
  s.dependency 'ObjectMapper', '~> 1.3'
  s.dependency 'RealmSwift',   '>=0.99.1'

  s.source_files = 'AlamofireRealmObjectMapper/AlamofireRealmObjectMapper.swift'

end
