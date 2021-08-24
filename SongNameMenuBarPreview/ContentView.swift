//
//  ContentView.swift
//  SongNameMenuBarPreview
//
//  Created by Ani Mehta on 24/8/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text(nowPlaying()).padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func nowPlaying() -> String {
    let script = """
    tell application "Spotify"
        set cstate to current track's name & " - " & current track's artist
        return cstate
    end tell
    """

    if let scriptObject = NSAppleScript(source: script) {
        var error: NSDictionary?
        let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
        if (error != nil) {
            print("xsc error: \(String(describing:error))")
            return "Ran into error"
        } else {
            let value = output.stringValue ?? "Not found"
            print(value)
            return value
        }
    }

    return "Nothing found?"
}
