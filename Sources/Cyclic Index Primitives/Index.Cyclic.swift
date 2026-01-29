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

import Cyclic_Primitives

// MARK: - Typealias

extension Tagged where RawValue == Ordinal, Tag: ~Copyable {
    /// `Index<Tag>.Cyclic<N>` = `Tagged<Tag, Cyclic.Group<N>.Element>`
    ///
    /// A cyclic index where arithmetic wraps modulo N.
    /// Use this for ring buffer indices, circular navigation, and other
    /// bounded cyclic access patterns.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var idx = try Index<MyTag>.Cyclic<5>.init(4)
    /// idx += .one  // Wraps to 0
    /// idx -= .one  // Wraps to 4
    /// ```
    public typealias Cyclic<let N: Int> = Tagged<Tag, Cyclic_Primitives.Cyclic.Group<N>.Element>
}

// MARK: - Operators (Tagged + Tagged)

public func + <Tag: ~Copyable, let N: Int>(
    lhs: Tagged<Tag, Cyclic.Group<N>.Element>,
    rhs: Tagged<Tag, Cyclic.Group<N>.Element>
) -> Tagged<Tag, Cyclic.Group<N>.Element> {
    Tagged(__unchecked: (), lhs.rawValue + rhs.rawValue)
}

public func - <Tag: ~Copyable, let N: Int>(
    lhs: Tagged<Tag, Cyclic.Group<N>.Element>,
    rhs: Tagged<Tag, Cyclic.Group<N>.Element>
) -> Tagged<Tag, Cyclic.Group<N>.Element> {
    Tagged(__unchecked: (), lhs.rawValue - rhs.rawValue)
}

public func += <Tag: ~Copyable, let N: Int>(
    lhs: inout Tagged<Tag, Cyclic.Group<N>.Element>,
    rhs: Tagged<Tag, Cyclic.Group<N>.Element>
) { lhs = lhs + rhs }

public func -= <Tag: ~Copyable, let N: Int>(
    lhs: inout Tagged<Tag, Cyclic.Group<N>.Element>,
    rhs: Tagged<Tag, Cyclic.Group<N>.Element>
) { lhs = lhs - rhs }

// MARK: - Operators (Tagged + Element) — enables .zero/.one syntax

public func + <Tag: ~Copyable, let N: Int>(
    lhs: Tagged<Tag, Cyclic.Group<N>.Element>,
    rhs: Cyclic.Group<N>.Element
) -> Tagged<Tag, Cyclic.Group<N>.Element> {
    Tagged(__unchecked: (), lhs.rawValue + rhs)
}

public func - <Tag: ~Copyable, let N: Int>(
    lhs: Tagged<Tag, Cyclic.Group<N>.Element>,
    rhs: Cyclic.Group<N>.Element
) -> Tagged<Tag, Cyclic.Group<N>.Element> {
    Tagged(__unchecked: (), lhs.rawValue - rhs)
}

public func += <Tag: ~Copyable, let N: Int>(
    lhs: inout Tagged<Tag, Cyclic.Group<N>.Element>,
    rhs: Cyclic.Group<N>.Element
) { lhs = Tagged(__unchecked: (), lhs.rawValue + rhs) }

public func -= <Tag: ~Copyable, let N: Int>(
    lhs: inout Tagged<Tag, Cyclic.Group<N>.Element>,
    rhs: Cyclic.Group<N>.Element
) { lhs = Tagged(__unchecked: (), lhs.rawValue - rhs) }

// MARK: - Construction

extension Tagged where Tag: ~Copyable {
    /// Creates a cyclic index from an integer position.
    ///
    /// - Parameter position: The position value (must be in `0..<N`).
    /// - Throws: `Cyclic.Group.Element<N>.outOfBounds` if position is invalid.
    public init<let N: Int>(_ position: Int) throws(Cyclic_Primitives.Cyclic.Group<N>.Element.Error)
    where RawValue == Cyclic_Primitives.Cyclic.Group<N>.Element {
        do {
            self.init(__unchecked: (), try Cyclic_Primitives.Cyclic.Group<N>.Element(position))
        } catch {
            throw .outOfBounds(position)
        }
    }

    /// Creates a cyclic index without bounds checking.
    ///
    /// - Parameter position: Must be in `0..<N`.
    /// - Warning: No validation is performed. Use only when the value
    ///   is known to be in bounds.
    public init<let N: Int>(__unchecked position: Int)
    where RawValue == Cyclic_Primitives.Cyclic.Group<N>.Element {
        self.init(__unchecked: (), Cyclic_Primitives.Cyclic.Group<N>.Element(__unchecked: (), position))
    }
}
