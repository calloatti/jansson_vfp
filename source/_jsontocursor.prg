*!* _jsontocursor

lparameters pojson

local lny

create cursor  '_json' (jprop v(200), jvalue v(200), jtype c(1), jlvl i)

if vartype(m.pojson) # 'O'

	return

endif

select '_json'

if type('m.pojson.count') = 'N'

	append blank in '_json'

	replace _json.jprop with 'count' in '_json'

	replace _json.jvalue with transform(m.pojson.count) in '_json'

	replace _json.jtype with 'N' in '_json'

	replace _json.jlvl with 1 in '_json'

	for m.lny = 1 to m.pojson.count

		_jsontocursorwalk(m.pojson.item(m.lny), 'item' + '[' + transform(m.lny) + ']', 1)

	endfor

else

	_jsontocursorwalk(m.pojson, '', 1)

endif

procedure _jsontocursorwalk

	lparameters pobj, pprop, plvl

local nprops, aprops[1], lnx, jprop, lvalue, lny, jpropitem

	if vartype(m.pobj) # 'O'

		append blank in '_json'

		replace _json.jprop with m.pprop in '_json'

		m.lvalue = evaluate('pobj')

		replace _json.jvalue with transform(m.lvalue) in '_json'

		replace _json.jtype with vartype(m.lvalue) in '_json'

		replace _json.jlvl with m.plvl in '_json'

	else

		m.nprops = amembers(aprops, m.pobj)

		for m.lnx = 1 to m.nprops

			append blank in '_json'

			if empty(m.pprop)

				m.jprop		= lower(m.aprops(m.lnx))
				m.jpropitem	= lower(m.aprops(m.lnx)) + '.item'

			else

				m.jprop		= m.pprop + '.' + lower(m.aprops(m.lnx))
				m.jpropitem	= m.pprop + '.' + lower(m.aprops(m.lnx)) + '.item'

			endif

			replace _json.jprop with m.jprop in '_json'

			m.lvalue = evaluate('pobj.' + m.aprops(m.lnx))

			replace _json.jvalue with transform(m.lvalue) in '_json'

			replace _json.jtype with vartype(m.lvalue) in '_json'

			replace _json.jlvl with m.plvl in '_json'

			if vartype(m.lvalue) = 'O'

				if type('m.lvalue.count') = 'N'

					replace _json.jvalue with '[ARRAY]'

				else

					replace _json.jvalue with '[OBJECT]'

				endif

				_jsontocursorwalk(m.lvalue, m.jprop, m.plvl)

				if type('m.lvalue.count') = 'N'

					for m.lny = 1 to m.lvalue.count

						_jsontocursorwalk(m.lvalue.item(m.lny), m.jpropitem + '[' + transform(m.lny) + ']', m.plvl + 1)

					endfor

				endif

			endif

		endfor

	endif

endproc
















 