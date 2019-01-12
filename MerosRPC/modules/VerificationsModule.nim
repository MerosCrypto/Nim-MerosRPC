#RPC object.
import ../MerosRPCObj

#Async standard lib.
import asyncdispatch

#String utils standard lib.
import strutils

#JSON standard lib.
import JSON

#Get unarchived verifications.
proc getUnarchivedVerifications*(verifs: VerificationsModule): Future[JSONNode] {.async.} =
    #Call getUnarchivedVerifications and store it in the result.
    result = await verifs.parent.call("verifs", "getUnarchivedVerifications")

    #If there was an error, raise it.
    if result.hasKey("error"):
        raise newException(MerosError, result["error"].getStr())
