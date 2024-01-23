pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RugPull is ERC20 {
    // Người sáng lập
    address public founder;

    // Danh sách các nhà đầu tư nắm giữ token
    mapping(address => uint256) public balances;

    // Danh sách các giao dịch token
    mapping(uint256 => Transaction) public transactions;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    // Hàm khởi tạo
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        // Thiết lập người sáng lập
        founder = msg.sender;

        // Mint ra token cho người sáng lập
        _mint(founder, initialSupply);
    }

    // Hàm mint token
    function mint(address to, uint256 amount) public onlyFounder {
        // Mint ra token cho người nhận
        _mint(to, amount);
    }

    // Hàm private để mint token
    function _mint(address to, uint256 amount) private {
        // Tăng tổng số lượng token
        totalSupply += amount;

        // Thêm token vào ví của người nhận
        to.balance += amount;
    }

    // Hàm chuyển token
    function transfer(address to, uint256 amount) public {
        // Kiểm tra số dư
        require(balances[msg.sender] >= amount, "Not enough balance");

        // Giới hạn số lượng token có thể được chuyển nếu không phải founder
        if (!isFounder(msg.sender)) {
            require(amount <= 10000, "Max transfer amount is 10000");
        }

        // Kiểm tra địa chỉ người nhận
        require(to != address(0), "Invalid recipient address");

        // Thực hiện giao dịch
        _transfer(msg.sender, to, amount);
    }

    // Hàm burn token
    function burn(uint256 amount) public onlyFounder {
        // Burn token
        _burn(msg.sender, amount);
    }

    // Hàm private để chuyển token
    function _transfer(address from, address to, uint256 amount) private {
        // Tăng số dư của người nhận
        to.balance += amount;

        // Giảm số dư của người gửi
        from.balance -= amount;
    }

    // Hàm private để burn token
    function _burn(address from, uint256 amount) private {
        // Giảm tổng số lượng token
        totalSupply -= amount;

        // Giảm số dư của người gửi
        from.balance -= amount;
    }

    modifier onlyFounder() {
        require(
            msg.sender == founder,
            "Only the founder can call this function"
        );
        _;
    }
}
