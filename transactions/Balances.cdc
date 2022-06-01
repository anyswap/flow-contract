import FungibleToken from 0xee82856bf20e2aa6
transaction() {
    let vaultPublicPath:PublicPath 
    let anyVaultPublicPath:PublicPath 
    let flowVaultPublicPath:PublicPath 
    let receiverRef:Capability<&{FungibleToken.Balance}>
    let receiverAnyRef:Capability<&{FungibleToken.Balance}>
    let receiverFlowRef:Capability<&{FungibleToken.Balance}>
    prepare(acct: AuthAccount) {
        self.vaultPublicPath=/public/exampleTokenBalance
        self.anyVaultPublicPath=/public/anyExampleTokenBalance
        self.flowVaultPublicPath=/public/flowTokenBalance

        let recipient=getAccount(0xe03daebed8ca0615)
        self.receiverRef = recipient.getCapability<&{FungibleToken.Balance}>(self.vaultPublicPath)
        self.receiverAnyRef = recipient.getCapability<&{FungibleToken.Balance}>(self.anyVaultPublicPath)
        self.receiverFlowRef = recipient.getCapability<&{FungibleToken.Balance}>(self.flowVaultPublicPath)
    }

    execute {
        let tokenBalance=self.receiverRef.borrow()??panic("get receiver for capability fails")
        let anyTokenBalance=self.receiverAnyRef.borrow()??panic("get receiver for capability fails")
        let flowTokenBalance=self.receiverFlowRef.borrow()??panic("get receiver for capability fails")
        log("balances:".concat(tokenBalance.balance.toString()))
        log("any balances:".concat(anyTokenBalance.balance.toString()))
        log("flow balances:".concat(flowTokenBalance.balance.toString()))
    }
}
 