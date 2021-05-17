*!* _jsontzo

*!* RETURN VALUE IS SECONDS

*!* returns a time zone offset in seconds from a json datetime in the format YYYY-MM-DDThh:mm:ss.sTZD
*!* TZD  = time zone designator (Z or +hh:mm or -hh:mm)

lparameters ptstr

local tzo, ctzo

m.tzo = 0

if upper(right(m.ptstr, 1)) == 'Z'

	m.tzo = 0

else

	m.ctzo = right(m.ptstr, 6)

	if chrtran(m.ctzo, '+-0123456789', '##XXXXXXXXXX') = '#XX:XX'

		m.tzo = val(substr(m.ctzo, 2, 2)) * 60 * 60 + val(substr(m.ctzo, 5, 2)) * 60

		if left(m.ctzo, 1) == '-'

			m.tzo = m.tzo * (-1)

		endif

	endif

endif

return m.tzo