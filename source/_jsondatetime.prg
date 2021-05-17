*!* _jsondatetime

*!* converts a json datetime in the format YYYY-MM-DDThh:mm:ss.sTZD to a datetime
*!* TZD  = time zone designator (Z or +hh:mm or -hh:mm)

lparameters ptstr

local ldt, dy, dm, dd, th, tm, ts

m.ldt = .f.

m.ptstr = left(m.ptstr, 19)

if chrtran(m.ptstr, '0123456789', 'XXXXXXXXXX') = 'XXXX-XX-XXTXX:XX:XX'

	if m.ptstr == '0000-00-00T00:00:00'

		m.ldt = {//::}

	else

		m.dy = val(substr(m.ptstr, 1, 4))

		m.dm = val(substr(m.ptstr, 6, 2))

		m.dd = val(substr(m.ptstr, 9, 2))

		m.th = val(substr(m.ptstr, 12, 2))

		m.tm = val(substr(m.ptstr, 15, 2))

		m.ts = val(substr(m.ptstr, 18, 2))

		m.ldt = datetime(m.dy, m.dm, m.dd, m.th, m.tm, m.ts)

	endif

endif

return m.ldt

