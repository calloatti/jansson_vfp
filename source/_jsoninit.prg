*!* jsoninit

#include _json.h

if not sys(16) $ upper(set("Procedure")) then
	set procedure to sys(16) additive
endif

declare integer HeapAlloc in kernel32.dll as _json_heapalloc integer hHeap, integer dwFlags, integer dwBytes
declare integer HeapFree in kernel32.dll as _json_heapfree integer hheap, integer dwflags, integer lpmem
declare integer HeapSize in kernel32.dll as _json_heapsize integer hHeap, integer dwFlags, integer lpMem
declare integer GetProcessHeap in kernel32.dll as _json_getprocessheap

declare integer json_loads in jansson.dll string sinput, integer iflags, integer json_error_t
declare integer json_load_file in jansson.dll string cpath, integer iflags, integer json_error_t
declare json_delete in jansson.dll integer json_t
declare integer json_array_size in jansson.dll integer json_t
declare integer json_array_get in jansson.dll integer json_t, integer iindex
declare integer json_object_get in jansson.dll integer json_t, string ckey
declare string  json_string_value in jansson.dll integer json_t
declare integer json_integer_value in jansson.dll integer json_t
declare double  json_real_value in jansson.dll integer json_t
declare double  json_number_value in jansson.dll integer json_t

declare integer json_object_iter in jansson.dll integer json_t
declare integer json_object_iter_next in jansson.dll integer json_t, integer iter
declare string  json_object_iter_key in jansson.dll integer iter
declare integer json_object_iter_value in jansson.dll  integer iter

declare integer json_dumpb in jansson.dll integer json_t, string @ cbuffer, integer isize, integer iflags

procedure json_type_get

	lparameters pjson

	return ctobin(sys(2600, m.pjson, 4), '4rs')

endproc

procedure json_incref

	lparameters pjson

	local refcount

	m.refcount = sys(2600, m.pjson + 4, 4)

	m.refcount = ctobin(m.refcount, '4rs')

	m.refcount = m.refcount + 1

	m.refcount = bintoc(m.refcount, '4rs')

	sys(2600, m.pjson + 4, 4, m.refcount)

endproc

procedure json_decref

	lparameters pjson

	local refcount

	m.refcount = sys(2600, m.pjson + 4, 4)

	m.refcount = ctobin(m.refcount, '4rs')

	m.refcount = m.refcount - 1

	if m.refcount = 0

		json_delete(m.pjson)

	else

		m.refcount = bintoc(m.refcount, '4rs')

		writeuint(m.pjson + 4, m.refcount)

	endif

endproc

procedure json_value_get

	lparameters pjson

	local json_type, json_value

	m.json_type = json_type_get(m.pjson)

	do case

	case m.json_type = JSON_OBJECT

		m.json_value = 'JSON_OBJECT'

	case m.json_type = JSON_ARRAY

		m.json_value = 'JSON_ARRAY'

	case m.json_type = JSON_STRING

		m.json_value = strconv(json_string_value(m.pjson), 11)

	case m.json_type = JSON_INTEGER

		m.json_value = int(json_number_value(m.pjson))

	case m.json_type = JSON_REAL

		m.json_value = json_real_value(m.pjson)

	case m.json_type = JSON_TRUE

		m.json_value = .t.

	case m.json_type = JSON_FALSE

		m.json_value = .f.

	case m.json_type = JSON_NULL

		m.json_value = ''

	otherwise

		error 'json_value_get'

	endcase

	return m.json_value

endproc

define class jsoncollection as collection
	hidden baseclass
	hidden class
	hidden classlibrary
	hidden comment
	hidden keysort
	hidden name
	hidden parent
	hidden parentclass
	hidden tag

enddefine

define class json_error_t as exception

	*!*	typedef struct json_error_t {
	*!*	    int line;
	*!*	    int column;
	*!*	    int position;
	*!*	    char source[80];
	*!*	    char text[160]; The last byte of this array contains a numeric error code. Use json_error_code() to extract this code.
	*!*	} json_error_t;

	m.address	= 0
	m.sizeof	= 252
	m.name		= "json_error_t"
	m.eline		= .f.
	m.ecolumn	= .f.
	m.eposition	= .f.
	m.esource	= .f.
	m.etext		= .f.
	m.ecode		= .f.
	m.edesc		= .f.

	procedure init()
		this.address = _json_heapalloc(_json_getprocessheap(), HEAP_ZERO_MEMORY, this.sizeof)
	endproc

	procedure destroy()
		_json_heapfree(_json_getprocessheap(), 0, this.address)
	endproc

	procedure eline_access()
		return ctobin(sys(2600, this.address, 4), '4rs')
	endproc

	procedure ecolumn_access()
		return ctobin(sys(2600, this.address + 4, 4), '4rs')
	endproc

	procedure eposition_access()
		return ctobin(sys(2600, this.address + 8, 4), '4rs')
	endproc

	procedure esource_access()
		return rtrim(sys(2600, this.address + 12, 80), 1, 0h00)
	endproc

	procedure etext_access()
		return rtrim(sys(2600, this.address + 92, 159), 1, 0h00)
	endproc

	procedure ecode_access()
		return asc(sys(2600, this.address + 251, 1))
	endproc

	procedure edesc_access()
		do case
		case this.ecode = 0
			return 'json_error_unknown'
		case this.ecode = 1
			return 'json_error_out_of_memory'
		case this.ecode = 2
			return 'json_error_stack_overflow'
		case this.ecode = 3
			return 'json_error_cannot_open_file'
		case this.ecode = 4
			return 'json_error_invalid_argument'
		case this.ecode = 5
			return 'json_error_invalid_utf8'
		case this.ecode = 6
			return 'json_error_premature_end_of_input'
		case this.ecode = 7
			return 'json_error_end_of_input_expected'
		case this.ecode = 8
			return 'json_error_invalid_syntax'
		case this.ecode = 9
			return 'json_error_invalid_format'
		case this.ecode = 10
			return 'json_error_wrong_type'
		case this.ecode = 11
			return 'json_error_null_character'
		case this.ecode = 12
			return 'json_error_null_value'
		case this.ecode = 13
			return 'json_error_null_byte_in_key'
		case this.ecode = 14
			return 'json_error_duplicate_key'
		case this.ecode = 15
			return 'json_error_numeric_overflow'
		case this.ecode = 16
			return 'json_error_item_not_found'
		case this.ecode = 17
			return 'json_error_index_out_of_range'
		otherwise
			return ''
		endcase
	endproc

enddefine