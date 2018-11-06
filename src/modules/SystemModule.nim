#RPC object.
import ../EmberRPCObj

#Async standard lib.
import asyncdispatch

#Quit.
proc quit*(system: SystemModule) {.async.} =
    discard await system.parent.call("system", "quit")
