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

    // Mua token
    function buy(uint256 amount) public payable {
        // Kiểm tra số dư eth của người dùng
        require(msg.value >= amount * 0.001 ether);

        // Trả token cho người dùng
        balances[msg.sender] += amount;

        // Giảm số dư eth của smart contract
        address(this).transfer(msg.value - amount * 0.001 ether);

        // Tạo giao dịch
        transactions[totalSupply - amount] = Transaction(msg.sender, amount);

        // Phát ra sự kiện
        emit Transfer(address(this), msg.sender, amount);
    }

    // // Chức năng phân phối token cho những người đã đầu tư
    // function distributeTokens() public {
    //     for (uint256 i = 0; i < investors.length; i++) {
    //         _mint(investors[i], investors[i].amount);
    //     }
    // }

    // Hàm mint token
    function mint(address to, uint256 amount) public onlyFounder {
        // Mint ra token cho người nhận
        _mint(to, amount);
    }

    // Hàm chuyển token
    function transfer(address to, uint256 amount) public {
        // Bỏ qua kiểm tra số dư
        _transfer(msg.sender, to, amount);
    }

    // Hàm burn token
    function burn(uint256 amount) public onlyFounder {
        // Burn token
        _burn(msg.sender, amount);
    }

    // Hàm private để mint token
    function _mint(address to, uint256 amount) private {
        // Tăng tổng số lượng token
        totalSupply += amount;

        // Thêm token vào ví của người nhận
        to.balance += amount;
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
