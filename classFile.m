#import "classFile.h"

@implementation MethodInfo @end
@implementation FieldInfo @end
@implementation ConstantpoolInfo @end
@implementation ExceptionTable @end

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
    [of_stdout writeFormat: @"Magic %08X\n", magic];
    minor_version = [f readBigEndianInt16];
    major_version = [f readBigEndianInt16];
    [of_stdout writeFormat: @"Version %d.%d\n", major_version, minor_version];
    constant_pool_count = [f readBigEndianInt16];
    [of_stdout writeFormat: @"Constantpool: %d entries\n", constant_pool_count];
    [constant_pool initWithCapacity: constant_pool_count-1];
    for(int i = 1; i < constant_pool_count; i++){
        [of_stdout writeFormat: @"\t[%02d]: ", i];
        ConstantpoolInfo* cp = [ConstantpoolInfo alloc];
        cp->tag = [f readInt8];
        switch(cp->tag){
            case CONSTANT_Class:
                cp->info.classInfo.name_index = [f readBigEndianInt16];
                [of_stdout writeFormat:@"Class: "];
                [of_stdout writeFormat:@"name_index: %d", cp->info.classInfo.name_index];
                break;
            case CONSTANT_Fieldref:
                cp->info.fieldRefInfo.class_index = [f readBigEndianInt16];
                cp->info.fieldRefInfo.name_and_type_index = [f readBigEndianInt16];
                [of_stdout writeFormat:@"FieldRef: "];
                [of_stdout writeFormat:@"class_index: %d\t", cp->info.fieldRefInfo.class_index];
                [of_stdout writeFormat:@"name_and_type_index: %d", cp->info.fieldRefInfo.name_and_type_index];
                break;
            case CONSTANT_Methodref:
                cp->info.methodRefInfo.class_index = [f readBigEndianInt16];
                cp->info.methodRefInfo.name_and_type_index = [f readBigEndianInt16];
                [of_stdout writeFormat:@"MethodRef: "];
                [of_stdout writeFormat:@"class_index: %d\t", cp->info.methodRefInfo.class_index];
                [of_stdout writeFormat:@"name_and_type_index: %d", cp->info.methodRefInfo.name_and_type_index];
                break;
            case CONSTANT_InterfaceMethodref:
                cp->info.interfaceMethodRefInfo.class_index = [f readBigEndianInt16];
                cp->info.interfaceMethodRefInfo.name_and_type_index = [f readBigEndianInt16];
                [of_stdout writeFormat:@"InterfaceMethod: "];
                [of_stdout writeFormat:@"class_index: %d\t", cp->info.interfaceMethodRefInfo.class_index];
                [of_stdout writeFormat:@"name_and_type_index: %d", cp->info.interfaceMethodRefInfo.name_and_type_index];
                break;
            case CONSTANT_String :
                cp->info.stringInfo.string_index = [f readBigEndianInt16];
                [of_stdout writeFormat:@"String: "];
                [of_stdout writeFormat:@"string_index: %d", cp->info.stringInfo.string_index];
                break;
            case CONSTANT_Integer :
                cp->info.integerInfo.bytes = (int32_t) [f readBigEndianInt32];
                [of_stdout writeFormat:@"Integer: "];
                [of_stdout writeFormat:@"%d", cp->info.integerInfo.bytes];
                break;
            case CONSTANT_Float :
                cp->info.floatInfo.bytes = [f readBigEndianFloat];
                [of_stdout writeFormat:@"Float: "];
                [of_stdout writeFormat:@"%f", cp->info.floatInfo.bytes];
                break;
            case CONSTANT_Long :
                cp->info.longInfo.bytes = (int64_t) [f readBigEndianInt64];
                [of_stdout writeFormat:@"Long: "];
                [of_stdout writeFormat:@"%d", cp->info.integerInfo.bytes];
                i++;
                break;
            case CONSTANT_Double:
                cp->info.doubleInfo.bytes = [f readBigEndianDouble];
                [of_stdout writeFormat:@"Double: "];
                [of_stdout writeFormat:@"%f", cp->info.floatInfo.bytes];
                i++;
                break;
            case CONSTANT_NameAndType:
                cp->info.nameAndTypeInfo.name_index = [f readBigEndianInt16];
                cp->info.nameAndTypeInfo.descriptor_index = [f readBigEndianInt16];
                [of_stdout writeFormat:@"NameAndType: "];
                [of_stdout writeFormat:@"name_index: %d\t", cp->info.nameAndTypeInfo.name_index];
                [of_stdout writeFormat:@"descriptor_index: %d", cp->info.nameAndTypeInfo.descriptor_index];
                break;
            case CONSTANT_Utf8:
                //TODO Parse broken JAVA utf8!
                cp->info.utf8Info.length = [f readBigEndianInt16];
                cp->info.utf8Info.value = [f readStringWithLength: cp->info.utf8Info.length
                                                         encoding: OF_STRING_ENCODING_UTF_8 ];

                [of_stdout writeFormat:@"UTF8: "];
                [of_stdout writeString: cp->info.utf8Info.value];
                break;
            case CONSTANT_MethodHandle:
                cp->info.methodHandleInfo.reference_kind = [f readBigEndianInt16];
                cp->info.methodHandleInfo.reference_index = [f readBigEndianInt16];
                [of_stdout writeFormat:@"MethodHandle: "];
                [of_stdout writeFormat:@"reference_kind: %d\t", cp->info.methodHandleInfo.reference_kind];
                [of_stdout writeFormat:@"reference_index: %d", cp->info.methodHandleInfo.reference_index];
                break;
            case CONSTANT_MethodType:
                cp->info.methodTypeInfo.descriptor_index = [f readBigEndianInt16];
                [of_stdout writeFormat:@"MethodType: "];
                [of_stdout writeFormat:@"descriptor_index: %d", cp->info.methodTypeInfo.descriptor_index];
                break;
            case CONSTANT_InvokeDynamic:
                cp->info.invokeDynamicInfo.bootstrap_method_attr_index = [f readBigEndianInt16];
                cp->info.invokeDynamicInfo.name_and_type_index = [f readBigEndianInt16];
                [of_stdout writeFormat:@"InvokeDynamic: "];
                [of_stdout writeFormat:@"bootstrap_method_attr_index: %d\t", cp->info.invokeDynamicInfo.bootstrap_method_attr_index];
                [of_stdout writeFormat:@"name_and_type_index: %d", cp->info.invokeDynamicInfo.name_and_type_index];
                break;
        }
        [of_stdout writeFormat: @"\n"];
        constant_pool[i] = cp;
    }
    access_flags = [f readBigEndianInt16];
    [of_stdout writeFormat: @"AccessFlags: 0x%X\n", access_flags];
    this_class = [f readBigEndianInt16];
    [of_stdout writeFormat: @"This: const[%d]\n", this_class];
    super_class = [f readBigEndianInt16];
    [of_stdout writeFormat: @"Super: const[%d]\n", super_class];
    interfaces_count = [f readBigEndianInt16];
    [of_stdout writeFormat: @"Interfaces: %d entries\n", interfaces_count];
    interfaces = [f readDataWithItemSize: 2 count: interfaces_count];
    fields_count = [f readBigEndianInt16];
    [of_stdout writeFormat: @"Fields: %d entries\n", fields_count];
    fields = [[OFMutableArray alloc] initWithCapacity: fields_count];
    for(int i = 0; i < fields_count; i++){
        [of_stdout writeFormat: @"\t[%d]: ", i];
        FieldInfo* fi = [[FieldInfo alloc] init];
        fi->access_flags = [f readBigEndianInt16];
        fi->name_index = [f readBigEndianInt16];
        fi->descriptor_index = [f readBigEndianInt16];
        fi->attributes_count = [f readBigEndianInt16];

        [of_stdout writeFormat: @"\t[%d]: "
            "access_flags: %x\t"
            "name_index: %d\t"
            "descriptor_index: %d\t"
            "attributes_count: %d\n",
            i,
            fi->access_flags,
            fi->name_index,
            fi->descriptor_index,
            fi->attributes_count];
        [of_stdout writeFormat: @"\tAttributes: %d entries\n", fi->attributes_count];
        fi->attributes = [[OFMutableArray alloc] initWithCapacity: fi->attributes_count];
        for(int j = 0; j < fi->attributes_count; j++)
        {
            AttributeInfo* attr = [[AttributeInfo alloc] initWithStream: f];
            [of_stdout writeFormat: @"\t\t[%d]: name_index: %d\t"
                                                    "length: %d\n", 
                                                    j, 
                                                    attr->name_index, 
                                                    attr->length];
            [fi->attributes insertObject: attr atIndex: j];
        }
    }
    methods_count = [f readBigEndianInt16];
    [of_stdout writeFormat: @"Methods: %d entries\n", methods_count];
    methods = [[OFMutableArray alloc] initWithCapacity: methods_count];
    for(int i = 0; i < methods_count; i++){
        MethodInfo* mi = [[MethodInfo alloc] init];
        mi->access_flags = [f readBigEndianInt16];
        mi->name_index = [f readBigEndianInt16];
        mi->descriptor_index = [f readBigEndianInt16];
        mi->attributes_count = [f readBigEndianInt16];
        [of_stdout writeFormat: @"\t[%d]: "
            "access_flags: %x\t"
            "name_index: %d\t"
            "descriptor_index: %d\t"
            "attributes_count: %d\n",
            i,
            mi->access_flags,
            mi->name_index,
            mi->descriptor_index,
            mi->attributes_count];
        [of_stdout writeFormat: @"\tAttributes: %d entries\n", mi->attributes_count];
        mi->attributes = [[OFMutableArray alloc] initWithCapacity: mi->attributes_count];
        for(int j = 0; j < mi->attributes_count; j++)
        {
            AttributeInfo* attr = [[AttributeInfo alloc] initWithStream: f];
            [of_stdout writeFormat: @"\t\t[%d]: name_index: %d\tlength: %d\n", j, attr->name_index, attr->length];
            if(attr->name_index == 21   )
                [CodeAttribute attributeWithInfo:attr->info];
            [mi->attributes insertObject: attr atIndex: j];
        }
    }
    attributes_count = [f readBigEndianInt16];
    [of_stdout writeFormat: @"Attributes: %d entries\n", attributes_count];
    attributes = [[OFMutableArray alloc] initWithCapacity: attributes_count];
    for(int i = 0; i < attributes_count; i++)
	{
		AttributeInfo* attr = [[AttributeInfo alloc] initWithStream: f];
        [of_stdout writeFormat: @"\t[%d]: name_index: %d\t"
                                            "length: %d\n", 
                                            i, 
                                            attr->name_index, 
                                            attr->length];
        [attributes insertObject: attr atIndex: i];
	}
    return self;
}
@end    

@implementation AttributeInfo

+ (instancetype) attributeWithStream: (OFStream *)stream
{
    return [[[self alloc] initWithStream: stream] autorelease];
}

- initWithStream: (OFStream *)stream
{
    self = [super init];
    name_index = [stream readBigEndianInt16];
	length = [stream readBigEndianInt32];
    info = [stream readDataWithCount: length];
    return self;
}
@end

uint16_t dataToUint16(OFData* data, ssize_t* index){
    uint16_t res = *((uint8_t*)[data itemAtIndex: *index+0]) << 8 
                 | *((uint8_t*)[data itemAtIndex: *index+1]) << 0;
    *index += 2;
    OF_BSWAP16_IF_LE(res);
    return res;
}

uint32_t dataToUint32(OFData* data, ssize_t* index){
    uint16_t res = *((uint8_t*)[data itemAtIndex: *index+0]) << 24 
                 | *((uint8_t*)[data itemAtIndex: *index+1]) << 16
                 | *((uint8_t*)[data itemAtIndex: *index+2]) << 8
                 | *((uint8_t*)[data itemAtIndex: *index+3]) << 0;
    *index += 4;
    OF_BSWAP32_IF_LE(res);
    return res;
}

OFData* dataToData(OFData* org, ssize_t* index, ssize_t count){
    uint8_t* items =(uint8_t*) [org items];
    uint8_t* new = &items[*index];
    OFData* ret = [[OFData alloc] initWithItems:new count:count];
    *index += count;
    return ret;
}

@implementation CodeAttribute
+ (instancetype) attributeWithInfo:(OFData *) info{
    return [[[self alloc] initWithInfo: info] autorelease];
}
- initWithInfo: (OFData *) info{
    self = [super init];
    ssize_t index = 0;
    max_stack = dataToUint16(info, &index);
    [of_stdout writeFormat:@"\t\t\tMaxStack: %d\n", max_stack];
    max_locals = dataToUint16(info, &index);
    [of_stdout writeFormat:@"\t\t\tMaxLocals: %d\n", max_locals];
    code_length = dataToUint32(info, &index);
    [of_stdout writeFormat:@"\t\t\tCodeLength: %d\n", code_length];
    code =  dataToData(info, &index, code_length);
    exception_table_length = dataToUint16(info, &index);
    [of_stdout writeFormat: @"\t\t\tExceptions: %d entries\n", exception_table_length];
    exception_table = [[OFMutableArray alloc] initWithCapacity: exception_table_length];
    for(int i = 0; i < exception_table_length; i++){
        ExceptionTable* extbl = [[ExceptionTable alloc] init];
        extbl->start_pc = dataToUint16(info, &index);
        extbl->end_pc = dataToUint16(info, &index);
        extbl->handler_pc = dataToUint16(info, &index);
        extbl->catch_type = dataToUint16(info, &index);
        [of_stdout writeFormat: @"\t\t\tStartPC: 0x%x\t"
                                    "EndPC: 0x%x\t"
                                    "HandlerPC: 0x%x\t"
                                    "CatchType: %d\n",
                            extbl->start_pc,
                            extbl->end_pc,
                            extbl->handler_pc,
                            extbl->catch_type];
    }
    attributes_count = dataToUint16(info, &index);
    [of_stdout writeFormat: @"\t\t\tAttributes: %d entries\n", attributes_count];
    attributes = [[OFMutableArray alloc] initWithCapacity: attributes_count];
    for(int i = 0; i < attributes_count; i++)
        {
            AttributeInfo* attr = [[AttributeInfo alloc] init];
            attr->name_index =  dataToUint16(info, &index);
            attr->length = dataToUint32(info, &index);
            attr->info = dataToData(info, &index, attr->length);
            [of_stdout writeFormat: @"\t\t\t\t[%d]: name_index: %d\t"
                                                "length: %d\n",
                i, 
                attr->name_index, 
                attr->length];
            [attributes insertObject: attr atIndex: i];
        }
    return self;
}
@end