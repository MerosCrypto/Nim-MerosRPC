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
    result = res["result"].getStr().parseHexStr()

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

    #Else, return the block.
    result = result["result"]

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

#Get the Unlocked Merit.
proc getUnlockedMerit*(
    merit: MeritModule
): Future[int] {.async.} =
    #Call getUnlockedMerit.
    var res: JSONNode = await merit.parent.call("merit", "getUnlockedMerit")

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"]["message"].getStr())

    #Else, return the merit.
    result = res["result"].getInt()

#Get the Merit.
proc getMerit*(
    merit: MeritModule,
    key: string
): Future[int] {.async.} =
    #Call getMerit.
    var res: JSONNode = await merit.parent.call("merit", "getMerit", %* [
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
    miner: string
): Future[JSONNode] {.async.} =
    #Call getBlockTemplate.
    result = await merit.parent.call("merit", "getBlockTemplate", %* [
        miner.toHex()
    ])

    #If there was an error, raise it.
    if result.hasKey("error"):
        raise newException(MerosError, result["error"]["message"].getStr())

    #Else, return the template.
    result = result["result"]

#Publish a Block.
proc publishBlock*(
    merit: MeritModule,
    id: int,
    data: string
) {.async.} =
    #Call publishBlock.
    var res: JSONNode = await merit.parent.call("merit", "publishBlock", %* [
        id,
        data.toHex()
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"]["message"].getStr())
