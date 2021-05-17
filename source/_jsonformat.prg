*!* _jsonformat

#include _json.h

lparameters pjson

local json_error as 'json_error_t'
local json_t, jsonpretty, iflags, isize, iresult

_jsoninit()

m.json_error  = createobject('json_error_t')

m.json_error = createobject('json_error_t')

if file(m.pjson)

	m.json_t = json_load_file(m.pjson, 0, m.json_error.address)

else

	m.json_t = json_loads(m.pjson, 0, m.json_error.address)

endif

m.jsonpretty = ''

if m.json_t # 0

	iflags = 2 + JSON_ENSURE_ASCII 
	
	m.isize = json_dumpb(m.json_t, null, 0, iflags)

	if m.isize > 0

		m.jsonpretty = space(m.isize)

		m.iresult = json_dumpb(m.json_t, @jsonpretty, m.isize, iflags)

		json_decref(m.json_t)

	endif

endif

return m.jsonpretty


  