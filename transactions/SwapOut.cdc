import FungibleToken from 0xee82856bf20e2aa6
import ExampleToken from 0xf8d6e0586b0a20c7
import AnyToken from 0xf8d6e0586b0a20c7
import AnyExampleToken from 0xf8d6e0586b0a20c7
import Router from 0xf8d6e0586b0a20c7

transaction() {
    let mpcRef: &Router.Mpc
    let mpcStoragePath: StoragePath
    let vaultRef: &ExampleToken.Vault
    let vaultStoragePath:StoragePath
    let anyVaultStoragePath:StoragePath
    let anyVaultRef:&AnyExampleToken.Vault
    prepare(acct: AuthAccount) {
        self.mpcStoragePath=/storage/routerMpc
        self.vaultStoragePath= /storage/exampleTokenVault
        self.anyVaultStoragePath=AnyExampleToken.TokenStoragePath
        self.mpcRef=acct.borrow<&Router.Mpc>(from:self.mpcStoragePath)
                                ?? panic("Could not borrow a reference to the crosschain")
        self.vaultRef = acct.borrow<&ExampleToken.Vault>(from: self.vaultStoragePath)
                                ?? panic("Could not borrow a reference to the owner's vault")
        self.anyVaultRef=acct.borrow<&AnyExampleToken.Vault>(from:self.anyVaultStoragePath)
                                ?? panic("Could not borrow a reference to the owner's vault")
    }

    execute {
        let temporaryVault <- self.vaultRef.withdraw(amount: 10.0)
        Router.swapOut(token:AnyExampleToken.Vault.getType().identifier,to:"0xf8d6e0586b0a20c7",toChainId:97,value:<-temporaryVault)
    }
}
 