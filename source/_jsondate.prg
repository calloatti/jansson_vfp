*!* _jsondate

*!* converts a json date in the format YYYY-MM-DD to a date

lparameters ptstr

local ldt, dy, dm, dd

m.ldt = .f.

if chrtran(m.ptstr, '0123456789', 'XXXXXXXXXX') = 'XXXX-XX-XX'

	if m.ptstr == '0000-00-00'

		m.ldt = {//}

	else

		m.dy = val(substr(m.ptstr, 1, 4))

		m.dm = val(substr(m.ptstr, 6, 2))

		m.dd = val(substr(m.ptstr, 9, 2))

		m.ldt = date(m.dy, m.dm, m.dd)

	endif

endif

return m.ldt
