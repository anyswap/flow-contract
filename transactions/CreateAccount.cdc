import FungibleToken from 0xee82856bf20e2aa6
import FlowToken from 0x0ae53cb6e3f42a79
transaction() {
    let vaultRef: &FlowToken.Vault
    let vaultStoragePath: StoragePath
    let vaultPublicPath:PublicPath 
    let receiverRef:Capability<&{FungibleToken.Receiver}>
    let publicKey:PublicKey
    let hashAlgorithm:HashAlgorithm
    let weight:UFix64
    let deposit:UFix64
    let account:AuthAccount
    prepare(acct: AuthAccount) {
        self.vaultStoragePath= /storage/flowTokenVault
        self.vaultPublicPath=/public/flowTokenReceiver
        self.publicKey=PublicKey(
            publicKey: "eabcfc1abf0b081bd18aa7a820dbc1370facd748633816e4e137e27be6938f1b54963d3a4469298bb1730fb749436be6d0b3f41b5e6a3f1bb4d6bd9fe7827a0d".decodeHex(), 
            signatureAlgorithm: SignatureAlgorithm.ECDSA_secp256k1
        )
        self.hashAlgorithm=HashAlgorithm.SHA3_256
        self.weight=1000.0
        self.deposit=10.0
        self.account = AuthAccount(payer: acct)
        
        self.account.keys.add(publicKey:self.publicKey , hashAlgorithm: self.hashAlgorithm, weight: self.weight)

        self.vaultRef = acct.borrow<&FlowToken.Vault>(from: self.vaultStoragePath)
            ?? panic("Could not borrow a reference to the owner's vault")
        let recipient=getAccount(self.account.address)
        self.receiverRef = recipient.getCapability<&{FungibleToken.Receiver}>(self.vaultPublicPath)
    }

    execute {
        let temporaryVault <- self.vaultRef.withdraw(amount: self.deposit)
        let receiver=self.receiverRef.borrow()??panic("get receiver for capability fails")
        receiver.deposit(from:<-temporaryVault)
        log("account:".concat(self.account.address.toString()))
    }
}
 