#RPC object.
import ../MerosRPCObj

#Async standard lib.
import asyncdispatch

#JSON standard lib.
import JSON

#Get a verification.
proc getVerification*(
    verifs: VerificationsModule,
    key: string,
    nonce: int
): Future[JSONNode] {.async.} =
    #Call getVerification and store it in the result.
    result = await verifs.parent.call("verifications", "getVerification", %* [
        key,
        nonce
    ])

    #If there was an error, raise it.
    if result.kind == JObject:
        if result.hasKey("error"):
            raise newException(MerosError, result["error"].getStr())

#Get unarchived verifications.
proc getUnarchivedVerifications*(
    verifs: VerificationsModule
): Future[JSONNode] {.async.} =
    #Call getUnarchivedVerifications and store it in the result.
    result = await verifs.parent.call("verifications", "getUnarchivedVerifications")

    #If there was an error, raise it.
    if result.kind == JObject:
        if result.hasKey("error"):
            raise newException(MerosError, result["error"].getStr())
