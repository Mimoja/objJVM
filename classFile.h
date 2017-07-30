#import <ObjFW/ObjFW.h>

enum{
    CONSTANT_Class = 7,
    CONSTANT_Fieldref =	9,
    CONSTANT_Methodref = 10,
    CONSTANT_InterfaceMethodref = 11,
    CONSTANT_String = 8,
    CONSTANT_Integer = 3,
    CONSTANT_Float = 4,
    CONSTANT_Long = 5,
    CONSTANT_Double = 6,
    CONSTANT_NameAndType = 12,
    CONSTANT_Utf8 =	1,
    CONSTANT_MethodHandle = 15,
    CONSTANT_MethodType = 16,
    CONSTANT_InvokeDynamic = 18,
};

enum {
    ACC_PUBLIC = 0x0001,
    ACC_PRIVATE = 0x0002,
    ACC_PROTECTED = 0x0004,
    ACC_STATIC = 0x0008,
    ACC_FINAL = 0x0010,
    ACC_SYNCHRONIZED_SUPER = 0x0020,
    ACC_VOLATILE = 0x0040,
    ACC_TRANSIENT = 0x0080,
    ACC_BRIDGE = 0x0040,
    ACC_VARARGS = 0x0080,
    ACC_NATIVE = 0x0100,
    ACC_ABSTRACT = 0x0400,
    ACC_STRICT = 0x0800,
    ACC_SYNTHETIC = 0x1000,
};

typedef enum __attr_type{
    ATTR_CODE,
    ATTR_SOURCEFILE,
    ATTR_CONSTVAL,
    ATTR_UNKNOWN,
} attr_type;

typedef struct __CONSTANT_Class_info{
    uint16_t name_index;
} CONSTANT_Class_info;

typedef struct __CONSTANT_Fieldref_info {
    uint16_t class_index;
    uint16_t name_and_type_index;
} CONSTANT_Fieldref_info;

typedef struct __CONSTANT_Methodref_info {
    uint16_t class_index;
    uint16_t name_and_type_index;
} CONSTANT_Methodref_info;

typedef struct __CONSTANT_InterfaceMethodref_info {
    uint16_t class_index;
    uint16_t name_and_type_index;
} CONSTANT_InterfaceMethodref_info;

typedef struct __CONSTANT_String_info {
    uint16_t string_index;
}CONSTANT_String_info;

typedef struct __CONSTANT_Integer_info {
    int32_t bytes;
}CONSTANT_Integer_info;

typedef struct __CONSTANT_Float_info {
    float bytes;
}CONSTANT_Float_info;

typedef struct __CONSTANT_Long_info {
    int64_t bytes;
}CONSTANT_Long_info;

typedef struct __CONSTANT_Double_info {
    double bytes;
}CONSTANT_Double_info;

typedef struct __CONSTANT_NameAndType_info {
    uint16_t name_index;
    uint16_t descriptor_index;
}CONSTANT_NameAndType_info;

typedef struct __CONSTANT_Utf8_info {
    uint16_t length;
    OFString* value;
}CONSTANT_Utf8_info;

typedef struct __CONSTANT_MethodHandle_info {
    uint8_t reference_kind;
    uint16_t reference_index;
}CONSTANT_MethodHandle_info;

typedef struct __CONSTANT_MethodType_info  {
    uint16_t descriptor_index;
}CONSTANT_MethodType_info;

typedef struct __CONSTANT_InvokeDynamic_info {
    uint16_t bootstrap_method_attr_index;
    uint16_t name_and_type_index;
}CONSTANT_InvokeDynamic_info;

typedef union __ConstantInfo{
    CONSTANT_Class_info classInfo;
    CONSTANT_Fieldref_info fieldRefInfo;
    CONSTANT_Methodref_info methodRefInfo;
    CONSTANT_InterfaceMethodref_info interfaceMethodRefInfo;
    CONSTANT_String_info stringInfo;
    CONSTANT_Integer_info integerInfo;
    CONSTANT_Float_info floatInfo;
    CONSTANT_Long_info longInfo;
    CONSTANT_Double_info doubleInfo;
    CONSTANT_NameAndType_info nameAndTypeInfo;
    CONSTANT_Utf8_info utf8Info;
    CONSTANT_MethodHandle_info methodHandleInfo;
    CONSTANT_MethodType_info methodTypeInfo;
    CONSTANT_InvokeDynamic_info invokeDynamicInfo;
} ConstantInfo;

@interface ConstantpoolInfo: OFObject
{
    @public
    uint8_t tag;
    ConstantInfo info;
    int32_t codeTag;
};
@end

// generic Attribute info class
@interface AttributeInfo: OFObject
{
    @public
    uint16_t name_index;
    uint32_t length;
    attr_type type;
    OFData* info;
};
+ (instancetype) attributeWithStream: (OFStream *)stream;
- initWithStream: (OFStream *)stream;
@end

@interface ExceptionTable: OFObject
{
    @public
	uint16_t start_pc;
	uint16_t end_pc;
    uint16_t handler_pc;
    uint16_t catch_type;
};
@end

@interface CodeAttribute: OFObject
{
	uint16_t max_stack;
	uint16_t max_locals;
	uint32_t code_length;
	OFData* code;
	uint16_t exception_table_length;
	OFMutableArray OF_GENERIC(ExceptionTable*)* exception_table;
	uint16_t attributes_count;
	OFMutableArray OF_GENERIC(AttributeInfo*)* attributes;
};
+ (instancetype) attributeWithInfo:(OFData *) info;
- initWithInfo: (OFData *) info;
@end

@interface MethodInfo: OFObject
{
    @public
    uint16_t access_flags;
    uint16_t name_index;
    uint16_t descriptor_index;
    uint16_t attributes_count;
    OFMutableArray OF_GENERIC(AttributeInfo*)* attributes;
};
@end

@interface FieldInfo: OFObject
{
    @public
    uint16_t access_flags;
    uint16_t name_index;
    uint16_t descriptor_index;
    uint16_t attributes_count;
    OFMutableArray OF_GENERIC(AttributeInfo*)* attributes;
};
@end

@interface ClassFile: OFObject
{
    @public
    uint32_t magic;
    uint16_t minor_version;
    uint16_t major_version;
    uint16_t constant_pool_count;
    OFMutableArray OF_GENERIC(ConstantpoolInfo*)* constant_pool;
    uint16_t access_flags;
    uint16_t this_class;
    uint16_t super_class;
    uint16_t interfaces_count;
    OFData* interfaces;
    uint16_t fields_count;
    OFMutableArray OF_GENERIC(FieldInfo*)* fields;
    uint16_t methods_count;
    OFMutableArray OF_GENERIC(MethodInfo*)* methods;
    uint16_t attributes_count;
    OFMutableArray OF_GENERIC(AttributeInfo*)* attributes;
};
+ (instancetype) classFileWithPath: (OFString *)path;
- initWithPath: (OFString *)path;
@end

