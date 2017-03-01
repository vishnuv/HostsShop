//
//  main.swift
//  EBSTest
//
//  Created by Vishnu Vardhan PV on 03/02/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import Foundation
import UIKit

//UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(TIMERUIApplication), NSStringFromClass(AppDelegate))
//UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(TIMERUIApplication), NSStringFromClass(AppDelegate))

//UIApplicationMain(CommandLine.argc, UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: Optional<(UnsafeMutablePointer<Int8> as! UnsafeMutablePointer<Int8> )>.self,capacity: Int(CommandLine.argc)), NSStringFromClass(TIMERUIApplication), NSStringFromClass(AppDelegate))



UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    NSStringFromClass(TIMERUIApplication.self),
    NSStringFromClass(AppDelegate.self)
)
