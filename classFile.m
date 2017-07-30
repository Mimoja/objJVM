#import "classFile.h"

@implementation AttributeInfo
@end

@implementation MethodInfo
@end

@implementation FieldInfo
@end

@implementation ConstantpoolInfo
@end


@implementation ClassFile
+ (instancetype) classFileWithPath: (OFString *)path
{
    return [[[self alloc] initWithPath: path] autorelease];
}

- initWithPath: (OFString *)path
{
    [super init];
    OFFile *f = [OFFile fileWithPath: path mode: @"r"];
    magic = [f readBigEndianInt32];
    if(magic != 0xCAFEBABE){
        [of_stderr writeLine: @"magic is broken"];
        [of_stderr writeFormat: @"0x%X\n", magic];
    }
    minor_version = [f readBigEndianInt16];
    major_version = [f readBigEndianInt16];
    constant_pool_count = [f readBigEndianInt16];
    [constant_pool initWithCapacity: constant_pool_count-1];
    for(int i = 0; i < constant_pool_count; i++){
        ConstantpoolInfo* cp = [ConstantpoolInfo alloc];
        cp->tag = [f readBigEndianInt32];
        switch(cp->tag){
            case CONSTANT_Class:
                cp->info.classInfo.name_index = [f readBigEndianInt16];
                break;
            case CONSTANT_Fieldref:
                cp->info.fieldRefInfo.class_index = [f readBigEndianInt16];
                cp->info.fieldRefInfo.name_and_type_index = [f readBigEndianInt16];
                break;
            case CONSTANT_Methodref:
                cp->info.methodRefInfo.class_index = [f readBigEndianInt16];
                cp->info.methodRefInfo.name_and_type_index = [f readBigEndianInt16];
                break;
            case CONSTANT_InterfaceMethodref:
                cp->info.interfaceMethodRefInfo.class_index = [f readBigEndianInt16];
                cp->info.interfaceMethodRefInfo.name_and_type_index = [f readBigEndianInt16];
                break;
            case CONSTANT_String :
                cp->info.stringInfo.string_index = [f readBigEndianInt16];
                break;
            case CONSTANT_Integer :
                cp->info.integerInfo.bytes = (int32_t) [f readBigEndianInt32];
                break;
            case CONSTANT_Float :
                cp->info.floatInfo.bytes = [f readBigEndianFloat];
                break;
            case CONSTANT_Long :
                cp->info.longInfo.bytes = (int64_t) [f readBigEndianInt64];
                i++;
                break;
            case CONSTANT_Double:
                cp->info.doubleInfo.bytes = [f readBigEndianDouble];
                i++;
                break;
            case CONSTANT_NameAndType:
                cp->info.nameAndTypeInfo.name_index = [f readBigEndianInt16];
                cp->info.nameAndTypeInfo.descriptor_index = [f readBigEndianInt16];
                break;
            case CONSTANT_Utf8:
                //TODO Parse broken JAVA utf8!
                cp->info.utf8Info.length = [f readBigEndianInt16];
                cp->info.utf8Info.value = [f readStringWithLength: cp->info.utf8Info.length 
                encoding: OF_STRING_ENCODING_UTF_8 ];
                break;
            case CONSTANT_MethodHandle:
                cp->info.methodHandleInfo.reference_kind = [f readBigEndianInt16];
                cp->info.methodHandleInfo.reference_index = [f readBigEndianInt16];
                break;
            case CONSTANT_MethodType:
                cp->info.methodTypeInfo.descriptor_index = [f readBigEndianInt16];
                break;
            case CONSTANT_InvokeDynamic:
                cp->info.invokeDynamicInfo.bootstrap_method_attr_index = [f readBigEndianInt16];
                cp->info.invokeDynamicInfo.name_and_type_index = [f readBigEndianInt16];
                break;

        }
        constant_pool[i] = cp;
    }
    access_flags = [f readBigEndianInt16];
    this_class = [f readBigEndianInt16];
    super_class = [f readBigEndianInt16];
    interfaces_count = [f readBigEndianInt16];
    fields_count = [f readBigEndianInt16];
    fields = [[OFMutableArray alloc] initWithCapacity: fields_count];
    for(int i = 0; i < fields_count; i++){
        FieldInfo* fi = [[FieldInfo alloc] init];
        fi->access_flags = [f readBigEndianInt16];
        fi->name_index = [f readBigEndianInt16];
        fi->descriptor_index = [f readBigEndianInt16];
        fi->attributes_count = [f readBigEndianInt16];
        fi->attributes = [[OFMutableArray alloc] initWithCapacity: fi->attributes_count];
        for(int i = 0; i < fi->attributes_count; i++)
        {
            AttributeInfo* attr = [[AttributeInfo alloc] init];
            attr->name_index = [f readBigEndianInt16];
            attr->length = [f readBigEndianInt32];
            attr->info = [f readDataWithCount: attr->length];
            fi->attributes[i] = attr;
        }
    }
    methods_count = [f readBigEndianInt16];
    methods = [[OFMutableArray alloc] initWithCapacity: methods_count];
    for(int i = 0; i < methods_count; i++){
        MethodInfo* mi = [[MethodInfo alloc] init];
        mi->access_flags = [f readBigEndianInt16];
        mi->name_index = [f readBigEndianInt16];
        mi->descriptor_index = [f readBigEndianInt16];
        mi->attributes_count = [f readBigEndianInt16];
        mi->attributes = [[OFMutableArray alloc] initWithCapacity: mi->attributes_count];
        for(int i = 0; i < mi->attributes_count; i++)
        {
            AttributeInfo* attr = [[AttributeInfo alloc] init];
            attr->name_index = [f readBigEndianInt16];
            attr->length = [f readBigEndianInt32];
            attr->info = [f readDataWithCount: attr->length];
            mi->attributes[i] = attr;
        }
    }
    attributes_count = [f readBigEndianInt16];
    attributes = [[OFMutableArray alloc] initWithCapacity: attributes_count];
    for(int i = 0; i < attributes_count; i++)
	{
		AttributeInfo* attr = [[AttributeInfo alloc] init];
		attr->name_index = [f readBigEndianInt16];
		attr->length = [f readBigEndianInt32];
		attr->info = [f readDataWithCount: attr->length];
        attributes[i] = attr;
	}
    return self;
}
@end    