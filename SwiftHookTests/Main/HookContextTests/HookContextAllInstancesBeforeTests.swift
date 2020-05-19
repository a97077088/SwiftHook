//
//  HookContextAllInstancesBeforeTests.swift
//  SwiftHookTests
//
//  Created by Yanni Wang on 10/5/20.
//  Copyright © 2020 Yanni. All rights reserved.
//

import XCTest
@testable import SwiftHook

class HookContextAllInstancesBeforeTests: XCTestCase {
        
    func testNormal() {
        do {
            let contextCount = HookManager.shared.debugGetNormalClassHookContextsCount()
            let test = TestObject()
            var result = [Int]()
            
            try autoreleasepool {
                // hook
                let targetClass = TestObject.self
                let selector = #selector(TestObject.execute(closure:))
                let mode: HookMode = .before
                let closure = {
                    XCTAssertEqual(result, [])
                    result.append(1)
                    } as @convention(block) () -> Void
                let token = try HookManager.shared.hook(targetClass: targetClass, selector: selector, mode: mode, hookClosure: closure as AnyObject)
                XCTAssertEqual(HookManager.shared.debugGetNormalClassHookContextsCount(), contextCount + 1)
                
                // test hook
                XCTAssertEqual(result, [])
                test.execute {
                    XCTAssertEqual(result, [1])
                    result.append(2)
                }
                XCTAssertEqual(result, [1, 2])
                
                // cancel
                
                XCTAssertTrue(HookManager.shared.cancelHook(token: token)!)
                result.removeAll()
            }
            
            // test cancel
            test.execute {
                XCTAssertEqual(result, [])
                result.append(2)
            }
            XCTAssertEqual(result, [2])
            XCTAssertEqual(HookManager.shared.debugGetNormalClassHookContextsCount(), contextCount)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testCheckArguments() {
        do {
            let contextCount = HookManager.shared.debugGetNormalClassHookContextsCount()
            let test = TestObject()
            let argumentA = 77
            let argumentB = 88
            var executed = false
            
            try autoreleasepool {
                // hook
                let targetClass = TestObject.self
                let selector = #selector(TestObject.sumFunc(a:b:))
                let mode: HookMode = .before
                let closure = { a, b in
                    XCTAssertEqual(argumentA, a)
                    XCTAssertEqual(argumentB, b)
                    executed = true
                    } as @convention(block) (Int, Int) -> Void
                let token = try HookManager.shared.hook(targetClass: targetClass, selector: selector, mode: mode, hookClosure: closure as AnyObject)
                XCTAssertEqual(HookManager.shared.debugGetNormalClassHookContextsCount(), contextCount + 1)
                
                // test hook
                let result = test.sumFunc(a: argumentA, b: argumentB)
                XCTAssertEqual(result, argumentA + argumentB)
                XCTAssertTrue(executed)
                
                // cancel
                XCTAssertTrue(HookManager.shared.cancelHook(token: token)!)
            }
            
            // test cancel
            executed = false
            let result = test.sumFunc(a: argumentA, b: argumentB)
            XCTAssertEqual(result, argumentA + argumentB)
            XCTAssertFalse(executed)
            XCTAssertEqual(HookManager.shared.debugGetNormalClassHookContextsCount(), contextCount)
        } catch {
            XCTAssertNil(error)
        }
    }
    
}