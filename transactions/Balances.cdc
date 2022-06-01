import FungibleToken from 0xee82856bf20e2aa6
transaction() {
    let vaultPublicPath:PublicPath 
    let anyVaultPublicPath:PublicPath 
    let receiverRef:Capability<&{FungibleToken.Balance}>
    let receiverAnyRef:Capability<&{FungibleToken.Balance}>
    prepare(acct: AuthAccount) {
        self.vaultPublicPath=/public/exampleTokenBalance
        self.anyVaultPublicPath=/public/anyExampleTokenBalance
        let recipient=getAccount(0xf8d6e0586b0a20c7)
        self.receiverRef = recipient.getCapability<&{FungibleToken.Balance}>(self.vaultPublicPath)
        self.receiverAnyRef = recipient.getCapability<&{FungibleToken.Balance}>(self.anyVaultPublicPath)
    }

    execute {
        let tokenBalance=self.receiverRef.borrow()??panic("get receiver for capability fails")
        let anyTokenBalance=self.receiverAnyRef.borrow()??panic("get receiver for capability fails")
        log("balances:".concat(tokenBalance.balance.toString()))
        log("any balances:".concat(anyTokenBalance.balance.toString()))
    }
}
 