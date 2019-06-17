#RPC object.
import ../MerosRPCObj

#Async standard lib.
import asyncdispatch

#JSON standard lib.
import JSON

#Get a Transaction by its hash.
proc getTransaction*(
    transactions: TransactionsModule,
    hash: string
): Future[JSONNode] {.async.} =
    #Call getTransaction and store it in the result.
    result = await transactions.parent.call("transactions", "getTransaction", %* [
        hash
    ])

    #If there was an error, raise it.
    if result.hasKey("error"):
        raise newException(MerosError, result["error"].getStr())
