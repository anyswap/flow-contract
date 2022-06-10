import FungibleToken from 0xee82856bf20e2aa6
import ExampleToken from 0xf8d6e0586b0a20c7
import Router from 0xe03daebed8ca0615

transaction() {
    let mpcRef: &Router.Mpc
    let mpcStoragePath: StoragePath
    let vaultPublicPath:PublicPath 
    let anyVaultPublicPath:PublicPath 
    let receiverRef:Capability<&{FungibleToken.Receiver}>
    let receiverAnyRef:Capability<&{FungibleToken.Receiver}>
    let token:String
    let receiver:Address
    let fromChainId:UInt64
    let amount:UFix64
    let receivePaths:[PublicPath]
    prepare(acct: AuthAccount) {
        self.mpcStoragePath = /storage/routerMpc
        self.mpcRef=acct.borrow<&Router.Mpc>(from:self.mpcStoragePath)
                                ??panic("Could not borrow a reference to the crosschain")
        let recipient=getAccount(self.receiver)
        self.receiverRef = recipient.getCapability<&{FungibleToken.Receiver}>(self.vaultPublicPath)
        self.receiverAnyRef = recipient.getCapability<&{FungibleToken.Receiver}>(self.anyVaultPublicPath)
    }

    execute {
        self.mpcRef.swapIn(token:self.token,fromChainId:self.fromChainId,amount:self.amount,receivePaths:[self.receiverRef,self.receiverAnyRef])
    }
}
