Pod::Spec.new do |s|
  s.name         = "ZTModalShow"
  s.version      = "0.0.1"
  s.summary      = "A library to modal show a custom view with a simple way ！"
  s.description  = "A library to modal show a custom view with a simple way ！！！"
  s.homepage     = "https://github.com/YQ-Seventeen/ZTModalShow.git"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "yq-seventeen" => "yl616775291@163.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/YQ-Seventeen/ZTModalShow.git", :tag => "#{s.version}" }
  s.source_files  = 'ZTModalShow', 'ZTModalShow/**/*.{h,m}'
  s.framework = 'UIKit', 'Foundation'
  s.requires_arc = true
end
