Pod::Spec.new do |s|

  s.name         = "ADMusicPlayerBanner"
  s.version      = "1.0.1"
  s.summary      = "This music player component gives a banner view for play, pause, previous, next and cancel options."

  s.description  = "This music player component gives a banner view for play, pause, previous, next and cancel options. It also gives an enlarging and collapsing effect."

  s.homepage     = "https://github.com/AnirudhDas/ADMusicPlayerBanner.git"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Aniruddha Das" => "cse.anirudh@gmail.com" }

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/AnirudhDas/ADMusicPlayerBanner.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Classes/**/*.{swift}"

  # s.resources = "Classes/**/*.{png,xib}"

  s.frameworks    =  "Foundation", "UIKit", "MediaPlayer", "AVFoundation"

  s.requires_arc = true

  s.dependency      'MarqueeLabel'
  s.dependency      'SDWebImage'
  s.dependency      'Gloss'

end