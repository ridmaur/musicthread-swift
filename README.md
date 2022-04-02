# MusicThread Swift Client

A Swift client for accessing the MusicThread API.

For example usage please see: https://github.com/brushedtype/musicthread-ios

---

This Swift Package contains two libraries: `MusicThreadAPI` and `MusicThreadTokenStore`.

`MusicThreadTokenStore` provides a [token storage class](https://github.com/brushedtype/musicthread-swift/blob/main/Sources/MusicThreadTokenStore/KeychainTokenStore.swift) that simply wraps the popular [KeychainAccess library](https://github.com/kishikawakatsumi/KeychainAccess) to persist API tokens to the iOS keychain.

`MusicThreadTokenStore` is optional but helpful for most basic setups. You may choose to implement your own token storage if you have more complex needs, or wish to use a different Keychain library.
