import Cyclic_Primitives

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    public typealias Cyclic<let N: Int> = Tagged<
        Tag, Cyclic_Primitives.Cyclic.Group.Static<N>.Element
    >
}

public func + <Tag: ~Copyable & ~Escapable, let N: Int>(
    lhs: Tagged<Tag, Cyclic.Group.Static<N>.Element>,
    rhs: Cyclic.Group.Static<N>.Element
) -> Tagged<Tag, Cyclic.Group.Static<N>.Element> {
    Tagged(_unchecked: lhs.underlying + rhs)
}

public func - <Tag: ~Copyable & ~Escapable, let N: Int>(
    lhs: Tagged<Tag, Cyclic.Group.Static<N>.Element>,
    rhs: Cyclic.Group.Static<N>.Element
) -> Tagged<Tag, Cyclic.Group.Static<N>.Element> {
    Tagged(_unchecked: lhs.underlying - rhs)
}

public func += <Tag: ~Copyable & ~Escapable, let N: Int>(
    lhs: inout Tagged<Tag, Cyclic.Group.Static<N>.Element>,
    rhs: Cyclic.Group.Static<N>.Element
) { lhs = Tagged(_unchecked: lhs.underlying + rhs) }

public func -= <Tag: ~Copyable & ~Escapable, let N: Int>(
    lhs: inout Tagged<Tag, Cyclic.Group.Static<N>.Element>,
    rhs: Cyclic.Group.Static<N>.Element
) { lhs = Tagged(_unchecked: lhs.underlying - rhs) }

extension Tagged where Tag: ~Copyable & ~Escapable {

    public init<let N: Int>(
        _ position: Ordinal
    ) throws(Cyclic_Primitives.Cyclic.Group.Static<N>.Element.Error)
    where Underlying == Cyclic_Primitives.Cyclic.Group.Static<N>.Element {
        self.init(_unchecked: try Cyclic_Primitives.Cyclic.Group.Static<N>.Element(position))
    }

    public init<let N: Int>(__unchecked position: Ordinal)
    where Underlying == Cyclic_Primitives.Cyclic.Group.Static<N>.Element {
        self.init(
            _unchecked: Cyclic_Primitives.Cyclic.Group.Static<N>.Element(__unchecked: position)
        )
    }
}

extension Tagged where Tag: ~Copyable & ~Escapable {

    public init<let N: Int>(
        _ position: Int
    ) throws(Cyclic_Primitives.Cyclic.Group.Static<N>.Element.Error)
    where Underlying == Cyclic_Primitives.Cyclic.Group.Static<N>.Element {
        guard position >= 0 else {
            throw .outOfBounds(position)
        }
        self.init(
            _unchecked: try Cyclic_Primitives.Cyclic.Group.Static<N>.Element(
                Ordinal(UInt(position))
            )
        )
    }

    public init<let N: Int>(__unchecked position: Int)
    where Underlying == Cyclic_Primitives.Cyclic.Group.Static<N>.Element {
        self.init(
            _unchecked: Cyclic_Primitives.Cyclic.Group.Static<N>.Element(
                __unchecked: Ordinal(UInt(position))
            )
        )
    }
}
