import Foundation

enum State {
    case offHook, connecting, connected, onHold
}

enum Trigger {
    case callDialed, hungUp, callConnected, placedOnHold, takenOffHold, leftMessage
}

let rules = [
    State.offHook: [
        (Trigger.callDialed, State.connecting)
    ],
    State.connecting: [
        (Trigger.hungUp, State.offHook),
        (Trigger.leftMessage, State.connected)
    ],
    State.connected: [
        (Trigger.hungUp, State.offHook),
        (Trigger.leftMessage, State.offHook),
        (Trigger.placedOnHold, State.onHold)
    ],
    State.onHold: [
        (Trigger.takenOffHold, State.connected),
        (Trigger.hungUp, State.offHook)
    ]
]


func mainState() {
    var state = State.offHook
    while true {
        print("The phone is currently \(state)")
        print("Select a trigger:")
        
        for i in 0..<rules[state]!.count {
            let (t, _) = rules[state]![i]
            print("\(i): \(t)")
        }
        
        if let i = Int(readLine() ?? "0") {
            let (_, s) = rules[state]![i]
            state = s
        }
    }
}

mainState()
