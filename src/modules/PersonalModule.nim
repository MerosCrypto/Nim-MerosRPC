#RPC object.
import ../EmberRPCObj

#Async standard lib.
import asyncdispatch

#JSON standard lib.
import JSON

#Get the Wallet.
proc getWallet*(personal: PersonalModule): Future[JSONNode] {.async.} =
    #Call getWallet and store the result.
    result = await personal.parent.call("personal", "getWallet")

    #If there was an error, raise it.
    if result.hasKey("error"):
        raise newException(EmberError, result["error"].getStr())

#Set the seed.
proc setSeed*(personal: PersonalModule, seed: string): Future[bool] {.async.} =
    #Call setSeed.
    var res: JSONNode = await personal.parent.call("personal", "setSeed", %* [
        seed
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(EmberError, res["error"].getStr())

    #Else, return true.
    result = true

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
proc send*(
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
