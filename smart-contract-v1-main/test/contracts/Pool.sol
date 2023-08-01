// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

library AddressUpgradeable {
    function isContract(address account) internal view returns (bool) {
        
        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract Initializable {

    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    /// @dev Returns true if and only if the function is running in the constructor
    function _isConstructor() private view returns (bool) {
        return !AddressUpgradeable.isContract(address(this));
    }
}

abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal initializer {
        __Context_init_unchained();
    }

    function __Context_init_unchained() internal initializer {
    }
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
    uint256[50] private __gap;
}

abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function __Ownable_init() internal initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal initializer {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
    uint256[49] private __gap;
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

library Address {
    
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

   
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

   
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

   
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}



library EnumerableSet {
    
    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

   
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}


interface IPoolFactory {
  function increaseTotalValueLocked(uint256 value) external;
  function decreaseTotalValueLocked(uint256 value) external;
  function removePoolForToken(address token, address pool) external;
  function recordContribution(address user, address pool) external;

  event TvlChanged(uint256 totalLocked, uint256 totalRaised);
  event ContributionUpdated(uint256 totalParticipations);
  event PoolForTokenRemoved(address indexed token, address pool);
}


interface IPool {
    function initialize(
        address[3] memory _addrs, // [0] = token, [1] = router, [2] = governance
        uint256[2] memory _rateSettings, // [0] = rate, [1] = uniswap rate
        uint256[2] memory _contributionSettings, // [0] = min, [1] = max
        uint256[2] memory _capSettings, // [0] = soft cap, [1] = hard cap
        uint256[3] memory _timeSettings, // [0] = start, [1] = end, [2] = unlock seconds
        uint256[2] memory _feeSettings, // [0] = token fee percent, [1] = eth fee percent
        bool _useWhitelisting,
        uint256 _liquidityPercent,
        uint256 _refundType,
        string memory _poolDetails,
        address _poolOwner,
        address _poolManager
    ) external;

    function initializeVesting(
         uint256[7] memory _vestingInit  
    ) external;

    function version() external view returns (uint8);
}

library PoolLibrary {
  using SafeMath for uint256;

  function withdrawableVestingTokens(
    uint256 tgeTime,
    uint256 cycle,
    uint256 tokensReleaseEachCycle,
    uint256 tgeTokensRelease,
    uint256 totalVestingTokens,
    uint256 totalVestedTokens
  ) internal view returns (uint256) {
    if (tgeTime == 0) return 0;
    if (block.timestamp < tgeTime) return 0;
    if (cycle == 0) return 0;

    uint256 currentTotal = 0;

    if (block.timestamp >= tgeTime) {
        currentTotal = block.timestamp
                              .sub(tgeTime)
                              .div(cycle)
                              .mul(tokensReleaseEachCycle)
                              .add(tgeTokensRelease);
    }
    
    uint256 withdrawable = 0;

    if (currentTotal > totalVestingTokens) {
        withdrawable = totalVestingTokens.sub(totalVestedTokens);
    } else {
        withdrawable = currentTotal.sub(totalVestedTokens);
    }

    return withdrawable;
  }

  function getContributionAmount(
    uint256 contributed,
    uint256 minContribution,
    uint256 maxContribution,
    uint256 availableToBuy
  ) internal pure returns (uint256, uint256) {
        // Bought all their allocation
        if (contributed >= maxContribution) {
            return (0, 0);
        }
        uint256 remainingAllocation = maxContribution.sub(contributed);

        // How much bnb is one token
        if (availableToBuy > remainingAllocation) {
            if (contributed > 0) {
                return (0, remainingAllocation);
            } else {
                return (minContribution, remainingAllocation);
            }
        } else {
             if (contributed > 0) {
                return (0, availableToBuy);
            } else {
                if (availableToBuy < minContribution) {
                    return (0, availableToBuy);
                } else {
                    return (minContribution, availableToBuy);
                }
            }
        }
  }

  function convertCurrencyToToken(
    uint256 amount, 
    uint256 rate
  ) internal pure returns (uint256) {
    return amount.mul(rate).div(1e18);
  }

  function addLiquidity(
    address router,
    address token,
    uint256 liquidityBnb,
    uint256 liquidityToken,
    address pool
  ) internal returns (uint256 liquidity) {
    IERC20(token).approve(router, liquidityToken);
    (,, liquidity) = IUniswapV2Router02(router).addLiquidityETH{value: liquidityBnb}(
        token,
        liquidityToken,
        liquidityToken,
        liquidityBnb,
        pool,
        block.timestamp
    );
  }

  function calculateFeeAndLiquidity(
    uint256 totalRaised,
    uint256 ethFeePercent,
    uint256 tokenFeePercent,
    uint256 totalVolumePurchased,
    uint256 liquidityPercent,
    uint256 liquidityListingRate
  ) internal pure returns (uint256 bnbFee, uint256 tokenFee, uint256 liquidityBnb, uint256 liquidityToken) {
    bnbFee = totalRaised.mul(ethFeePercent).div(100);
    tokenFee = totalVolumePurchased.mul(tokenFeePercent).div(100);
    liquidityBnb = totalRaised.sub(bnbFee).mul(liquidityPercent).div(100);
    liquidityToken = liquidityBnb.mul(liquidityListingRate).div(1e18);
  }
}

contract Pool is OwnableUpgradeable, IPool {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using Address for address payable;
    using EnumerableSet for EnumerableSet.AddressSet;

    uint8 constant VERSION = 2;
    uint constant MINIMUM_LOCK_DAYS = 5 minutes;

    enum PoolState {
        inUse,
        completed,
        cancelled
    }

    address public factory;
    address public router;
    address public governance;
    

    address public token;
    uint256 public rate;
    uint256 public minContribution;
    uint256 public maxContribution;
    uint256 public softCap;
    uint256 public hardCap;

    uint256 public startTime;
    uint256 public endTime;

    uint256 private tokenFeePercent;
    uint256 private ethFeePercent;

    uint256 public liquidityListingRate;
    uint256 public liquidityUnlockTime;
    uint256 public liquidityLockDays;
    uint256 public liquidityPercent;
    uint256 public refundType;

    string public poolDetails;

    PoolState public poolState;

    uint256 public totalRaised;
    uint256 public totalVolumePurchased;
    uint256 public totalClaimed;
    uint256 public totalRefunded;

    uint256 private tvl;

    bool public completedKyc;

    mapping(address => uint256) public contributionOf;
    mapping(address => uint256) public purchasedOf;
    mapping(address => uint256) public claimedOf;
    mapping(address => uint256) public refundedOf;

    uint256 public totalVestingTokens;
    uint256 public tgeLockDuration;
    uint256 public tgeTime;
    uint256 public tgeTokensRelease;
    uint256 public cycle;
    uint256 public tokensReleaseEachCycle;

    uint256 public totalVestedTokens;
    uint256 public eachvestingPer;
    uint256 public tgeTokenReleasePer;

    bool public useWhitelisting;
    EnumerableSet.AddressSet private whitelistedUsers;
    mapping(address => bool) private isWhitelisted;

    event Contributed(
        address indexed user,
        uint256 amount,
        uint256 volume,
        uint256 total,
        uint256 timestamp
    );

    event WithdrawnContribution(address indexed user, uint256 amount);

    event Claimed(address indexed user, uint256 volume, uint256 total);

    event Finalized(uint256 liquidity, uint256 timestamp);

    event Cancelled(uint256 timestamp);

    event PoolUpdated(uint256 timestamp);

    event KycUpdated(bool completed, uint256 timestamp);

    event LiquidityWithdrawn(uint256 amount, uint256 timestamp);

    event VestingTokenWithdrawn(uint256 amount, uint256 timestamp);

    modifier inProgress() {
        require(poolState == PoolState.inUse, "Pool is either completed or cancelled");
        require(block.timestamp >= startTime && block.timestamp < endTime, "It's not time to buy");
        require(totalRaised < hardCap, "Hardcap reached");
        _;
    }

    modifier onlyWhitelisted() {
        if (useWhitelisting) {
            require(isWhitelisted[msg.sender], "User is not whitelisted");
        }
        _;
    }

    modifier onlyOperator() {
        require(msg.sender == owner() || msg.sender == governance, "Only operator");
        _;
    }

    modifier onlyGovernance() {
        require(msg.sender == governance, "Only governance");
        _;
    }

    receive() external payable {
        if (msg.value > 0) contribute();
    }

    function initialize(
        address[3] memory _addrs, // [0] = token, [1] = router, [2] = governance
        uint256[2] memory _rateSettings, // [0] = rate, [1] = uniswap rate
        uint256[2] memory _contributionSettings, // [0] = min, [1] = max
        uint256[2] memory _capSettings, // [0] = soft cap, [1] = hard cap
        uint256[3] memory _timeSettings, // [0] = start, [1] = end, [2] = unlock seconds
        uint256[2] memory _feeSettings, // [0] = token fee percent, [1] = eth fee percent
        bool _useWhitelisting,
        uint256 _liquidityPercent,
        uint256 _refundType,
        string memory _poolDetails,
        address _poolOwner,
        address _poolManager
    ) external override initializer {
        require(factory == address(0), "Pool: Forbidden");
        require(_addrs[0] != address(0), "Invalid Token address");
        require(_contributionSettings[0] <= _contributionSettings[1], "Min contribution amount must be less than or equal to max");
        require(_capSettings[0].mul(2) >= _capSettings[1] && _capSettings[0] <= _capSettings[1] && _capSettings[1] > 0, "Softcap must be >= 50% of hardcap");
        // require(_timeSettings[0] > block.timestamp, "Start time should be in the future");
        require(_timeSettings[0] < _timeSettings[1], "End time must be after start time");
        require(_timeSettings[2] >= MINIMUM_LOCK_DAYS, "Liquidity unlock time must be at least 30 days after pool is finalized");
        require(
            _feeSettings[0] >= 0 &&
            _feeSettings[0] <= 100 &&
            _feeSettings[1] >= 0 &&
            _feeSettings[1] <= 100,
            "Invalid fee settings. Must be percentage (0 -> 100)"
        );
        require (_rateSettings[0] >= _rateSettings[1], "Liquidity listing rate must be less than or equal to pool listing rate");
        require(_liquidityPercent >= 51 && _liquidityPercent <= 100, "Invalid liquidity percentage");
        require(_refundType == 0 || _refundType == 1, "Refund type must be 0 (refund) or 1 (burn)");
        OwnableUpgradeable.__Ownable_init();
        transferOwnership(_poolOwner);
        factory = _poolManager;
        token = _addrs[0];
        router = _addrs[1];
        governance = _addrs[2];
        rate = _rateSettings[0];
        liquidityListingRate = _rateSettings[1];
        minContribution = _contributionSettings[0];
        maxContribution = _contributionSettings[1];
        softCap = _capSettings[0];
        hardCap = _capSettings[1];
        startTime = _timeSettings[0];
        endTime = _timeSettings[1];
        liquidityLockDays = _timeSettings[2];
        tokenFeePercent = _feeSettings[0];
        ethFeePercent = _feeSettings[1];
        useWhitelisting = _useWhitelisting;
        liquidityPercent = _liquidityPercent;
        refundType = _refundType;
        poolDetails = _poolDetails;
        poolState = PoolState.inUse;
    }

    function initializeVesting(
        uint256[7] memory _vestingInit  //  [0] _totalVestingTokens, [1] _tgeTime,  [2] _tgeTokenRelease,  [3] _cycle,  [4] _tokenReleaseEachCycle, [5] _eachvestingPer, [6] _tgeTokenReleasePer
    ) external override onlyOperator{
        require(factory != address(0), "Only Pool Factory");
        require(poolState == PoolState.inUse, "Pool Closed !");
        require(totalVestingTokens == 0, "Already initialized");
        require(_vestingInit[2].add(_vestingInit[4]) <= _vestingInit[0], "Invalid token amount");
        if (_vestingInit[0] > 0) {
            require (_vestingInit[3] > 0, "Cycle cannot be 0");
        }
        totalVestingTokens = _vestingInit[0];
        tgeLockDuration = _vestingInit[1];
        tgeTokensRelease = _vestingInit[2];
        cycle = _vestingInit[3];
        tokensReleaseEachCycle = _vestingInit[4];
        eachvestingPer = _vestingInit[5];
        tgeTokenReleasePer = _vestingInit[6];
    }

    function addWhitelistedUsers(address[] memory users) external {
        for (uint256 i = 0; i < users.length; i++) {
            setWhitelist(users[i], true);
        }
    }

    function addWhitelistedUser(address user) external {
        setWhitelist(user, true);
    }

    function removeWhitelistedUsers(address[] memory users) external {
        for (uint256 i = 0; i < users.length; i++) {
            setWhitelist(users[i], false);
        }
    }

    function removeWhitelistedUser(address user) external {
        setWhitelist(user, false);
    }

    function isUserWhitelisted(address user) public view returns (bool) {
        if (useWhitelisting) {
            return isWhitelisted[user];
        }
        return true;
    }

    function setWhitelist(address user, bool whitelisted) internal onlyOperator {
        require(useWhitelisting, "Pool does not use whitelisting option");
        if (whitelisted) {
            if (!whitelistedUsers.contains(user)) {
                whitelistedUsers.add(user);
                isWhitelisted[user] = true;
            }
        } else {
            if (whitelistedUsers.contains(user)) {
                whitelistedUsers.remove(user);
                isWhitelisted[user] = false;
            }
        }
    }

    function getNumberOfWhitelistedUsers() public view returns (uint256) {
        return whitelistedUsers.length();
    }

    function getWhitelistedUsers(uint256 startIndex, uint256 endIndex) public view returns (address[] memory) {
        if (endIndex >= whitelistedUsers.length()) {
            endIndex = whitelistedUsers.length() - 1;
        }
        uint256 len = endIndex - startIndex + 1;
        address[] memory whitelistedParticipantsPart = new address[](len);

        uint256 counter = 0;
        for (uint256 i = startIndex; i <= endIndex; i++) {
            whitelistedParticipantsPart[counter] = whitelistedUsers.at(i);
            counter++;
        }
        return whitelistedParticipantsPart;
    }

    function version() public override pure returns (uint8) {
        return VERSION;
    }

    function contribute() public payable inProgress {
        require(msg.value > 0, "Cant contribute 0");
        uint256 userTotalContribution = contributionOf[msg.sender].add(msg.value);
        // Allow to contribute with an amount less than min contribution
        // if the remaining contribution amount is less than min
        if (hardCap.sub(totalRaised) >= minContribution) {
            require(userTotalContribution >= minContribution, "Min contribution not reached");
        }
        require(userTotalContribution <= maxContribution, "Contribute more than allowed");
        require(totalRaised.add(msg.value) <= hardCap, "Buying amount exceeds hard cap");
        if (contributionOf[msg.sender] == 0) {
            IPoolFactory(factory).recordContribution(msg.sender, address(this));
        }
        contributionOf[msg.sender] = userTotalContribution;
        totalRaised = totalRaised.add(msg.value);
        uint256 volume = PoolLibrary.convertCurrencyToToken(msg.value, rate);
        require(volume > 0, "Contribution too small to produce any volume");
        purchasedOf[msg.sender] = purchasedOf[msg.sender].add(volume);
        totalVolumePurchased = totalVolumePurchased.add(volume);
        emit Contributed(msg.sender, msg.value, volume, totalVolumePurchased, block.timestamp);
    }

    

    function claim() public {
        require(poolState == PoolState.completed, "Owner has not closed the pool yet");
        uint256 volume = purchasedOf[msg.sender];
        uint256 totalClaim = claimedOf[msg.sender];
        uint256 totalAvalible = 0;
        
        if(tgeTime <= block.timestamp){
            totalAvalible += volume - totalClaim;
        }
        else{
            uint256 vestingAmount = volume - ((volume * tgeTokenReleasePer) / 100);
            uint256 eachCycleToken = vestingAmount / cycle;
            uint256 _startTime = tgeTime - tgeLockDuration;
            uint256 eachLockPeriod = tgeLockDuration / cycle;
            uint256 passPeriod = block.timestamp - _startTime;
            totalAvalible += ((passPeriod / eachLockPeriod) * eachCycleToken) + ((volume * tgeTokenReleasePer) / 100);
        }

        require(totalAvalible > totalClaim , "NO Reward Avalible For Claim");
        uint256 claimble = totalAvalible.sub(totalClaim);
        claimedOf[msg.sender] = totalAvalible;
        totalClaimed = totalClaimed.add(claimble);
        IERC20(token).safeTransfer(msg.sender, claimble);
        emit Claimed(msg.sender, volume, totalClaimed);
        
    }

    function withdrawContribution() external {
        if (poolState == PoolState.inUse) {
            require(block.timestamp >= endTime, "Pool is still in progress");
            require(totalRaised < softCap, "Soft cap reached");
        } else {
            require(poolState == PoolState.cancelled, "Cannot withdraw contribution because pool is completed");
        }
        require(refundedOf[msg.sender] == 0, "Already withdrawn contribution");

        uint256 refundAmount = contributionOf[msg.sender];
        refundedOf[msg.sender] = refundAmount;
        totalRefunded = totalRefunded.add(refundAmount);
        contributionOf[msg.sender] = 0;

        payable(msg.sender).sendValue(refundAmount);
        emit WithdrawnContribution(msg.sender, refundAmount);
    }

    function finalize() external onlyOperator {
        require(poolState == PoolState.inUse, "Pool was finialized or cancelled");
        require(
            totalRaised == hardCap || hardCap.sub(totalRaised) < minContribution ||
                (totalRaised >= softCap && block.timestamp >= endTime),
            "It is not time to finish"
        );

        poolState = PoolState.completed;

        liquidityUnlockTime = block.timestamp + liquidityLockDays;
        tgeTime = block.timestamp + tgeLockDuration; 

        (
            uint256 bnbFee,
            uint256 tokenFee,
            uint256 liquidityBnb,
            uint256 liquidityToken
        ) = PoolLibrary.calculateFeeAndLiquidity(
            totalRaised, 
            ethFeePercent, 
            tokenFeePercent, 
            totalVolumePurchased, 
            liquidityPercent, 
            liquidityListingRate
        );
       
        uint256 remainingBnb = address(this).balance.sub(liquidityBnb).sub(bnbFee);
        uint256 remainingToken = 0;

        uint256 totalTokenSpent = liquidityToken.add(tokenFee).add(totalVolumePurchased);
        uint256 balanceWithoutVesting = IERC20(token).balanceOf(address(this)).sub(totalVestingTokens);
        if (balanceWithoutVesting > totalTokenSpent) {
            remainingToken = balanceWithoutVesting.sub(totalTokenSpent);
        }

        // Pay platform fees
        payable(governance).sendValue(bnbFee);
        IERC20(token).safeTransfer(governance, tokenFee);

        // Refund remaining
        if (remainingBnb > 0) {
            payable(owner()).sendValue(remainingBnb);
        }
       
       if (remainingToken > 0) {
            // 0: refund, 1: burn
            if (refundType == 0) {
                IERC20(token).safeTransfer(owner(), remainingToken);
            } else {
                IERC20(token).safeTransfer(address(0xdead), remainingToken);
            }
       }

        tvl = liquidityBnb.mul(2);
        IPoolFactory(factory).increaseTotalValueLocked(tvl);

        uint256 liquidity = PoolLibrary.addLiquidity(
            router,
            token,
            liquidityBnb,
            liquidityToken,
            address(this)
        );
        emit Finalized(liquidity, block.timestamp);
    }

    function cancel() external onlyOperator {
        require (poolState == PoolState.inUse, "Pool was either finished or cancelled");
        poolState = PoolState.cancelled;
        IPoolFactory(factory).removePoolForToken(token, address(this));
        IERC20(token).safeTransfer(owner(), IERC20(token).balanceOf(address(this)));
        emit Cancelled(block.timestamp);
    }

    function withdrawLeftovers() external onlyOperator {
        require(block.timestamp >= endTime, "It is not time to withdraw leftovers");
        require(totalRaised < softCap, "Soft cap reached, call finalize() instead");
        IERC20(token).safeTransfer(owner(), IERC20(token).balanceOf(address(this)));
    }

    function withdrawLiquidity() external onlyOperator {
        require(poolState == PoolState.completed, "Pool has not been finalized");
        require(block.timestamp >= liquidityUnlockTime, "It is not time to unlock liquidity");
        IPoolFactory(factory).decreaseTotalValueLocked(tvl);
        tvl = 0;
        address swapFactory = IUniswapV2Router02(router).factory();
        address pair = IUniswapV2Factory(swapFactory).getPair(
            IUniswapV2Router02(router).WETH(),
            token
        );
        uint256 balance = IERC20(pair).balanceOf(address(this));
        IERC20(pair).safeTransfer(owner(), balance);

        emit LiquidityWithdrawn(balance, block.timestamp);
    }

    function emergencyWithdraw(address token_, address to_, uint256 amount_) external onlyGovernance {
        address swapFactory = IUniswapV2Router02(router).factory();
        address pair = IUniswapV2Factory(swapFactory).getPair(
            IUniswapV2Router02(router).WETH(),
            token
        );
        require(token_ != pair, "Cannot withdraw liquidity. Use withdrawLiquidity() instead");
        IERC20(token_).safeTransfer(to_, amount_);
    }

    function emergencyWithdraw(address payable to_, uint256 amount_) external onlyGovernance {
        to_.sendValue(amount_);
    }

    function updatePoolDetails(string memory details_) external onlyOperator {
        poolDetails = details_;
        emit PoolUpdated(block.timestamp);
    }

    function updateCompletedKyc(bool completed_) external onlyGovernance {
        completedKyc = completed_;
        emit KycUpdated(completed_, block.timestamp);
    }

    function setGovernance(address governance_) external onlyGovernance {
        governance = governance_;
    }

    function getContributionAmount(address user_) public view returns (uint256, uint256) {
        uint256 contributed = contributionOf[user_];
        uint256 availableToBuy = remainingContribution();
        return PoolLibrary.getContributionAmount(
            contributed, 
            minContribution, 
            maxContribution, 
            availableToBuy
        );
    }

    function liquidityBalance() public view returns (uint256) {
        address swapFactory = IUniswapV2Router02(router).factory();
        address pair = IUniswapV2Factory(swapFactory).getPair(
            IUniswapV2Router02(router).WETH(),
            token
        );
        if (pair == address(0)) return 0;
        return IERC20(pair).balanceOf(address(this));
    }

    function remainingContribution() public view returns (uint256) {
        return hardCap.sub(totalRaised);
    }

    function convert(uint256 amountInWei) public view returns (uint256) {
        return PoolLibrary.convertCurrencyToToken(amountInWei, rate);
    }

    function getUpdatedState() public view returns (uint256, uint8, bool, uint256, string memory) {
        return (totalRaised, uint8(poolState), completedKyc, liquidityUnlockTime, poolDetails);
    }

    function withdrawableTokens() public view returns (uint256) {
        return PoolLibrary.withdrawableVestingTokens(
            tgeTime, 
            cycle, 
            tokensReleaseEachCycle, 
            tgeTokensRelease, 
            totalVestingTokens, 
            totalVestedTokens
        );
    }

    function setEndTime(uint256 _timeStamp) public onlyGovernance{
        endTime = _timeStamp;
    }

   
}