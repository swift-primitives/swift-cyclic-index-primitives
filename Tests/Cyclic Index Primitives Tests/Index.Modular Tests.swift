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

import Tagged_Primitives_Test_Support
import Testing

@testable import Cyclic_Index_Primitives

@Suite
struct `Index Modular Operations Dynamic Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

// MARK: - Successor / Predecessor / Advanced / Physical Index

extension `Index Modular Operations Dynamic Tests`.Unit {
    @Test
    func `successor without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(2))
        let next = Index<Int>.Modular.successor(of: index, capacity: capacity)
        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(next.position == Ordinal(3))
    }

    @Test
    func `predecessor without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(3))
        let prev = Index<Int>.Modular.predecessor(of: index, capacity: capacity)
        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(prev.position == Ordinal(2))
    }

    @Test
    func `advanced positive offset without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(10))
        let index = Index<Int>(Ordinal(2))
        let offset = Index<Int>.Offset(3)
        let result = Index<Int>.Modular.advanced(index, by: offset, capacity: capacity)
        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(result.position == Ordinal(5))
    }

    @Test
    func `advanced negative offset without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(10))
        let index = Index<Int>(Ordinal(5))
        let offset = Index<Int>.Offset(-2)
        let result = Index<Int>.Modular.advanced(index, by: offset, capacity: capacity)
        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(result.position == Ordinal(3))
    }

    @Test
    func `physical index without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(10))
        let head = Index<Int>(Ordinal(2))
        let logical = Index<Int>(Ordinal(3))
        let physical = Index<Int>.Modular.physical(
            forLogical: logical,
            head: head,
            capacity: capacity
        )
        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(physical.position == Ordinal(5))  // 2 + 3 = 5
    }
}

// MARK: - Wrap-Around Edge Cases

extension `Index Modular Operations Dynamic Tests`.`Edge Case` {
    @Test
    func `successor with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(4))
        let next = Index<Int>.Modular.successor(of: index, capacity: capacity)
        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(next.position == Ordinal(0))
    }

    @Test
    func `predecessor with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(0))
        let prev = Index<Int>.Modular.predecessor(of: index, capacity: capacity)
        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(prev.position == Ordinal(4))
    }

    @Test
    func `advanced positive offset with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(3))
        let offset = Index<Int>.Offset(4)
        let result = Index<Int>.Modular.advanced(index, by: offset, capacity: capacity)
        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(result.position == Ordinal(2))  // (3 + 4) mod 5 = 2
    }

    @Test
    func `advanced negative offset with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(1))
        let offset = Index<Int>.Offset(-3)
        let result = Index<Int>.Modular.advanced(index, by: offset, capacity: capacity)
        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(result.position == Ordinal(3))  // (1 - 3 + 5) mod 5 = 3
    }

    @Test
    func `physical index with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let head = Index<Int>(Ordinal(3))
        let logical = Index<Int>(Ordinal(4))
        let physical = Index<Int>.Modular.physical(
            forLogical: logical,
            head: head,
            capacity: capacity
        )
        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(physical.position == Ordinal(2))  // (3 + 4) mod 5 = 2
    }
}

// MARK: - Ring Buffer Simulation

extension `Index Modular Operations Dynamic Tests`.Integration {
    @Test
    func `ring buffer simulation`() {
        let capacity = Index<Int>.Count(Cardinal(4))
        var head = Index<Int>(Ordinal(0))
        var tail = Index<Int>(Ordinal(0))

        // Enqueue 3 elements
        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)  // 1
        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)  // 2
        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)  // 3

        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(head.position == Ordinal(0))
        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(tail.position == Ordinal(3))

        // Dequeue 1 element
        head = Index<Int>.Modular.successor(of: head, capacity: capacity)  // 1

        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(head.position == Ordinal(1))

        // Enqueue 2 more (should wrap)
        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)  // 0 (wrap)
        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)  // 1

        // swift-linter:disable:next raw value access
        // REASON: same-package test asserting the type's own boundary-computed position [CONV-001].
        #expect(tail.position == Ordinal(1))
    }
}
