*!* _jsongetvalue

*!* DO NOT USE ".item" IN PCPROP, IT DOES NOT WORK WITH "TYPE"

lparameters pojson, pcprop, pdefault

if type('m.pojson.' + m.pcprop) # 'U'

	return evaluate('m.pojson.' + m.pcprop)

else

	return m.pdefault

endif



