*!* _jsonescape

lparameters pcjsonin

local cjsoninlen, cjsoninbuf, cjsonoutbuf, lny, lnx, chrin, chrout, cjsonout

_jsoninit()

if file(m.pcjsonin)

	m.pcjsonin = filetostr(m.pcjsonin)

endif

m.cjsoninlen  = len(m.pcjsonin)
m.cjsoninbuf  = _json_heapalloc(_json_getprocessheap(), 8, m.cjsoninlen)
m.cjsonoutbuf = _json_heapalloc(_json_getprocessheap(), 8, m.cjsoninlen * 3)

_json_memcpy_is(m.cjsoninbuf, m.pcjsonin, m.cjsoninlen)

m.lny = 0

for m.lnx = 0 to m.cjsoninlen - 1

	m.chrin = sys(2600, m.cjsoninbuf + m.lnx, 1)

	if m.chrin > chr(127)

		m.chrout = '\u00' + lower(strconv(m.chrin, 15))

		*!* "\u0000"

		_json_memcpy_is(m.cjsonoutbuf + m.lny, m.chrout, 6)

		m.lny = m.lny + 6

	else

		_json_memcpy_ii(m.cjsonoutbuf + m.lny, m.cjsoninbuf + m.lnx, 1)

		m.lny = m.lny + 1

	endif

endfor

m.cjsonout = sys(2600, m.cjsonoutbuf, m.lny)

_json_heapfree(_json_getprocessheap(), 0, m.cjsoninbuf)

_json_heapfree(_json_getprocessheap(), 0, m.cjsonoutbuf)

return m.cjsonout

