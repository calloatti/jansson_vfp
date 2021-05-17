*!* _jsonload

lparameters pjson

local json_error as 'json_error_t'
local oerror as 'empty'
local json_t, efull

_jsoninit()

m.json_error = createobject('json_error_t')

if file(m.pjson)

	m.json_t = json_load_file(m.pjson, 0, m.json_error.address)

else

	m.json_t = json_loads(m.pjson, 0, m.json_error.address)

endif

if m.json_t # 0

	json_decref(m.json_t)

endif

m.oerror = createobject('empty')

addproperty(m.oerror, 'json_t', m.json_t)
addproperty(m.oerror, 'eline', m.json_error.eline)
addproperty(m.oerror, 'ecolumn', m.json_error.ecolumn)
addproperty(m.oerror, 'eposition', m.json_error.eposition)
addproperty(m.oerror, 'esource', m.json_error.esource)
addproperty(m.oerror, 'etext', m.json_error.etext)
addproperty(m.oerror, 'ecode', m.json_error.ecode)
addproperty(m.oerror, 'edesc', m.json_error.edesc)

m.efull = ;
	'line:' + transform(m.json_error.eline) + 0h0d0a + ;
	'column:' + transform(m.json_error.ecolumn) + 0h0d0a + ;
	'position:' + transform(m.json_error.eposition) + 0h0d0a + ;
	'source:' + transform(m.json_error.esource) +  0h0d0a + ;
	'text:' + transform(m.json_error.etext) +  0h0d0a + ;
	'code:' + transform(m.json_error.ecode) + 0h0d0a + ;
	'description:' + transform(m.json_error.edesc) + 0h0d0a

addproperty(m.oerror, 'efull', m.efull)

m.json_error = null

return m.oerror

