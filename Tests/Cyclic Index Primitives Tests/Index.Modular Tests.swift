import Tagged_Primitives_Test_Support
import Testing

@testable import Cyclic_Index_Primitives

@Suite
struct `Index Modular Operations Dynamic Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Index Modular Operations Dynamic Tests`.Unit {
    @Test
    func `successor without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(2))
        let next = Index<Int>.Modular.successor(of: index, capacity: capacity)

        #expect(next.position == Ordinal(3))
    }

    @Test
    func `predecessor without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(3))
        let prev = Index<Int>.Modular.predecessor(of: index, capacity: capacity)

        #expect(prev.position == Ordinal(2))
    }

    @Test
    func `advanced positive offset without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(10))
        let index = Index<Int>(Ordinal(2))
        let offset = Index<Int>.Offset(3)
        let result = Index<Int>.Modular.advanced(index, by: offset, capacity: capacity)

        #expect(result.position == Ordinal(5))
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
    func `physical index without wrap`() {
        let capacity = Index<Int>.Count(Cardinal(10))
        let head = Index<Int>(Ordinal(2))
        let logical = Index<Int>(Ordinal(3))
        let physical = Index<Int>.Modular.physical(
            forLogical: logical,
            head: head,
            capacity: capacity
        )

        #expect(physical.position == Ordinal(5))
    }
}

extension `Index Modular Operations Dynamic Tests`.`Edge Case` {
    @Test
    func `successor with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(4))
        let next = Index<Int>.Modular.successor(of: index, capacity: capacity)

        #expect(next.position == Ordinal(0))
    }

    @Test
    func `predecessor with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(0))
        let prev = Index<Int>.Modular.predecessor(of: index, capacity: capacity)

        #expect(prev.position == Ordinal(4))
    }

    @Test
    func `advanced positive offset with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(3))
        let offset = Index<Int>.Offset(4)
        let result = Index<Int>.Modular.advanced(index, by: offset, capacity: capacity)

        #expect(result.position == Ordinal(2))
    }

    @Test
    func `advanced negative offset with wrap`() {
        let capacity = Index<Int>.Count(Cardinal(5))
        let index = Index<Int>(Ordinal(1))
        let offset = Index<Int>.Offset(-3)
        let result = Index<Int>.Modular.advanced(index, by: offset, capacity: capacity)

        #expect(result.position == Ordinal(3))
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

        #expect(physical.position == Ordinal(2))
    }
}

extension `Index Modular Operations Dynamic Tests`.Integration {
    @Test
    func `ring buffer simulation`() {
        let capacity = Index<Int>.Count(Cardinal(4))
        var head = Index<Int>(Ordinal(0))
        var tail = Index<Int>(Ordinal(0))

        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)
        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)
        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)

        #expect(head.position == Ordinal(0))

        #expect(tail.position == Ordinal(3))

        head = Index<Int>.Modular.successor(of: head, capacity: capacity)

        #expect(head.position == Ordinal(1))

        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)
        tail = Index<Int>.Modular.successor(of: tail, capacity: capacity)

        #expect(tail.position == Ordinal(1))
    }
}
