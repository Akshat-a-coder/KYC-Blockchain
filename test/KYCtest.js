const KYCContract = artifacts.require("KYCContract");

contract("KYCContract", (accounts) => {
    it("Should add and verify a customer", async () => {
        const kyc = await KYCContract.new();
        await kyc.addCustomer("Alice", "Alice's KYC Data", "SecretKey123");

        const customer = await kyc.getCustomer(1);
        assert.equal(customer.name, "Alice");
        assert.equal(customer.addedBy, accounts[0]);

        const isVerified = await kyc.verifyKYC(1, "Alice's KYC Data", "SecretKey123");
        assert.equal(isVerified, true);
    });
});
