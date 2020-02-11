#RPC object.
import ../MerosRPCObj

#Async standard lib.
import asyncdispatch

#String utils standard lib.
import strutils

#JSON standard lib.
import JSON

#Get the miner key.
proc getMiner*(
    personal: PersonalModule
): Future[string] {.async.} =
    #Call getMiner.
    var res: JSONNode = await personal.parent.call("personal", "getMiner")

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"]["message"].getStr())

    #Else, return the key.
    result = res["result"].getStr().parseHexStr()

#Set the mnemonic.
proc setMnemonic*(
    personal: PersonalModule,
    mnemonic: string
) {.async.} =
    #Call setMnemonic.
    var res: JSONNode = await personal.parent.call("personal", "setMnemonic", %* [
        mnemonic
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"]["message"].getStr())

#Get the Mnemonic.
proc getMnemonic*(
    personal: PersonalModule
): Future[string] {.async.} =
    #Call getMnemonic and store the result.
    var res: JSONNode = await personal.parent.call("personal", "getMnemonic")

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"].getStr())

    #Else, return the Mnemonic.
    result = res["result"].getStr()

#Get an address.
proc getAddress*(
    personal: PersonalModule,
    account: int = 0,
    change: bool = false
): Future[string] {.async.} =
    #Call getAddress and store the result.
    var res: JSONNode = await personal.parent.call("personal", "getAddress", %* [
        account,
        change
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"].getStr())

    #Else, return the address.
    result = res["result"].getStr()

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
        raise newException(MerosError, res["error"]["message"].getStr())

    #Else, return the hash.
    result = res["hash"].getStr().parseHexStr()

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
        raise newException(MerosError, res["error"]["message"].getStr())

    #Else, return the hash.
    result = res["hash"].getStr().parseHexStr()

#Convert a public key to an address.
proc toAddress(
    personal: PersonalModule,
    data: string
): Future[string] {.async.} =
    #Call toAddress.
    var res: JSONNode = await personal.parent.call("personal", "toAddress", %* [
        data.toHex()
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(MerosError, res["error"]["message"].getStr())

    #Else, return the address.
    result = res.getStr()
