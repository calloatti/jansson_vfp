*!* test1

CLEAR MEMORY

public ojson

*m.ojson = _jsonread("C:\VFPP\jansson\jsontest\json_addon.txt")

*m.ojson = _jsonread("C:\VFPP\jansson\jsontest\json_file.txt")

m.ojson = _jsonread("C:\VFPP\jansson\jsontest\game_version.txt")

*m.ojson = _jsonread("C:\VFPP\jansson\jsontest\json_file.txt")

_jsontocursor(m.ojson)

 