Pod::Spec.new do |s|
  s.name             = 'StretchyHeaderViewController'
  s.version          = '0.0.1'
  s.summary          = 'View controller with a customizable stretchy header in swift.'
 
  s.description      = <<-DESC
Customizable features:
    - Header title
    - Header subtitle
    - Header image
    - Minimum header height
    - Maximum header height
    - Tint color (title and subtitle color)
    - Title font
    - Subtitle font
    - Text shadow color
    - Text shadow offset
    - Text shadow radius
    - Text shadow opacity
    - ScrollView (can be standard UIScrollView, UITableView or UICollectionView)
    - Collapsing animation speed
    - Expanding animation speed

Other features:
    - "progress" variable returns a value between 0 and 1 depending on header progress between its min and max value.
    - expandHeader function to expand the header to its maximum height with specified animation speed.
    - collapseHeader function to collapse the header to its minimum height with specified animation speed.

Usage:
    1. Delcare StretchyHeaderViewController
    2. Customize its properties
    3. Assign a UIScrollView, UITableView or UICollectionView to "scrollView" variable
    4. Call updateHeader() function within viewDidScroll() of the presented scroll/table/collection view delegate.

                       DESC
 
  s.homepage         = 'https://github.com/FQuen/StretchyHeaderViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Frederic Quenneville' => 'fred.quenneville@gmail.com' }
  s.source           = { :git => 'https://github.com/FQuen/StretchyHeaderViewController.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '11.0'
  s.source_files = 'StretchyHeaderViewController/*'
 
end