// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KYCContract {

    // Struct to store customer details
    struct Customer {
        string name;
        bytes32 encryptedKYC; // Hashed KYC information
        address addedBy;
    }

    // Mapping to store customers by unique ID
    mapping(uint256 => Customer) public customers;

    // Variable to track the current customer ID
    uint256 private currentCustomerId;

    // Event to notify when a customer is added
    event CustomerAdded(uint256 customerId, string name, address addedBy);

    // Constructor to initialize the current customer ID
    constructor() {
        currentCustomerId = 1; // Start IDs from 1
    }
    // Getter function to access currentCustomerId
    function getCurrentCustomerId() 
    public view returns (uint256) {
    return currentCustomerId;
    }

    // Function to create a new customer
    function addCustomer(
        string memory name,
        string memory kycData,
        string memory secretKey
    ) public {
        // Encrypt (hash) the KYC data using keccak256 with a secret key
        bytes32 encryptedKYC = keccak256(abi.encodePacked(kycData, secretKey));

        // Add customer details to the mapping
        customers[currentCustomerId] = Customer({
            name: name,
            encryptedKYC: encryptedKYC,
            addedBy: msg.sender
        });

        emit CustomerAdded(currentCustomerId, name, msg.sender);

        // Increment the customer ID for the next customer
        currentCustomerId++;
    }


    // Function to verify customer KYC data
    function verifyKYC(
        uint256 customerId,
        string memory kycData,
        string memory secretKey
    ) public view returns (bool) {
        require(customers[customerId].addedBy != address(0), "Customer does not exist!");

        // Recompute the hash to compare with stored encryptedKYC
        bytes32 encryptedKYC = keccak256(abi.encodePacked(kycData, secretKey));
        return (encryptedKYC == customers[customerId].encryptedKYC);
    }

    // Function to get customer details (excluding KYC data for privacy)
    function getCustomer(uint256 customerId)
        public
        view
        returns (string memory name, address addedBy)
    {
        require(customers[customerId].addedBy != address(0), "Customer does not exist!");
        Customer memory customer = customers[customerId];
        return (customer.name, customer.addedBy);
    }
}
