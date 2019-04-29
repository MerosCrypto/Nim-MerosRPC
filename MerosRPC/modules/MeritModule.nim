#RPC object.
import ../MerosRPCObj

#Async standard lib.
import asyncdispatch

#String utils standard lib.
import strutils

#JSON standard lib.
import JSON

#Get the Blockchain's Height.
proc getHeight*(
    merit: MeritModule
): Future[int] {.async.} =
    #Call getHeight.
    var res: JSONNode = await merit.parent.call("merit", "getHeight")

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"].getStr())

    #Else, return the height.
    result = res["height"].getInt()

#Get the Blockchain's Difficulty.
proc getDifficulty*(
    merit: MeritModule
): Future[string] {.async.} =
    #Call getDifficulty.
    var res: JSONNode = await merit.parent.call("merit", "getDifficulty")

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"].getStr())

    #Else, return the difficulty.
    result = res["difficulty"].getStr()

#Get a Block.
proc getBlock*(
    merit: MeritModule,
    nonce: int
): Future[JSONNode] {.async.} =
    #Call getBlock and store it in the result.
    result = await merit.parent.call("merit", "getBlock", %* [
        nonce
    ])

    #If there was an error, raise it.
    if result.hasKey("error"):
        raise newException(MerosError, result["error"].getStr())

#Publish a Block.
proc publishBlock*(
    merit: MeritModule,
    data: string
) {.async.} =
    #Call publishBlock.
    var res: JSONNode = await merit.parent.call("merit", "publishBlock", %* [
        data.toHex()
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"].getStr())
