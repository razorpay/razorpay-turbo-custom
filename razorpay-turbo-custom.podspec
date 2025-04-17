#
# Be sure to run `pod lib lint razorpay-turbo-pod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'razorpay-turbo-custom'
  s.version          = '2.0.3'
  s.summary          = "CocoaPod implementation of Razorpay's Turbo in-app UPI Payments"

  s.description      = <<-DESC
    Razorpay is a payments platform for e-commerce businesses in India. Razorpay
    helps businesses accepts online payments via Credit Card, Debit Card, Net banking
    and Wallets from their end customers. Razorpay provides a secure link between
    merchant website, various issuing institutions, acquiring Banks and the payment
    networks. Razorpay is a developer oriented payment gateway and focuses on
    essentials such as 24x7 support, one line integration code and checkout
    experiences that are very customer friendly.
                       DESC

  s.homepage         = 'https://github.com/razorpay/razorpay-turbo-custom'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ramprasadAnand' => 'ramprasad.a@razorpay.com' }
  s.source           = { :git => 'https://github.com/razorpay/razorpay-turbo-custom.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.subspec 'Core' do |core| 
    core.vendored_frameworks = [
      'Pod/core/CommonLibrary.framework',
      'Pod/core/Sentry.framework',
      'Pod/core/two_party.framework'
    ]
  end

  s.subspec 'headless' do |headless| 
    headless.vendored_frameworks = [
      'Pod/headless/RazorpayTurboUPI.framework',
      'Pod/headless/TurboUpiPlugin.framework'
    ]
    headless.dependency 'razorpay-turbo-custom/Core'
    headless.dependency 'razorpay-customui-pod'
  end

  s.subspec 'ui' do |ui| 
    ui.vendored_frameworks = [
      'Pod/ui/RazorpayTurboUPIUI.framework',
      'Pod/ui/TurboUpiPluginUI.framework'
    ]
    ui.dependency 'razorpay-turbo-custom/Core'
    ui.dependency 'razorpay-customui-pod'
  end
end
