*!* _tomlread

lparameters ptoml

local otoml as 'empty'

local nlines, lalines[1], lnx, cline, ckey, cvalue, vvalue, lastquotepos, currentobj, ocollection

if file(m.ptoml)

	m.ptoml = filetostr(m.ptoml)

endif

m.nlines = alines(lalines, m.ptoml, 1 + 4)

m.otoml = createobject('empty')

m.currentobj = m.otoml

m.ocollection = ''

for m.lnx = 1 to m.nlines

	m.cline = ltrim(m.lalines(m.lnx), 1, 0h09)

	*!* ignore empty lines that only have TABS

	if empty(m.cline)

		loop

	endif

	do case

	case left(m.cline, 1) == '#'

	case left(m.cline, 2) == '[['

		m.ckey = strextract(m.cline, '[[', ']]')

		m.ckey = alltrim(m.ckey, 1, '"')

		m.ckey = chrtran(m.ckey, '.-', '__')

		m.currentobj = createobject('empty')

		if type('m.otoml.' + m.ckey) == 'U'

			m.ocollection = createobject('tomlcollection')

			addproperty(m.otoml, m.ckey, m.ocollection)

		endif

		m.ocollection.add(m.currentobj)

	case left(m.cline, 1) == '['

		m.ckey = strextract(m.cline, '[', ']')

		m.ckey = alltrim(m.ckey, 1, '"')

		m.ckey = chrtran(m.ckey, '.-', '__')

		m.currentobj = createobject('empty')

		addproperty(m.otoml, m.ckey, m.currentobj)

	otherwise

		m.ckey = alltrim(strextract(m.cline, '', '='))

		m.cvalue = alltrim(strextract(m.cline, '=', ''))

		m.ckey = alltrim(m.ckey, 1, '"')

		m.ckey = chrtran(m.ckey, '.-', '__')

		if val(m.ckey) > 0

			m.ckey = '_' + m.ckey

		endif

		do case

		case m.cvalue == '"""'

		case m.cvalue == "'''"

			m.vvalue = ''

			m.lnx = m.lnx + 1

			do while .t.

				m.cvalue = m.lalines(m.lnx)

				do case

				case m.cvalue == "'''"

					exit

				case right(m.cvalue, 3) == "'''"

					if not empty(m.vvalue)

						m.vvalue = m.vvalue + 0h0d0a

					endif

					m.vvalue = m.vvalue + rtrim(m.cvalue, 1, "'")

				otherwise

					if not empty(m.vvalue)

						m.vvalue = m.vvalue + 0h0d0a

					endif

					m.vvalue = m.vvalue + rtrim(m.cvalue, 1, "'")

				endcase

				m.lnx = m.lnx + 1

			enddo

		case left(m.cvalue, 1) = "'"

			m.lastquotepos = at("'", m.cvalue, occurs("'", m.cvalue))

			m.cvalue = left(m.cvalue, m.lastquotepos)

			m.vvalue = alltrim(m.cvalue, "'")

		case left(m.cvalue, 1) = '"'

			m.lastquotepos = at('"', m.cvalue, occurs('"', m.cvalue))

			m.cvalue = left(m.cvalue, m.lastquotepos)

			m.vvalue = alltrim(m.cvalue, '"')

		case m.cvalue = 'false'

			m.vvalue = .f.

		case m.cvalue = 'true'

			m.vvalue = .t.

		otherwise

			m.vvalue = val(m.cvalue)

		endcase

		addproperty(m.currentobj, m.ckey, m.vvalue)

	endcase

endfor

return m.otoml

define class tomlcollection as collection
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







