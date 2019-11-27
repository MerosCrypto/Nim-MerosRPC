#RPC object.
import ../MerosRPCObj

#Async standard lib.
import asyncdispatch

#JSON standard lib.
import JSON

#Get an Status.
proc getStatus*(
    consensus: ConsensusModule,
    hash: string
): Future[JSONNode] {.async.} =
    #Call getStatus and store it in the result.
    result = await consensus.parent.call("consensus", "getStatus", %* [
        hash.toHex()
    ])

    #If there was an error, raise it.
    if result.hasKey("error"):
        raise newException(MerosError, result["error"].getStr())

    #Return the status.
    result = result["result"]
