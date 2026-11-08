# FireMQ for Swift

A Swift client for [FireMQ](https://github.com/FireMQ/firemq), a lean, RabbitMQ-compatible
message broker. It is a binding over FireMQ's Rust client, generated with
[UniFFI](https://mozilla.github.io/uniffi-rs/), and uses a prebuilt XCFramework from each
FireMQ release, so you do not need a Rust toolchain.

It supports macOS 12 and iOS 15 or later, on devices and in the simulator.

## Install

Add the package to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/FireMQ/firemq-swift", from: "0.1.0"),
],
targets: [
    .target(name: "MyApp", dependencies: [.product(name: "FireMQ", package: "firemq-swift")]),
]
```

In Xcode, choose **File > Add Package Dependencies** and enter
`https://github.com/FireMQ/firemq-swift`.

## Use it

```swift
import FireMQ

let client = try Client.connect(url: "fire://guest:guest@localhost:5673")
let queue = try client.declareQueue(name: "jobs", durable: true, exclusive: false)
try client.publish(exchange: "", key: queue.name, text: "hello")

let subscription = try client.subscribe(queue: queue.name, prefetch: 10)
if let message = try subscription.next(timeoutMs: 5000) {
    print(message.text ?? "")
    try message.ack()
}
try client.close()
```

Calls block until the broker answers, so make them off the main thread in an app. Errors are
`FireMqError` values; a refused request carries the AMQP reply `code`.
[`Examples/HelloFireMQ`](Examples/HelloFireMQ/main.swift) shows headers, properties and error
handling.

## Develop

The sources in `Sources/FireMQ` are copied from
[`bindings/swift`](https://github.com/FireMQ/firemq/tree/main/bindings/swift) in the FireMQ
repository, where they are generated and tested. Change them there.

To move to a new FireMQ release, run `scripts/update.sh vX.Y.Z`, which updates the
XCFramework URL and checksum in `Package.swift` and copies the sources from that tag, then
commit and tag the same version here.

To run the example, start a broker and run:

```bash
swift run HelloFireMQ
```

It connects to `$FIREMQ_URL` (default `fire://guest:guest@localhost:5673`).

## License

Apache-2.0.
