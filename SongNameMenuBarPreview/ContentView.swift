//
//  ContentView.swift
//  SongNameMenuBarPreview
//
//  Created by Ani Mehta on 24/8/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text(getNowPlayingInfo()).padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

let script = """
tell application "Spotify"
    set cstate to current track's artist & " - " & current track's name
    return cstate
end tell
"""

let stringLengthLimit = 60

func getNowPlayingInfo() -> String {
    if let scriptObject = NSAppleScript(source: script) {
        var error: NSDictionary?
        let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
        if (error != nil) {
            print("error: \(String(describing:error))")
            return "Ran into error"
        } else {
            let value = output.stringValue ?? "Not found"
            let valueCount = value.count

            return valueCount <= stringLengthLimit ? value :
                "\(value.dropLast(valueCount-stringLengthLimit))..."
        }
    }
    
    return "?" // why would this happen, I wouldn't know. Anyway.
}
