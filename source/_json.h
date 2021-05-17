*!* _json.h

#define JSON_MAX_INDENT        0x1F
#define JSON_INDENT(n)         ((n)&JSON_MAX_INDENT)
#define JSON_COMPACT           0x20
#define JSON_ENSURE_ASCII      0x40
#define JSON_SORT_KEYS         0x80
#define JSON_PRESERVE_ORDER    0x100
#define JSON_ENCODE_ANY        0x200
#define JSON_ESCAPE_SLASH      0x400
#define JSON_REAL_PRECISION(n) (((n)&0x1F) << 11)
#define JSON_EMBED             0x10000

#define HEAP_ZERO_MEMORY	8

#define JSON_ERROR_TEXT_LENGTH160
#define JSON_ERROR_SOURCE_LENGTH 80

#define JSON_OBJECT		0
#define JSON_ARRAY		1
#define JSON_STRING		2
#define JSON_INTEGER	3
#define JSON_REAL		4
#define JSON_TRUE		5
#define JSON_FALSE		6
#define JSON_NULL		7

#define JSON_REJECT_DUPLICATES  0x1
#define JSON_DISABLE_EOF_CHECK  0x2
#define JSON_DECODE_ANY         0x4
#define JSON_DECODE_INT_AS_REAL 0x8
#define JSON_ALLOW_NUL          0x10

*!*	typedef struct json_t {
*!*	    json_type type;
*!*	    volatile size_t refcount;
*!*	} json_t;

