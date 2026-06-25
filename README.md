# Cyclic Index Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Phantom-typed cyclic index types for Swift — modular (wrap-around) arithmetic over `Index<Tag>`, with both compile-time and runtime moduli, and zero platform dependencies.

---

## Quick Start

This package layers cyclic (modulo-N) arithmetic onto the typed `Index<Tag>` from `Index Primitives`. It offers two flavours: `Index<Tag>.Cyclic<N>` when the modulus is known at compile time, and `Index<Tag>.Modular` operations when the capacity is only known at runtime.

```swift
import Cyclic_Index_Primitives

// Compile-time modulus: a cyclic index over 0..<5.
var idx = try Index<MyTag>.Cyclic<5>.init(4)
idx += .one        // Wraps to 0
idx -= .one        // Wraps to 4

let a = try Index<MyTag>.Cyclic<10>.init(7)
let b = try Index<MyTag>.Cyclic<10>.init(3)
let sum = a + b    // 0 (cyclic group element)

// Runtime capacity: ring-buffer navigation over Index<Tag>.
let capacity = Index<MyTag>.Count(Cardinal(5))
var head = Index<MyTag>(Ordinal(4))
head = Index<MyTag>.Modular.successor(of: head, capacity: capacity)   // wraps 4 -> 0

// Logical-to-physical index mapping in a ring buffer.
let physical = Index<MyTag>.Modular.physical(
    forLogical: Index<MyTag>(Ordinal(4)),
    head: Index<MyTag>(Ordinal(3)),
    capacity: capacity
)                                                                    // (3 + 4) mod 5 = 2
```

`Cyclic<N>` is a typealias for `Tagged<Tag, Cyclic.Group.Static<N>.Element>`, so two indices with different `Tag`s never compare or combine — wrap-around safety and phantom-type safety in one value. The `Modular` namespace provides `successor`, `predecessor`, `advanced(_:by:)`, and `physical(forLogical:head:)` for the dynamic-capacity case, all O(1).

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-cyclic-index-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Cyclic Index Primitives", package: "swift-cyclic-index-primitives"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Two library products, layered over `swift-index-primitives` and `swift-cyclic-primitives`.

| Product | Target | Purpose |
|---------|--------|---------|
| `Cyclic Index Primitives` | `Sources/Cyclic Index Primitives/` | `Index<Tag>.Cyclic<N>` (compile-time modulus) with `+`/`-`/`+=`/`-=`, plus the `Index<Tag>.Modular` namespace (runtime capacity) for ring-buffer navigation. |
| `Cyclic Index Primitives Test Support` | `Tests/Support/` | Re-exports the main target and its underlying test-support modules for test consumers. |

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |
| Swift Embedded | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
