#RPC object.
import ../EmberRPCObj

#Async standard lib.
import asyncdispatch

#JSON standard lib.
import JSON

#Connect to a Node.
proc connect*(
    network: NetworkModule,
    ip: string,
    port: int = 0
) {.async.} =
    #Create a var for the response.
    var res: JSONNode

    #Call connect.
    #If we have a port, pass it.
    if port != 0:
        res = await network.parent.call("network", "connect", %* [
            ip,
            port
        ])
    else:
        res = await network.parent.call("network", "connect", %* [
            ip
        ])

    #If there was an error, raise it.
    if res.hasKey("error"):
        raise newException(EmberError, res["error"].getStr())
