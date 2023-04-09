//
//  main.swift
//  ButlerBooter
//
//  Created by Aditya Saravana on 4/8/23.
//

import Foundation
import Cocoa

let delegate = ButlerBooterAppDelegate()
NSApplication.shared.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
