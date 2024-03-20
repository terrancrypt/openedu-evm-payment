// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract OpenEduDeposit {
    // ========= Type
    using SafeERC20 for IERC20;

    // ========== Error
    error Deposit__MissingAmount();

    address private s_safeAddr;
    // mapping(address tokenAddr => bool) private s_tokenAccepted;

    struct InvoiceInfo {
        address tokenAddr;
        bytes32 userId;
        bytes32 courseId;
        uint256 amount;
        address from;
    }

    mapping(uint256 invoiceId => bytes invoiceData) private s_invoices;
    uint256 private s_currentInvoiceId;

    constructor(address _safeAddr, address[] memory tokenAccept) {
        s_safeAddr = _safeAddr;

        // for (uint256 i; i < tokenAccept.length; i++) {
        //     s_tokenAccepted[tokenAccept[i]] = true;
        // }
    }

    function deposit(InvoiceInfo memory invoiceInfo) external {
        address tokenAddr = invoiceInfo.tokenAddr;
        uint256 amount = invoiceInfo.amount;

        if (amount == 0) {
            revert Deposit__MissingAmount();
        }

        IERC20(tokenAddr).safeTransferFrom(msg.sender, s_safeAddr, amount);

        s_invoices[s_currentInvoiceId] = abi.encode(invoiceInfo);
        s_currentInvoiceId++;
    }

    function getInvoiceInfo(uint256 invoiceId) public view returns (InvoiceInfo memory invoiceInfo) {
        invoiceInfo = abi.decode(s_invoices[invoiceId], (InvoiceInfo));
    }
}
