Pod::Spec.new do |s|
  s.name         = "MaterialMotionPopFamily"
  s.summary      = "POP Material Motion Family in Swift"
  s.version      = "1.0.0"
  s.authors      = "The Material Motion Authors"
  s.license      = "Apache 2.0"
  s.homepage     = "https://github.com/material-motion/material-motion-family-pop-swift"
  s.source       = { :git => "https://github.com/material-motion/material-motion-family-pop-swift.git", :tag => "v" + s.version.to_s }
  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.source_files = "src/*.{swift}", "src/private/*.{swift}"

  s.dependency "pop", "~> 1.0"
  s.dependency "MaterialMotionRuntime", ">= 4.0", "< 6.0"
end
