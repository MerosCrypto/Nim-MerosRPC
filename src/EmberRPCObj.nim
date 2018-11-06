#Async standard lib.
import asyncdispatch

#Networking standard lib.
import asyncnet

#JSON standard lib.
import json

type
    EmberError* = object of Exception

    #Module object.
    Module* = ref object of RootObj
        #Ref to the RPC parent.
        parent*: EmberRPC

    #Module Descendants.
    SystemModule*   = ref object of Module
    MeritModule*    = ref object of Module
    LatticeModule*  = ref object of Module
    NetworkModule*  = ref object of Module
    PersonalModule* = ref object of Module

    #RPC object.
    EmberRPC* = ref object of RootObj
        #IP/Port.
        ip*:   string
        port*: int

        #Socket.
        socket*: AsyncSocket

        #Modules.
        system*:   SystemModule
        merit*:    MeritModule
        lattice*:  LatticeModule
        network*:  NetworkModule
        personal*: PersonalModule

#Constructor.
proc newEmberRPC*(
    ip: string = "127.0.0.1",
    port: int = 5133
): EmberRPC =
    #Set the IP/Port and create a Socket.
    result = EmberRPC(
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
    result.lattice = LatticeModule(
        parent: result
    )
    result.network = NetworkModule(
        parent: result
    )
    result.personal = PersonalModule(
        parent: result
    )

    #Connect.
    asyncCheck result.socket.connect(ip, Port(port))

#Call.
proc call*(
    rpc: EmberRPC,
    module: string,
    methodName: string,
    args: JSONNode = %* []
): Future[JSONNode] {.async.} =
    #Create a string for the data.
    var data: string

    #Uglify the JSON.
    toUgly(
        data,
        %* {
            "module": module,
            "method": methodName,
            "args": args
        }
    )

    #Send the data.
    await rpc.socket.send(data & "\r\n")

    #Return the response.
    result = parseJSON(await rpc.socket.recvLine())

#Disconnect.
proc disconnect*(
    rpc: EmberRPC
) =
    rpc.socket.close()
