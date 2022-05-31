import FungibleToken from 0xee82856bf20e2aa6
import AnyExampleToken from 0xf8d6e0586b0a20c7
import Router from 0xf8d6e0586b0a20c7

transaction() {
    let mpcRef: &Router.Mpc
    let mpcStoragePath: StoragePath
    let vaultPublicPath:PublicPath 
    let receiverRef:Capability<&{FungibleToken.Receiver}>
    prepare(acct: AuthAccount) {
        self.mpcStoragePath=/storage/routerMpc
        self.vaultPublicPath=/public/exampleTokenReceiver
        self.mpcRef=acct.borrow<&Router.Mpc>(from:self.mpcStoragePath)
                                ?? panic("Could not borrow a reference to the crosschain")
        let recipient=getAccount(0xf8d6e0586b0a20c7)
        self.receiverRef = recipient.getCapability<&{FungibleToken.Receiver}>(self.vaultPublicPath)
    }

    execute {
        self.mpcRef.swapIn(token:AnyExampleToken.Vault.getType().identifier,fromChainId:1,amount:10.0,receive:self.receiverRef)
    }
}
 