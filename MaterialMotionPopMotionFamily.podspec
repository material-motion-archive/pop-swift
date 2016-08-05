Pod::Spec.new do |s|
  s.name         = "MaterialMotionPopMotionFamily"
  s.summary      = "Material Motion Family Pop Swift"
  s.version      = "1.0.0"
  s.authors      = "The Material Motion Authors"
  s.license      = "Apache 2.0"
  s.homepage     = "https://github.com/material-motion/material-motion-family-pop-swift"
  s.source       = { :path => "./" }
  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.source_files = "src/*.{swift}", "src/private/*.{swift}"
end
