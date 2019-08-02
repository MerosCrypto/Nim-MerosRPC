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
        raise newException(MerosError, res["error"]["message"].getStr())

    #Else, return the height.
    result = res["result"].getInt()

#Get the Blockchain's Difficulty.
proc getDifficulty*(
    merit: MeritModule
): Future[string] {.async.} =
    #Call getDifficulty.
    var res: JSONNode = await merit.parent.call("merit", "getDifficulty")

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"]["message"].getStr())

    #Else, return the difficulty.
    result = res["result"].getStr()

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

#Get the Total Merit.
proc getTotalMerit*(
    merit: MeritModule
): Future[int] {.async.} =
    #Call getTotalMerit.
    var res: JSONNode = await merit.parent.call("merit", "getTotalMerit")

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"]["message"].getStr())

    #Else, return the merit.
    result = res["result"].getInt()

#Get the Live Merit.
proc getLiveMerit*(
    merit: MeritModule
): Future[int] {.async.} =
    #Call getLiveMerit.
    var res: JSONNode = await merit.parent.call("merit", "getLiveMerit")

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"]["message"].getStr())

    #Else, return the merit.
    result = res["result"].getInt()

#Get the Live Merit.
proc getLiveMerit*(
    merit: MeritModule,
    key: string
): Future[int] {.async.} =
    #Call getLiveMerit.
    var res: JSONNode = await merit.parent.call("merit", "getLiveMerit", %* [
        key
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"]["message"].getStr())

    #Else, return the merit.
    result = res["result"].getInt()

#Get a Block Template.
proc getBlockTemplate*(
    merit: MeritModule,
    miners: JSONNode
): Future[JSONNode] {.async.} =
    #Call getBlockTemplate.
    result = await merit.parent.call("merit", "getBlockTemplate", miners)

    #If there was an error, raise it.
    if result.hasKey("error"):
        raise newException(MerosError, result["error"]["message"].getStr())

    #Else, return the template.
    result = result["result"]

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
        raise newException(MerosError, res["error"]["message"].getStr())
