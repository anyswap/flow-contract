import FungibleToken from 0xee82856bf20e2aa6
import AnyExampleToken from 0xf8d6e0586b0a20c7
import Router from 0xf8d6e0586b0a20c7

transaction() {
    let vaultRef: &{FungibleToken.Provider}
    let vaultStoragePath:StoragePath
    prepare(acct: AuthAccount) {
        self.vaultStoragePath= /storage/exampleTokenVault
        self.vaultRef = acct.borrow<&{FungibleToken.Provider}>(from:self.vaultStoragePath)
                                ?? panic("Could not borrow a reference to the owner's vault")
    }

    execute {
        log("vaultStoragePath:".concat(self.vaultStoragePath.toString()))
        let temporaryVault <- self.vaultRef.withdraw(amount: 10.0)
        Router.swapOut(token:AnyExampleToken.Vault.getType().identifier,to:"0xf8d6e0586b0a20c7",toChainId:97,value:<-temporaryVault)
    }
}
 