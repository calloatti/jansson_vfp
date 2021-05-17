*!* _jansson

#include _json.h

lparameters pjson

local json_error as 'json_error_t'
local ojson as 'empty'
local json_t, json_type, iter, iterkey, jsonitem, lnx

_jsoninit()

m.json_error = createobject('json_error_t')

if file(m.pjson)

	m.json_t = json_load_file(m.pjson, 0, m.json_error.address)

else

	m.json_t = json_loads(m.pjson, 0, m.json_error.address)

endif

m.json_error = null

if m.json_t = 0

	m.ojson = .f.

else

	*!* do the first level of the json. If the root object is an array, root object class is collection

	m.json_type = json_type_get(m.json_t)

	do case

	case m.json_type = JSON_OBJECT

		m.ojson = createobject('empty')

		m.iter = json_object_iter(m.json_t)

		do while m.iter # 0

			m.iterkey = json_object_iter_key(m.iter)

			m.jsonitem = json_object_iter_value(m.iter)

			m.json_type = json_type_get(m.jsonitem)

			json_walk(m.jsonitem, m.iterkey, m.ojson, 'OBJECT')

			m.iter = json_object_iter_next(m.json_t, m.iter)

		enddo

	case m.json_type = JSON_ARRAY

		m.ojson = createobject('jsoncollection')

		for m.lnx = 0 to json_array_size(m.json_t) - 1

			json_walk(json_array_get(m.json_t, m.lnx), '', m.ojson, 'ARRAY')

		endfor

	endcase

	json_decref(m.json_t)

endif

return m.ojson

procedure json_walk

	lparameters pjson_t, pitemkey, pobject, pptype

	local lobject as 'jsoncollection'
	local json_type, itemkey, lnx, iter, iterkey, jsonitem

	m.json_type = json_type_get(m.pjson_t)

	m.itemkey = m.pitemkey

	do case

	case m.json_type > JSON_ARRAY

		*? m.pptype, m.json_type, m.itemkey, ':', json_value_get(m.pjson_t)

		if m.pptype = 'ARRAY'

			m.pobject.add(json_value_get(m.pjson_t))

		else

			try
				addproperty(m.pobject, m.itemkey, json_value_get(m.pjson_t))
			catch
				addproperty(m.pobject, json_propname_sanitize(m.itemkey), json_value_get(m.pjson_t))
			endtry

		endif

	case m.json_type = JSON_ARRAY

		*? m.pptype, m.json_type, m.itemkey, ':', json_value_get(m.pjson_t)

		m.lobject = createobject('jsoncollection')

		try
			addproperty(m.pobject, m.itemkey, m.lobject)
		catch
			addproperty(m.pobject, json_propname_sanitize(m.itemkey), m.lobject)
		endtry

		for m.lnx = 0 to json_array_size(m.pjson_t) - 1

			json_walk(json_array_get(m.pjson_t, m.lnx), m.itemkey, m.lobject, 'ARRAY')

		endfor

	case m.json_type = JSON_OBJECT

		*? m.pptype, m.json_type, m.itemkey, ':', json_value_get(m.pjson_t)

		m.lobject = createobject('empty')

		if m.pptype = 'ARRAY'

			m.pobject.add(m.lobject)

		else

			try
				addproperty(m.pobject, m.itemkey, m.lobject)
			catch
				addproperty(m.pobject, json_propname_sanitize(m.itemkey), m.lobject)
			endtry

		endif

		m.iter = json_object_iter(m.pjson_t)

		do while m.iter # 0

			m.iterkey = json_object_iter_key(m.iter)

			m.jsonitem = json_object_iter_value(m.iter)

			m.json_type = json_type_get(m.jsonitem)

			json_walk(m.jsonitem, m.iterkey, m.lobject, 'OBJECT')

			m.iter = json_object_iter_next(m.pjson_t, m.iter)

		enddo

	otherwise

		error 'json_type_get value'

	endcase

endproc

procedure json_propname_sanitize

	lparameters propname

	local invalidchars

	m.invalidchars = chrtran(m.propname, '_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '')

	if len(m.invalidchars) > 0

		m.propname = chrtran(m.propname, m.invalidchars, replicate('_', len(m.invalidchars)))

	endif

	if not left(m.propname, 1) == '_' and isalpha(left(m.propname, 1)) = .f.

		m.propname = '_' + m.propname

	endif

	if empty(m.propname)

		m.propname = 'ERROR'

	endif

	return m.propname

endproc
