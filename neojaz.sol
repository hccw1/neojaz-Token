// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// استيراد مكتبات OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract neojaz is ERC20, Ownable, Pausable {
    // العدد الكلي للعملة
    uint256 private constant INITIAL_SUPPLY = 1000000000 * 10 ** 18;

    // حالة إيقاف إمكانية السك
    bool public mintingFinished = false;

    // Modifier يمنع السك إذا تم إيقافه
    modifier canMint() {
        require(!mintingFinished, "Minting has been permanently disabled");
        _;
    }

    // المُنشئ: تحديد اسم ورمز العملة وتعيين المالك
    constructor() ERC20("neojaz", "NEOJ") Ownable(msg.sender) {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    // سك عملات جديدة (إذا لم يتم إيقافه نهائيًا)
    function mint(address to, uint256 amount) external onlyOwner whenNotPaused canMint {
        _mint(to, amount);
    }

    // إيقاف السك نهائيًا
    function finishMinting() external onlyOwner {
        mintingFinished = true;
    }

    // حرق العملات (من الرصيد الشخصي)
    function burn(uint256 amount) external whenNotPaused {
        _burn(msg.sender, amount);
    }

    // إيقاف العقد مؤقتًا
    function pause() external onlyOwner {
        _pause();
    }

    // استئناف العقد بعد الإيقاف
    function unpause() external onlyOwner {
        _unpause();
    }

    // نقل العملات
    function transfer(address to, uint256 amount) public override whenNotPaused returns (bool) {
        return super.transfer(to, amount);
    }

    // نقل العملات من طرف ثالث
    function transferFrom(address from, address to, uint256 amount) public override whenNotPaused returns (bool) {
        return super.transferFrom(from, to, amount);
    }

    // إنقاذ أي رموز أو أموال تم إرسالها بالخطأ للعقد
    function rescueFunds(address tokenAddress, uint256 amount) external onlyOwner {
        IERC20(tokenAddress).transfer(owner(), amount);
    }
}
