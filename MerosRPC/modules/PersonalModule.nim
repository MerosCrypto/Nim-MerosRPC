#RPC object.
import ../MerosRPCObj

#Async standard lib.
import asyncdispatch

#String utils standard lib.
import strutils

#JSON standard lib.
import JSON

#Set the seed.
proc setSeed*(
    personal: PersonalModule,
    seed: string
) {.async.} =
    #Call setSeed.
    var res: JSONNode = await personal.parent.call("personal", "setSeed", %* [
        seed
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"].getStr())

#Get the Wallet.
proc getWallet*(
    personal: PersonalModule
): Future[JSONNode] {.async.} =
    #Call getWallet and store the result.
    result = await personal.parent.call("personal", "getWallet")

    #If there was an error, raise it.
    if result.hasKey("error"):
        raise newException(MerosError, result["error"].getStr())

#Create a Send.
proc send*(
    personal: PersonalModule,
    destination: string,
    amount: string
): Future[string] {.async.} =
    #Call send.
    var res: JSONNode = await personal.parent.call("personal", "send", %* [
        destination,
        amount
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"].getStr())

    #Else, return the hash.
    result = res["hash"].getStr()

#Create a Data.
proc data*(
    personal: PersonalModule,
    data: string
): Future[string] {.async.} =
    #Call data.
    var res: JSONNode = await personal.parent.call("personal", "data", %* [
        data.toHex()
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"].getStr())

    #Else, return the hash.
    result = res["hash"].getStr()
