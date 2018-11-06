#RPC object.
import ../EmberRPCObj

#Async standard lib.
import asyncdispatch

#JSON standard lib.
import JSON

#Get the Blockchain's Difficulty.
proc getDifficulty*(merit: MeritModule): Future[string] {.async.} =
    #Call getDifficulty.
    var res: JSONNode = await merit.parent.call("merit", "getDifficulty")

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(EmberError, res["error"].getStr())

    #Else, return the difficulty.
    result = res["difficulty"].getStr()
