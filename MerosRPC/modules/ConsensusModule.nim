#RPC object.
import ../MerosRPCObj

#Async standard lib.
import asyncdispatch

#JSON standard lib.
import JSON

#Get an Element.
proc getElement*(
    consensus: ConsensusModule,
    key: string,
    nonce: int
): Future[JSONNode] {.async.} =
    #Call getElement and store it in the result.
    result = await consensus.parent.call("consensus", "getElement", %* [
        key,
        nonce
    ])

    #If there was an error, raise it.
    if result.kind == JObject:
        if result.hasKey("error"):
            raise newException(MerosError, result["error"].getStr())
