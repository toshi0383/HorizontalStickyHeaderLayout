Pod::Spec.new do |s|
  s.name             = 'HorizontalStickyHeaderLayout'
  s.version          = '0.2.0'
  s.summary          = 'Horizontal UICollectionViewLayout with Sticky HeaderView'
  s.description      = <<-DESC
        'Horizontal UICollectionViewLayout with Sticky HeaderView'
                       DESC
  s.homepage         = 'https://github.com/toshi0383/HorizontalStickyHeaderLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'toshi0383' => 't.suzuki326@gmail.com' }
  s.source           = { :git => 'https://github.com/toshi0383/HorizontalStickyHeaderLayout.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/toshi0383'

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'HorizontalStickyHeaderLayout/*.swift'
end
