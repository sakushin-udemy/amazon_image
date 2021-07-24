#import "AmazonImagePlugin.h"
#if __has_include(<amazon_image/amazon_image-Swift.h>)
#import <amazon_image/amazon_image-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "amazon_image-Swift.h"
#endif

@implementation AmazonImagePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAmazonImagePlugin registerWithRegistrar:registrar];
}
@end
