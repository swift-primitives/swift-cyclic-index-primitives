import Cyclic_Primitives

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    public enum Modular {}
}

extension Tagged.Modular where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    @inlinable
    public static func successor(
        of index: Index<Tag>,
        capacity: Index<Tag>.Count
    ) -> Index<Tag> {
        let modulus = Cyclic_Primitives.Cyclic.Group.Modulus(__unchecked: capacity)
        let element = Cyclic_Primitives.Cyclic.Group.Element(__unchecked: index)
        let result = Cyclic_Primitives.Cyclic.Group.successor(element, modulus: modulus)
        return Index<Tag>(result.residue)
    }

    @inlinable
    public static func predecessor(
        of index: Index<Tag>,
        capacity: Index<Tag>.Count
    ) -> Index<Tag> {
        let modulus = Cyclic_Primitives.Cyclic.Group.Modulus(__unchecked: capacity)
        let element = Cyclic_Primitives.Cyclic.Group.Element(__unchecked: index)
        let result = Cyclic_Primitives.Cyclic.Group.predecessor(element, modulus: modulus)
        return Index<Tag>(result.residue)
    }

    @inlinable
    public static func advanced(
        _ index: Index<Tag>,
        by offset: Index<Tag>.Offset,
        capacity: Index<Tag>.Count
    ) -> Index<Tag> {
        let modulus = Cyclic_Primitives.Cyclic.Group.Modulus(__unchecked: capacity)
        let element = Cyclic_Primitives.Cyclic.Group.Element(__unchecked: index)
        let result = Cyclic_Primitives.Cyclic.Group.advanced(element, by: offset, modulus: modulus)
        return Index<Tag>(result.residue)
    }

    @inlinable
    public static func physical(
        forLogical logicalIndex: Index<Tag>,
        head: Index<Tag>,
        capacity: Index<Tag>.Count
    ) -> Index<Tag> {
        let modulus = Cyclic_Primitives.Cyclic.Group.Modulus(__unchecked: capacity)
        let headElement = Cyclic_Primitives.Cyclic.Group.Element(__unchecked: head)
        let logicalElement = Cyclic_Primitives.Cyclic.Group.Element(__unchecked: logicalIndex)
        let result = Cyclic_Primitives.Cyclic.Group.add(
            headElement,
            logicalElement,
            modulus: modulus
        )
        return Index<Tag>(result.residue)
    }
}
