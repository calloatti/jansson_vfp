*!* _jsonobject

return createobject('jsonobject')

define class jsonobject as session

	hidden application
	hidden baseclass
	hidden class
	hidden classlibrary
	hidden comment
	hidden datasession
	hidden datasessionid
	hidden name
	hidden parent
	hidden parentclass
	hidden tag

	m.datasession = 1

	function this_access(ppropname)

		?m.ppropname

		if type('this.' + m.ppropname) == 'U'
		
			= addproperty(this, m.ppropname, .f.)

		endif

		return this

	endfunc

enddefine