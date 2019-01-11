#RPC object.
import ../EmberRPCObj

#Async standard lib.
import asyncdispatch

#String utils standard lib.
import strutils

#JSON standard lib.
import JSON

#Set the seed.
proc setSeed*(personal: PersonalModule, seed: string) {.async.} =
    #Call setSeed.
    var res: JSONNode = await personal.parent.call("personal", "setSeed", %* [
        seed
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(EmberError, res["error"].getStr())

#Get the Wallet.
proc getWallet*(personal: PersonalModule): Future[JSONNode] {.async.} =
    #Call getWallet and store the result.
    result = await personal.parent.call("personal", "getWallet")

    #If there was an error, raise it.
    if result.hasKey("error"):
        raise newException(EmberError, result["error"].getStr())

#Create a Send.
proc send*(
    personal: PersonalModule,
    address: string,
    amount: string,
    nonce: string
): Future[string] {.async.} =
    #Call send.
    var res: JSONNode = await personal.parent.call("personal", "send", %* [
        address,
        amount,
        nonce
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(EmberError, res["error"].getStr())

    #Else, return the hash.
    result = res["hash"].getStr()

#Create a Receive.
proc receive*(
    personal: PersonalModule,
    inputAddress: string,
    inputNonce: string,
    nonce: string
): Future[string] {.async.} =
    #Call receive.
    var res: JSONNode = await personal.parent.call("personal", "receive", %* [
        inputAddress,
        inputNonce,
        nonce
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(EmberError, res["error"].getStr())

    #Else, return the hash.
    result = res["hash"].getStr()

#Create a Data.
proc data*(
    personal: PersonalModule,
    data: string,
    nonce: string
): Future[string] {.async.} =
    #Call data.
    var res: JSONNode = await personal.parent.call("personal", "data", %* [
        data.toHex(),
        nonce
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(EmberError, res["error"].getStr())

    #Else, return the hash.
    result = res["hash"].getStr()
