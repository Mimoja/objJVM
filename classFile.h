#import <ObjFW/ObjFW.h>

enum {
    CONSTANT_Class = 7,
    CONSTANT_Fieldref =	9,
    CONSTANT_Methodref= 10,
    CONSTANT_InterfaceMethodref = 11,
    CONSTANT_String = 8,
    CONSTANT_Integer = 3,
    CONSTANT_Float = 4,
    CONSTANT_Long =	5,
    CONSTANT_Double = 6,
    CONSTANT_NameAndType = 12,
    CONSTANT_Utf8 =	1,
    CONSTANT_MethodHandle = 15,
    CONSTANT_MethodType = 16,
    CONSTANT_InvokeDynamic = 18,
};

@interface AttributeInfo: OFObject
{
    @public
    uint16_t name_index;
    uint32_t length;
    OFData* info;
};
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
    OFMutableArray* fields;
    uint16_t methods_count;
    OFMutableArray OF_GENERIC(MethodInfo*)* methods;
    uint16_t attributes_count;
    OFMutableArray OF_GENERIC(AttributeInfo*)* attributes;
};
+ (instancetype) classFileWithPath: (OFString *)path;
- initWithPath: (OFString *)path;
@end

