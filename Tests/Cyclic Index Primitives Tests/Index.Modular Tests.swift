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
import Tagged_Primitives_Test_Support

@Suite("Index.Modular Operations (Dynamic)")
struct IndexModularOperationsTests {

    // MARK: - Successor

    @Test
    func `successor without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(2))
        let next = Index<Int>.Modular.successor(of: index, capacity: capacity)
        #expect(next.position == Ordinal(3))
    }

    @Test
    func `successor with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(4))
        let next = Index<Int>.Modular.successor(of: index, capacity: capacity)
        #expect(next.position == Ordinal(0))
    }

    // MARK: - Predecessor

    @Test
    func `predecessor without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(3))
        let prev = Index<Int>.Modular.predecessor(of: index, capacity: capacity)
        #expect(prev.position == Ordinal(2))
    }

    @Test
    func `predecessor with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(0))
        let prev = Index<Int>.Modular.predecessor(of: index, capacity: capacity)
        #expect(prev.position == Ordinal(4))
    }

    // MARK: - Advanced

    @Test
    func `advanced positive offset without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(10))
        let index = Index<Int>(Ordinal(2))
        let offset = Index<Int>.Offset(3)
        let result = Index<Int>.Modular.advanced(index, by: offset, capacity: capacity)
        #expect(result.position == Ordinal(5))
    }

    @Test
    func `advanced positive offset with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(3))
        let offset = Index<Int>.Offset(4)
        let result = Index<Int>.Modular.advanced(index, by: offset, capacity: capacity)
        #expect(result.position == Ordinal(2))  // (3 + 4) mod 5 = 2
    }

    @Test
    func `advanced negative offset without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(10))
        let index = Index<Int>(Ordinal(5))
        let offset = Index<Int>.Offset(-2)
        let result = Index<Int>.Modular.advanced(index, by: offset, capacity: capacity)
        #expect(result.position == Ordinal(3))
    }

    @Test
    func `advanced negative offset with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(1))
        let offset = Index<Int>.Offset(-3)
        let result = Index<Int>.Modular.advanced(index, by: offset, capacity: capacity)
        #expect(result.position == Ordinal(3))  // (1 - 3 + 5) mod 5 = 3
    }

    // MARK: - Physical Index

    @Test
    func `physical index without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(10))
        let head = Index<Int>(Ordinal(2))
        let logical = Index<Int>(Ordinal(3))
        let physical = Index<Int>.Modular.physical(forLogical: logical, head: head, capacity: capacity)
        #expect(physical.position == Ordinal(5))  // 2 + 3 = 5
    }

    @Test
    func `physical index with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let head = Index<Int>(Ordinal(3))
        let logical = Index<Int>(Ordinal(4))
        let physical = Index<Int>.Modular.physical(forLogical: logical, head: head, capacity: capacity)
        #expect(physical.position == Ordinal(2))  // (3 + 4) mod 5 = 2
    }

    // MARK: - Ring Buffer Simulation

    @Test
    func `ring buffer simulation`() {
        let capacity = Index<Int>.Count(Cardinal(4))
        var head = Index<Int>(Ordinal(0))
        var tail = Index<Int>(Ordinal(0))

        // Enqueue 3 elements
        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)  // 1
        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)  // 2
        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)  // 3

        #expect(head.position == Ordinal(0))
        #expect(tail.position == Ordinal(3))

        // Dequeue 1 element
        head = Index<Int>.Modular.successor(of: head, capacity: capacity)  // 1

        #expect(head.position == Ordinal(1))

        // Enqueue 2 more (should wrap)
        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)  // 0 (wrap)
        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)  // 1

        #expect(tail.position == Ordinal(1))
    }
}
