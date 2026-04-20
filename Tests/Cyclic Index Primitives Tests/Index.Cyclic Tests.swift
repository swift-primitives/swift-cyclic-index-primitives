// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Testing
@testable import Cyclic_Index_Primitives
import Cyclic_Index_Primitives_Test_Support

// MARK: - Cyclic Test Suites

@Suite("Index.Cyclic")
struct IndexCyclicTests {
    @Suite struct Construction {}
    @Suite struct Arithmetic {}
    @Suite struct Conformances {}
    @Suite struct EdgeCase {}
}

// MARK: - Construction Tests

extension IndexCyclicTests.Construction {
    @Test
    func `init with valid position returns index`() throws {
        let index = try Index<Int>.Cyclic<5>.init(3)
        #expect(index == 3)
    }

    @Test
    func `init with zero returns index`() throws {
        let index = try Index<Int>.Cyclic<10>.init(0)
        #expect(index == 0)
    }

    @Test
    func `init with max valid position returns index`() throws {
        let index = try Index<Int>.Cyclic<5>.init(4)  // N-1
        #expect(index == 4)
    }

    @Test
    func `unchecked init bypasses validation`() {
        let index = Index<Int>.Cyclic<5>.init(__unchecked: 3)
        #expect(index == 3)
    }

    @Test
    func `init with negative position throws error`() {
        #expect(throws: Cyclic.Group.Static<5>.Element.Error.outOfBounds(-1)) {
            _ = try Index<Int>.Cyclic<5>.init(-1)
        }
    }

    @Test
    func `init at bound N throws error`() {
        #expect(throws: Cyclic.Group.Static<5>.Element.Error.outOfBounds(5)) {
            _ = try Index<Int>.Cyclic<5>.init(5)
        }
    }

    @Test
    func `init beyond bound throws error`() {
        #expect(throws: Cyclic.Group.Static<5>.Element.Error.outOfBounds(100)) {
            _ = try Index<Int>.Cyclic<5>.init(100)
        }
    }
}

// MARK: - Arithmetic Tests

extension IndexCyclicTests.Arithmetic {
    @Test
    func `addition of two cyclic indices`() throws {
        let a = try Index<Int>.Cyclic<10>.init(3)
        let b = try Index<Int>.Cyclic<10>.init(4)
        let result = a + b
        #expect(result == 7)
    }

    @Test
    func `subtraction of two cyclic indices`() throws {
        let a = try Index<Int>.Cyclic<10>.init(7)
        let b = try Index<Int>.Cyclic<10>.init(3)
        let result = a - b
        #expect(result == 4)
    }

    @Test
    func `compound addition assignment`() throws {
        var index = try Index<Int>.Cyclic<10>.init(3)
        let addend = try Index<Int>.Cyclic<10>.init(2)
        index += addend
        #expect(index == 5)
    }

    @Test
    func `compound subtraction assignment`() throws {
        var index = try Index<Int>.Cyclic<10>.init(5)
        let subtrahend = try Index<Int>.Cyclic<10>.init(2)
        index -= subtrahend
        #expect(index == 3)
    }

    @Test
    func `addition with .one element`() throws {
        let index = try Index<Int>.Cyclic<10>.init(3)
        let result = index + .one
        #expect(result == 4)
    }

    @Test
    func `subtraction with .one element`() throws {
        let index = try Index<Int>.Cyclic<10>.init(3)
        let result = index - .one
        #expect(result == 2)
    }

    @Test
    func `addition with .zero element`() throws {
        let index = try Index<Int>.Cyclic<10>.init(5)
        let result = index + .zero
        #expect(result == 5)
    }

    @Test
    func `compound addition with element`() throws {
        var index = try Index<Int>.Cyclic<10>.init(3)
        index += .one
        #expect(index == 4)
    }

    @Test
    func `compound subtraction with element`() throws {
        var index = try Index<Int>.Cyclic<10>.init(3)
        index -= .one
        #expect(index == 2)
    }

    @Test
    func `cyclic addition wraps at bound`() throws {
        let index = try Index<Int>.Cyclic<5>.init(4)  // N-1
        let result = index + .one
        #expect(result == 0)  // Wraps to 0
    }

    @Test
    func `cyclic subtraction wraps at zero`() throws {
        let index = try Index<Int>.Cyclic<5>.init(0)
        let result = index - .one
        #expect(result == 4)  // Wraps to N-1
    }

    @Test
    func `multiple wrap-arounds`() throws {
        var index = try Index<Int>.Cyclic<3>.init(0)
        index += .one  // 1
        index += .one  // 2
        index += .one  // 0 (wrap)
        index += .one  // 1
        #expect(index == 1)
    }
}

// MARK: - Conformance Tests

extension IndexCyclicTests.Conformances {
    @Test
    func `cyclic indices are equatable`() throws {
        let a = try Index<Int>.Cyclic<5>.init(3)
        let b = try Index<Int>.Cyclic<5>.init(3)
        let c = try Index<Int>.Cyclic<5>.init(4)
        #expect(a == b)
        #expect(a != c)
    }

    @Test
    func `cyclic indices are comparable`() throws {
        let a = try Index<Int>.Cyclic<10>.init(2)
        let b = try Index<Int>.Cyclic<10>.init(7)
        #expect(a < b)
        #expect(b > a)
        #expect(a <= b)
        #expect(b >= a)
    }

    @Test
    func `cyclic indices are hashable`() throws {
        let a = try Index<Int>.Cyclic<5>.init(3)
        let b = try Index<Int>.Cyclic<5>.init(3)
        #expect(a.hashValue == b.hashValue)
    }

    @Test
    func `cyclic indices can be used in sets`() throws {
        let a = try Index<Int>.Cyclic<5>.init(1)
        let b = try Index<Int>.Cyclic<5>.init(2)
        let c = try Index<Int>.Cyclic<5>.init(1)
        let set: Set = [a, b, c]
        #expect(set.count == 2)
    }

    @Test
    func `cyclic indices can be used as dictionary keys`() throws {
        let key = try Index<Int>.Cyclic<5>.init(3)
        var dict: [Index<Int>.Cyclic<5>: String] = [:]
        dict[key] = "value"
        #expect(dict[key] == "value")
    }
}

// MARK: - Edge Case Tests

extension IndexCyclicTests.EdgeCase {
    @Test
    func `single element cyclic space`() throws {
        let index = try Index<Int>.Cyclic<1>.init(0)
        let incremented = index + .one
        #expect(incremented == 0)  // Wraps back to 0

        let decremented = index - .one
        #expect(decremented == 0)  // Wraps back to 0
    }

    @Test
    func `different phantom types are incompatible`() throws {
        enum TagA {}
        enum TagB {}

        let a = try Index<TagA>.Cyclic<5>.init(3)
        let b = try Index<TagB>.Cyclic<5>.init(3)

        // Both equal 3, but different types prevent direct comparison
        #expect(a == 3)
        #expect(b == 3)
        #expect(type(of: a) != type(of: b))

        // Cannot compare a == b due to different types (compile-time safety)
    }

    @Test
    func `rawValue access returns cyclic element`() throws {
        let index = try Index<Int>.Cyclic<5>.init(3)
        let element: Cyclic.Group.Static<5>.Element = index.rawValue
        #expect(element == 3)
    }

    @Test
    func `CyclicIndexError is Hashable`() {
        let error1 = Cyclic.Group.Static<5>.Element.Error.outOfBounds(10)
        let error2 = Cyclic.Group.Static<5>.Element.Error.outOfBounds(10)
        let error3 = Cyclic.Group.Static<5>.Element.Error.outOfBounds(20)
        #expect(error1 == error2)
        #expect(error1 != error3)
    }

    @Test
    func `CyclicIndexError is Sendable`() async {
        let error = Cyclic.Group.Static<5>.Element.Error.outOfBounds(10)
        await Task {
            #expect(error == Cyclic.Group.Static<5>.Element.Error.outOfBounds(10))
        }.value
    }
}
