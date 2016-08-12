#
# Be sure to run `pod lib lint SwiftyDraft.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name         = "AlamofireRealmObjectMapper"
  s.summary      = "Alamofire ressponse handler for Realm objects with ObjectMapper"
  s.version      = "0.0.1"
  s.authors      = { "ngs" => "a@ngs.io" }
  s.description  = "AlamofireRealmObjectMapper"
  s.homepage     = "https://github.com/ngs/AlamofireRealmObjectMapperr"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ngs/AlamofireRealmObjectMapper.git" }
  s.source_files  = "AlamofireRealmObjectMapper/*.{swift}"
  s.requires_arc = true
  
  s.dependency "RealmSwift", "~>1.0.0"
  s.dependency "ObjectMapper", "~>1.3.0"
  s.dependency "Alamofire", "~>3.4.0"

end
