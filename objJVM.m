#import <ObjFW/ObjFW.h>
#import "classFile.h"

@interface objJVM: OFObject <OFApplicationDelegate>
@end

OF_APPLICATION_DELEGATE(objJVM)

@implementation objJVM
- (void)applicationDidFinishLaunching
{
	ClassFile* cf = [ClassFile classFileWithPath: @"test.class"];
	[OFApplication terminate];
}
@end
