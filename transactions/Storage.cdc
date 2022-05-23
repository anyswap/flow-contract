import FungibleToken from 0xee82856bf20e2aa6
// import AnyToken from 0xf8d6e0586b0a20c7
import ExampleToken from 0xf8d6e0586b0a20c7

transaction() {
    let vaultStoragePath: StoragePath
    let vaultPublicPath:PublicPath 
    prepare(acct: AuthAccount) {
        self.vaultStoragePath= /storage/exampleTokenVault
        self.vaultPublicPath=/public/exampleTokenReceiver
        let tempVault<- ExampleToken.createEmptyVault()
		acct.save<@ExampleToken.Vault>(<-tempVault, to: self.vaultStoragePath)
        log("Empty vault stored")

        acct.link<&{FungibleToken.Receiver}>(
            self.vaultPublicPath,
            target: self.vaultStoragePath
        )

        // Create a public capability to the stored Vault that only exposes
        // the `balance` field through the `Balance` interface
        //
        acct.link<&ExampleToken.Vault{FungibleToken.Balance}>(
            /public/exampleTokenBalance,
            target: self.vaultStoragePath
        )

        
    }
}
 