import FungibleToken from 0xee82856bf20e2aa6
import FlowToken from 0x0ae53cb6e3f42a79
transaction() {
    let vaultRef: &FlowToken.Vault
    let vaultStoragePath: StoragePath
    let vaultPublicPath:PublicPath 
    let receiverRef:Capability<&{FungibleToken.Receiver}>
    prepare(acct: AuthAccount) {
        self.vaultStoragePath= /storage/flowTokenVault
        self.vaultPublicPath=/public/flowTokenReceiver

        self.vaultRef = acct.borrow<&FlowToken.Vault>(from: self.vaultStoragePath)
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
 