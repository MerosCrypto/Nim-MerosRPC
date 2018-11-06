#RPC object.
import ../EmberRPCObj

#Async standard lib.
import asyncdispatch

#JSON standard lib.
import JSON

#Get the Blockchain's Height.
proc getHeight*(merit: MeritModule): Future[int] {.async.} =
    #Call getHeight.
    var res: JSONNode = await merit.parent.call("merit", "getHeight")

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(EmberError, res["error"].getStr())

    #Else, return the height.
    result = res["height"].getInt()

#Get the Blockchain's Difficulty.
proc getDifficulty*(merit: MeritModule): Future[string] {.async.} =
    #Call getDifficulty.
    var res: JSONNode = await merit.parent.call("merit", "getDifficulty")

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(EmberError, res["error"].getStr())

    #Else, return the difficulty.
    result = res["difficulty"].getStr()

#Get a Block.
proc getBlock*(merit: MeritModule, nonce: int): Future[JSONNode] {.async.} =
    #Call getBlock and store it in the result.
    result = await merit.parent.call("merit", "getBlock", %* [
        nonce
    ])

    #If there was an error, raise it.
    if result.hasKey("error"):
        raise newException(EmberError, result["error"].getStr())
