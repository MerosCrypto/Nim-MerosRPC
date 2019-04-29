#RPC object.
import ../MerosRPCObj

#Async standard lib.
import asyncdispatch

#Quit.
proc quit*(
    system: SystemModule
) {.async.} =
    discard await system.parent.call("system", "quit")
