import FungibleToken from 0xee82856bf20e2aa6
import ExampleToken from 0xf8d6e0586b0a20c7

transaction() {
    let vaultRef: &ExampleToken.Vault
    let vaultStoragePath: StoragePath
    let vaultPublicPath:PublicPath 
    let receiverRef:Capability<&{FungibleToken.Receiver}>
    prepare(acct: AuthAccount) {
        self.vaultStoragePath= /storage/exampleTokenVault
        self.vaultPublicPath=/public/exampleTokenReceiver

        self.vaultRef = acct.borrow<&ExampleToken.Vault>(from: self.vaultStoragePath)
            ?? panic("Could not borrow a reference to the owner's vault")
        let recipient=getAccount(0x01cf0e2f2f715450)
        self.receiverRef = recipient.getCapability<&{FungibleToken.Receiver}>(self.vaultPublicPath)
    }

    execute {
        let temporaryVault <- self.vaultRef.withdraw(amount: 100.0)
        let receiver=self.receiverRef.borrow()??panic("get receiver for capability fails")
        receiver.deposit(from:<-temporaryVault)
    }
}
 