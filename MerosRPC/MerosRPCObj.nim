#Async standard lib.
import asyncdispatch

#Networking standard lib.
import asyncnet

#String utils standard lib.
import strutils
#Export it for all modules.
export strutils

#JSON standard lib.
import json

type
    MerosError* = object of Exception

    #Module object.
    Module* = ref object of RootObj
        #Ref to the RPC parent.
        parent*: MerosRPC

    #Module Descendants.
    SystemModule*       = ref object of Module
    ConsensusModule*    = ref object of Module
    MeritModule*        = ref object of Module
    TransactionsModule* = ref object of Module
    NetworkModule*      = ref object of Module
    PersonalModule*     = ref object of Module

    #RPC object.
    MerosRPC* = ref object
        #IP/Port.
        ip*:   string
        port*: int

        #Socket.
        socket*: AsyncSocket

        #Modules.
        system*:       SystemModule
        consensus*:    ConsensusModule
        merit*:        MeritModule
        transactions*: TransactionsModule
        network*:      NetworkModule
        personal*:     PersonalModule

#Constructor.
proc newMerosRPC*(
    ip: string = "127.0.0.1",
    port: int = 5133
): Future[MerosRPC] {.async.} =
    #Set the IP/Port and create a Socket.
    result = MerosRPC(
        ip: ip,
        port: port,
        socket: newAsyncSocket()
    )

    #Set up the modules.
    result.system = SystemModule(
        parent: result
    )
    result.merit = MeritModule(
        parent: result
    )
    result.consensus = ConsensusModule(
        parent: result
    )
    result.transactions = TransactionsModule(
        parent: result
    )
    result.network = NetworkModule(
        parent: result
    )
    result.personal = PersonalModule(
        parent: result
    )

    #Connect.
    await result.socket.connect(ip, Port(port))

#Call.
proc call*(
    rpc: MerosRPC,
    module: string,
    methodName: string,
    args: JSONNode = %* []
): Future[JSONNode] {.async.} =
    #Send the data.
    await rpc.socket.send($ %* {
        "jsonrpc": "2.0",
        "id": 0,
        "method": module & "_" & methodName,
        "params": args
    })

    #Get the response back.
    var
        #Response.
        res: string
        #Counter used to track if the response is complete.
        counter: int = 0
    while true:
        res &= await rpc.socket.recv(1)
        if res[^1] == res[0]:
            inc(counter)
        elif (res[^1] == ']') and (res[0] == '['):
            dec(counter)
        elif (res[^1] == '}') and (res[0] == '{'):
            dec(counter)
        if counter == 0:
            break

    #Return the response.
    result = parseJSON(res)

#Disconnect.
proc disconnect*(
    rpc: MerosRPC
) =
    rpc.socket.close()
