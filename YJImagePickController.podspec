
Pod::Spec.new do |s|
  s.name         = "YJImagePickController"
  s.version      = "0.0.1"
  s.summary      = "A simple image pick controller"
  s.description  = <<-DESC
                  私有图片选择器库
                  * Markdown 格式
                   DESC

  s.homepage     = "https://github.com/zhangYongJieQZ/YJImagePickController"
  s.license      = "MIT"
  s.author             = { "zhangYongJieQZ" => "1226499512@qq.com" }
  s.source       = { :git => "https://github.com/zhangYongJieQZ/YJImagePickController.git", :tag => "#{s.version}" }


  s.source_files  = "YJImagePickController/*.{h,m}"

  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  s.frameworks = 'UIKit','Foundation','Photos','AssetsLibrary'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true
  s.platform     = :ios, "7.0" 
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
