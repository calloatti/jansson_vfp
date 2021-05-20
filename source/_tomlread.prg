*!* _tomlread2

#define LIBTOMLDLL	tomlc99.dll

lparameters pctoml

local otoml as 'empty'
local ctoml, errbufsz, errbuf, tomltable

declare integer toml_parse in LIBTOMLDLL string ctoml, string @ errbuf, integer errbufsz	&& returns a pointer to a toml_table_t
declare         toml_free  in LIBTOMLDLL integer toml_table_t
declare integer toml_table_nkval in LIBTOMLDLL integer toml_table_t		&& Return the number of key-values in a table
declare string  toml_table_key in LIBTOMLDLL integer toml_table_t

declare integer toml_key_in in LIBTOMLDLL as toml_key_in_i	integer toml_table_t, integer keyidx && retrieve the key in table at keyidx. Return 0 if out of range
declare string  toml_key_in in LIBTOMLDLL as toml_key_in_s	integer toml_table_t, integer keyidx && retrieve the key in table at keyidx. Return 0 if out of range

declare integer toml_raw_in in LIBTOMLDLL as toml_raw_in_i	integer toml_table_t, string ckey
declare string  toml_raw_in in LIBTOMLDLL as toml_raw_in_s	integer toml_table_t, string ckey

declare integer toml_array_in in LIBTOMLDLL integer toml_table_t, string ckey
declare integer toml_table_in in LIBTOMLDLL integer toml_table_t, string ckey

declare integer toml_array_kind in LIBTOMLDLL integer toml_array_t

declare integer toml_array_nelem in LIBTOMLDLL integer toml_array_t

declare integer toml_table_at in LIBTOMLDLL integer toml_array_t, integer idx

if file(m.pctoml)

	m.ctoml = filetostr(m.pctoml)

else

	m.ctoml = m.pctoml

endif

m.errbufsz = 200

m.errbuf = replicate(chr(0), m.errbufsz)

m.tomltable = toml_parse(m.ctoml, @m.errbuf, m.errbufsz)

if m.tomltable = 0

	*?rtrim(m.errbuf, 1, chr(0))

	return .f.

endif

m.otoml = createobject('empty')

toml_walk_table(m.otoml, m.tomltable)

toml_free(m.tomltable)

return m.otoml

procedure toml_walk_table

	lparameters potoml, ptomltable, pcpath

	local otoml as 'empty'
	local lnx, nkey, ckey, rawint, tomlarray, tomltable, rawstr, vvalue, cpath

	m.lnx = 0

	do while .t.

		m.nkey = toml_key_in_i(m.ptomltable, m.lnx)

		if m.nkey = 0 then

			exit

		endif

		m.ckey = toml_key_in_s(m.ptomltable, m.lnx)

		m.rawint = toml_raw_in_i(m.ptomltable, m.ckey)

		m.tomlarray = toml_array_in(m.ptomltable, m.ckey)

		m.tomltable = toml_table_in(m.ptomltable, m.ckey)

		m.rawstr = ''

		m.cpath = iif(empty(m.pcpath), m.ckey, m.pcpath + '.' + m.ckey)

		do case

		case m.rawint # 0

			m.rawstr = toml_raw_in_s(m.ptomltable, m.ckey)

			m.vvalue = toml_getvalue(m.rawstr)

			try
				addproperty(m.potoml, m.ckey, m.vvalue)
			catch
				addproperty(m.potoml, toml_sanitize_key(m.ckey), m.vvalue)
			endtry

			*?m.lnx, m.cpath, ':', m.vvalue

		case m.tomlarray # 0

			*?m.lnx, m.cpath, 'ARRAY', toml_array_kind(m.tomlarray)

			toml_walk_array(m.potoml, m.tomlarray, m.cpath, m.ckey)

		case m.tomltable # 0

			m.otoml = createobject('empty')

			try
				addproperty(m.potoml, m.ckey, m.otoml )
			catch
				addproperty(m.potoml, toml_sanitize_key(m.ckey), m.otoml )
			endtry

			*?m.lnx, m.cpath, 'TABLE'

			toml_walk_table(m.otoml, m.tomltable, m.cpath)

		endcase

		m.lnx = m.lnx + 1

	enddo

endproc

procedure toml_walk_array

	lparameters potoml, ptomlarray, pcpath, pckey

	local otoml as 'empty'
	local lnx, narraylen, ckey

	if toml_array_kind(m.ptomlarray) = 116

		m.narraylen = toml_array_nelem(m.ptomlarray)

		m.ckey = toml_sanitize_key(m.pckey)

		addproperty(m.potoml, m.ckey + '(' + transform(m.narraylen) + ')')

		for m.lnx = 1 to m.narraylen

			m.otoml = createobject('empty')

			with m.potoml

				store m.otoml to ('.' + m.ckey + '(' + transform(m.lnx) + ')')

			endwith

			toml_walk_table(m.otoml, toml_table_at(m.ptomlarray, m.lnx - 1), m.pcpath)

		endfor

	endif

endproc

procedure toml_getvalue

	lparameters prawstr

	local vvalue

	m.vvalue = null

	do case

	case m.prawstr  == 'true' or m.prawstr  == 'TRUE'

		m.vvalue = .t.

	case m.prawstr  == 'false' or m.prawstr  == 'FALSE'

		m.vvalue = .f.

	case left(m.prawstr, 5) == 0h2727270d0a or left(m.prawstr, 5) == 0h2222220d0a		&& ''' + crlf or """ + crlf

		m.vvalue = rtrim(substr(m.prawstr, 6, len(m.prawstr) - 5 - 3), 1, 0h0d, 0h0a)

	case left(m.prawstr, 4) == 0h2727270a or left(m.prawstr, 4) == 0h2222220a			&& ''' + lf or """ + lf

		m.vvalue = rtrim(substr(m.prawstr, 5, len(m.prawstr) - 4 - 3), 1, 0h0d, 0h0a)

	case left(m.prawstr, 3) == 0h272727 or left(m.prawstr, 3) == 0h222222				&& ''' or """

		m.vvalue = rtrim(substr(m.prawstr, 4, len(m.prawstr) - 3 - 3), 1, 0h0d, 0h0a)

	case left(m.prawstr, 1) == 0h27 or left(m.prawstr, 1) == 0h22						&& ' or "

		m.vvalue = substr(m.prawstr, 2, len(m.prawstr) - 1 - 1)

	case occurs('-', m.prawstr) = 2 or occurs(':', m.prawstr) > 1						&& 1979-05-27T07:32:00Z

		m.vvalue = chrtran(m.prawstr, ' ', 'T')

	case isdigit(m.prawstr) or left(m.prawstr, 1) == '-' or left(m.prawstr, 1)  == '+'	&& numeric values

		if occurs('.', m.prawstr) = 0

			m.vvalue = int(val(chrtran(m.prawstr, '_', '')))

		else

			m.vvalue = val(chrtran(m.prawstr, '_', ''))

		endif

	endcase

	return m.vvalue

endproc

procedure toml_sanitize_key

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






