# Uncomment this line to define a global platform for your project
# platform :ios, '6.0'

target 'Todos' do
end

target 'Specs' do
  pod 'Cedar'
end

target 'Features', exclusive: true do
  pod 'Cedar'
  pod 'KIF', '~> 3.0', configurations: %w(Debug)
end
