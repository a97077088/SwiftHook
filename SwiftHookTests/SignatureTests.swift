//
//  SignatureTests.swift
//  SwiftHookTests
//
//  Created by Yanni Wang on 28/4/20.
//  Copyright © 2020 Yanni. All rights reserved.
//

import XCTest
@testable import SwiftHook

let argumentTypesMethodPrefix = ["@", ":"]
let argumentTypesClosurePrefix = ["@?"]

class SignatureTests: XCTestCase {
    
    func testPureSwift() {
        let selector = NSSelectorFromString("swiftMethod")
        let method = class_getInstanceMethod(PureSwift.self, selector)
        XCTAssertNil(method)
    }
    
    func testSwiftMethod() {
        let selector = NSSelectorFromString("swiftMethod")
        let method = class_getInstanceMethod(TestObject.self, selector)
        XCTAssertNil(method)
    }
    
    func testNoDynamicMethod() {
        guard let method = class_getInstanceMethod(TestObject.self, #selector(TestObject.noDynamicMethod)) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureMethod = Signature.init(method: method) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureClosure = Signature.init(closure: {} as @convention(block) () -> Void) else {
            XCTAssertTrue(false)
            return
        }
        
        let argumentTypesExpect: [String] = []
        let returnTypesExpect: String = "v"
        
        XCTAssertEqual(signatureMethod.argumentTypes, argumentTypesMethodPrefix + argumentTypesExpect)
        XCTAssertEqual(signatureMethod.returnType, returnTypesExpect)
        XCTAssertEqual(signatureClosure.argumentTypes, argumentTypesClosurePrefix + argumentTypesExpect)
        XCTAssertEqual(signatureClosure.returnType, returnTypesExpect)
        XCTAssertTrue(signatureMethod.isMatch(other: signatureClosure))
    }
    
    func testNoObjcMethod() {
        let selector = NSSelectorFromString("noObjcMethod")
        let method = class_getInstanceMethod(TestObject.self, selector)
        XCTAssertNil(method)
    }
    
    func testNoArgsNoReturnFunc() {
        guard let method = class_getInstanceMethod(TestObject.self, #selector(TestObject.noArgsNoReturnFunc)) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureMethod = Signature.init(method: method) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureClosure = Signature.init(closure: {} as @convention(block) () -> Void) else {
            XCTAssertTrue(false)
            return
        }
        
        let argumentTypesExpect: [String] = []
        let returnTypesExpect: String = "v"
        
        XCTAssertEqual(signatureMethod.argumentTypes, argumentTypesMethodPrefix + argumentTypesExpect)
        XCTAssertEqual(signatureMethod.returnType, returnTypesExpect)
        XCTAssertEqual(signatureClosure.argumentTypes, argumentTypesClosurePrefix + argumentTypesExpect)
        XCTAssertEqual(signatureClosure.returnType, returnTypesExpect)
        XCTAssertTrue(signatureMethod.isMatch(other: signatureClosure))
    }
    
    func testSimpleSignature() {
        guard let method = class_getInstanceMethod(TestObject.self, #selector(TestObject.testSimpleSignature(char:int:swiftInt:short:long:longlong:unsignedChar:unsignedInt:swiftUnsignedInt:unsignedshort:unsignedLong:unsignedLongLong:float:swiftFloat:double:swiftDouble:bool:swiftBool:characterString:object:class:selector:))) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureMethod = Signature.init(method: method) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureClosure = Signature.init(closure: {_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _  in
            } as @convention(block) (CChar, CInt, Int, CShort, CLong, CLongLong, CUnsignedChar, CUnsignedInt, UInt, CUnsignedShort, CUnsignedLong, CUnsignedLongLong, CFloat, Float, CDouble, Double, CBool, Bool, UnsafePointer<CChar>, AnyObject, AnyClass, Selector) -> Void) else {
                XCTAssertTrue(false)
                return
        }
        
        let argumentTypesExpect: [String] = ["c", "i", "q", "s", "q", "q", "C", "I", "Q", "S", "Q", "Q", "f", "f", "d", "d", "B", "B", "r*", "@", "#", ":"]
        let returnTypesExpect: String = "v"
        
        // If test error here, and you get ["@", ":", "c", "i", "q", "s", "q", "q", "C", "I", "Q", "S", "Q", "Q", "f", "f", "d", "d", "c", "c", "r*", "@", "#", ":"]. please make sure the testing device is iPhone, not Mac.
        XCTAssertEqual(signatureMethod.argumentTypes, argumentTypesMethodPrefix + argumentTypesExpect)
        XCTAssertEqual(signatureMethod.returnType, returnTypesExpect)
        XCTAssertEqual(signatureClosure.argumentTypes, argumentTypesClosurePrefix + argumentTypesExpect)
        XCTAssertEqual(signatureClosure.returnType, returnTypesExpect)
        XCTAssertTrue(signatureMethod.isMatch(other: signatureClosure))
    }
    
    func testStructSignature() {
        guard let method = class_getInstanceMethod(TestObject.self, #selector(TestObject.testStructSignature(point:rect:))) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureMethod = Signature.init(method: method) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureClosure = Signature.init(closure: {_, _ in } as @convention(block) (CGPoint, CGRect) -> Void) else {
            XCTAssertTrue(false)
            return
        }
        
        let argumentTypesExpect: [String] = ["{CGPoint=dd}", "{CGRect={CGPoint=dd}{CGSize=dd}}"]
        let returnTypesExpect: String = "v"
        
        XCTAssertEqual(signatureMethod.argumentTypes, argumentTypesMethodPrefix + argumentTypesExpect)
        XCTAssertEqual(signatureMethod.returnType, returnTypesExpect)
        XCTAssertEqual(signatureClosure.argumentTypes, argumentTypesClosurePrefix + argumentTypesExpect)
        XCTAssertEqual(signatureClosure.returnType, returnTypesExpect)
        XCTAssertTrue(signatureMethod.isMatch(other: signatureClosure))
    }
    
    func testArraySignature() {
        guard let method = class_getInstanceMethod(TestObject.self, #selector(TestObject.testArraySignature(arrayAny:arrayInt:arrayStruct:))) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureMethod = Signature.init(method: method) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureClosure = Signature.init(closure: {_, _, _ in } as @convention(block) ([Any], [Int], [CGRect]) -> Void) else {
            XCTAssertTrue(false)
            return
        }
        
        let argumentTypesExpect: [String] = ["@", "@", "@"]
        let returnTypesExpect: String = "v"
        
        XCTAssertEqual(signatureMethod.argumentTypes, argumentTypesMethodPrefix + argumentTypesExpect)
        XCTAssertEqual(signatureMethod.returnType, returnTypesExpect)
        XCTAssertEqual(signatureClosure.argumentTypes, argumentTypesClosurePrefix + argumentTypesExpect)
        XCTAssertEqual(signatureClosure.returnType, returnTypesExpect)
        XCTAssertTrue(signatureMethod.isMatch(other: signatureClosure))
    }
    
    func testDictionarySignature() {
        guard let method = class_getInstanceMethod(TestObject.self, #selector(TestObject.testDictionarySignature(dictionaryAny:dictionaryInt:dictionaryStruct:))) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureMethod = Signature.init(method: method) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureClosure = Signature.init(closure: {_, _, _ in } as @convention(block) ([String: Any], [String: Int], [String: CGRect]) -> Void) else {
            XCTAssertTrue(false)
            return
        }
        
        let argumentTypesExpect: [String] = ["@", "@", "@"]
        let returnTypesExpect: String = "v"
        
        XCTAssertEqual(signatureMethod.argumentTypes, argumentTypesMethodPrefix + argumentTypesExpect)
        XCTAssertEqual(signatureMethod.returnType, returnTypesExpect)
        XCTAssertEqual(signatureClosure.argumentTypes, argumentTypesClosurePrefix + argumentTypesExpect)
        XCTAssertEqual(signatureClosure.returnType, returnTypesExpect)
        XCTAssertTrue(signatureMethod.isMatch(other: signatureClosure))
    }
    
    func testClosureSignature() {
        guard let method = class_getInstanceMethod(TestObject.self, #selector(TestObject.testClosureSignature(closure1:closure2:closure3:))) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureMethod = Signature.init(method: method) else {
            XCTAssertTrue(false)
            return
        }
        guard let signatureClosure = Signature.init(closure: {_, _, _ in
            return {_, _ in
                return NSObject()
            }
            } as @convention(block) (() -> Void, (Int, AnyObject) -> Int, (Int, AnyObject) -> AnyObject) -> (Int, AnyObject) -> AnyObject) else {
                XCTAssertTrue(false)
                return
        }
        
        let argumentTypesExpect: [String] = ["@?", "@?", "@?"]
        let returnTypesExpect: String = "@?"
        
        XCTAssertEqual(signatureMethod.argumentTypes, argumentTypesMethodPrefix + argumentTypesExpect)
        XCTAssertEqual(signatureMethod.returnType, returnTypesExpect)
        XCTAssertEqual(signatureClosure.argumentTypes, argumentTypesClosurePrefix + argumentTypesExpect)
        XCTAssertEqual(signatureClosure.returnType, returnTypesExpect)
        XCTAssertTrue(signatureMethod.isMatch(other: signatureClosure))
    }
    
    func testMemory() {
//        while true {
//            autoreleasepool {
//                testNoArgsNoReturnFunc()
//                testSimpleSignature()
//                testStructSignature()
//                testClosureSignature()
//            }
//        }
    }
}
