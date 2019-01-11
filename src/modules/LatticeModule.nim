#RPC object.
import ../EmberRPCObj

#Async standard lib.
import asyncdispatch

#JSON standard lib.
import JSON

#Get an Account's Height.
proc getHeight*(lattice: LatticeModule, address: string): Future[string] {.async.} =
    #Call getHeight.
    var res: JSONNode = await lattice.parent.call("lattice", "getHeight", %* [
        address
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(EmberError, res["error"].getStr())

    #Else, return the height.
    result = res["height"].getStr()

#Get an Account's Balance.
proc getBalance*(lattice: LatticeModule, address: string): Future[string] {.async.} =
    #Call getBalance.
    var res: JSONNode = await lattice.parent.call("lattice", "getBalance", %* [
        address
    ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(EmberError, res["error"].getStr())

    #Else, return the balance.
    result = res["balance"].getStr()

#Get an Entry by its hash.
proc getEntryByHash*(lattice: LatticeModule, hash: string): Future[JSONNode] {.async.} =
    #Call getEntryByHash and store it in the result.
    result = await lattice.parent.call("lattice", "getEntryByHash", %* [
        hash
    ])

    #If there was an error, raise it.
    if result.hasKey("error"):
        raise newException(EmberError, result["error"].getStr())

#Get an Entry by its index.
proc getEntryByIndex*(lattice: LatticeModule, address: string, nonce: int): Future[JSONNode] {.async.} =
    #Call getEntryByIndex and store it in the result.
    result = await lattice.parent.call("lattice", "getEntryByIndex", %* [
        address,
        nonce
    ])

    #If there was an error, raise it.
    if result.hasKey("error"):
        raise newException(EmberError, result["error"].getStr())
