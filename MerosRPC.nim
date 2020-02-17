#Async standard lib.
import asyncdispatch

#Networking standard lib.
import asyncnet

#String utils standard lib.
import strutils

#JSON standard lib.
import json

#Macros standard lib.
import macros

type
    #Exception used for when the Meros RPC returns an error.
    MerosError* = object of Exception
        code: int

    #Module objects.
    Module* = ref object of RootObj
        parent*: MerosRPC

    SystemModule*       = ref object of Module
    MeritModule*        = ref object of Module
    ConsensusModule*    = ref object of Module
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
        merit*:        MeritModule
        consensus*:    ConsensusModule
        transactions*: TransactionsModule
        network*:      NetworkModule
        personal*:     PersonalModule

#Constructors.
func newMerosError(
    code: int,
    msg: string
): ref MerosError =
    result = newException(MerosError, msg)
    result.code = code

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

#Call an RPC method.
proc call*(
    rpc: MerosRPC,
    module: string,
    methodName: string,
    args: JSONNode = %* []
): Future[JSONNode] {.async.} =
    #Send the request.
    await rpc.socket.send($ %* {
        "jsonrpc": "2.0",
        "id": 0,
        "method": module & "_" & methodName,
        "params": args
    })

    #Get the response back.
    var
        #Counter used to track if the response is complete.
        counter: int = 0
        res: string
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

    #If it has an error, raise it.
    if result.hasKey("error"):
        raise newMerosError(result["error"]["code"].getInt(), result["error"]["msg"].getStr())

#Route macro which automatically expands every below definition to a proper function.
macro route(
    moduleType: typedesc,
    moduleStr: string,
    functions: untyped
): untyped =
    result = newStmtList()

    var f: int = 0
    while f < functions.len:
        var
            function: NimNode = functions[f]
            params: seq[NimNode] = @[
                newNimNode(nnkBracketExpr).add(ident("Future"), function[^1][0]),
                newIdentDefs(ident("module"), ident(moduleType.strVal))
            ]
            args: NimNode = newNimNode(nnkBracket)
            body: NimNode = newStmtList()

        for p in 1 ..< function.len - 1:
            if function[p].kind == nnkPrefix:
                function[p] = function[p][1]
                functions.add(functions[f])
                break
            elif function[p].kind == nnkIdent:
                params.add(
                    newIdentDefs(ident("arg" & $(p - 1)), function[p])
                )
                args.add(ident("arg" & $(p - 1)))

                if function[p].strVal == "string":
                    args[^1] = newCall(ident("toHex"), args[^1])
            else:
                doAssert(false, "Unknown route definition.")

        body.add(
            newVarStmt(
                newNimNode(nnkPragmaExpr).add(
                    ident("res"),
                    newNimNode(nnkPragma).add(
                        newNimNode(nnkExprColonExpr).add(
                            newNimNode(nnkBracketExpr).add(
                                ident("hint"), ident("XDeclaredButNotUsed")
                            ),
                            ident("off")
                        )
                    )
                ),
                newNimNode(nnkBracketExpr).add(
                    newNimNode(nnkCommand).add(
                        ident("await"),
                        newCall(
                            ident("call"),
                            newDotExpr(ident("module"), ident("parent")),
                            newStrLitNode(moduleStr.strVal),
                            newStrLitNode(function[0].strVal),
                            prefix(args, "%*")
                        )
                    ),
                    newStrLitNode("result")
                )
            ),
            newNimNode(nnkReturnStmt).add(ident("res"))
        )

        case function[^1][0].strVal:
            of "void":
                body.del(body.len - 1)
            of "int":
                body[^1][0] = newCall(ident("getInt"), body[^1][0])
            of "string":
                body[^1][0] = newCall(
                    ident("parseHexStr"),
                    newCall(ident("getStr"), body[^1][0])
                )
            of "JSONNode":
                discard
            else:
                doAssert(false, "Unknown route result type.")

        result.add(newProc(
            postfix(function[0], "*"),
            params,
            body,
            nnkProcDef,
            newNimNode(nnkPragma).add(ident("async"))
        ))
        inc(f)

#System module.
route SystemModule, "system":
    quit(): void

#Merit module.
route MeritModule, "merit":
    getHeight(): int
    getDifficulty(): string
    getBlock(string): JSONNode

    getTotalMerit(): int
    getUnlockedMerit(): int
    getMerit(int): JSONNode

    getBlockTemplate(string): JSONNode
    publishBlock(int, string): void

#Consensus module.
route ConsensusModule, "consensus":
    getSendDifficulty(): string
    getDataDifficulty(): string

    getStatus(string): JSONNode

#Transactions module.
route TransactionsModule, "transactions":
    getTransaction(string): JSONNode
    getBalance(string): string

#Network module.
route NetworkModule, "network":
    connect(string, ?int): void
    getPeers(): JSONNode

#Personal module.
route PersonalModule, "personal":
    getMiner(): string

    setMnemonic(?string, ?string): void
    getMnemonic(): string

    send(string, string): string
    data(string): string

    toAddress(string): string

#Disconnect.
proc disconnect*(
    rpc: MerosRPC
) =
    rpc.socket.close()
