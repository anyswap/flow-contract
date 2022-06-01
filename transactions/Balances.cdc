import FungibleToken from 0xee82856bf20e2aa6
transaction() {
    let vaultPublicPath:PublicPath 
    let receiverRef:Capability<&{FungibleToken.Balance}>
    prepare(acct: AuthAccount) {
        self.vaultPublicPath=/public/exampleTokenBalance

        let recipient=getAccount(0xf8d6e0586b0a20c7)
        self.receiverRef = recipient.getCapability<&{FungibleToken.Balance}>(self.vaultPublicPath)
    }

    execute {
        let account=self.receiverRef.borrow()??panic("get receiver for capability fails")

        log("balances:".concat(account.balance.toString()))
    }
}
 