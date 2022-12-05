pragma solidity ^0.6.0;

contract PaymentStream {
  // Address of the recipient of the payment stream
  address payable recipient;

  // The amount to be paid per interval
  uint256 paymentAmount;

  // The interval, in seconds, at which payments should be made
  uint256 interval;

  // The starting timestamp for the payment stream
  uint256 startTime;

  // The ending timestamp for the payment stream
  uint256 endTime;

  // The total amount paid so far
  uint256 totalPaid;

  constructor(
    address payable _recipient,
    uint256 _paymentAmount,
    uint256 _interval,
    uint256 _startTime,
    uint256 _endTime
  ) public {
    recipient = _recipient;
    paymentAmount = _paymentAmount;
    interval = _interval;
    startTime = _startTime;
    endTime = _endTime;
  }

  // This function is called by a timer to make regular payments
  function makePayment() public {
    // Check if the current time is within the payment period
    if (now >= startTime && now <= endTime) {
      // Check if the recipient is still able to receive payments
      if (recipient.send(paymentAmount)) {
        totalPaid += paymentAmount;
      }
    }
  }

  // This function can be called by the recipient to end the payment stream early
  function cancel() public {
    // Only the recipient can cancel the payment stream
    require(msg.sender == recipient, "Only the recipient can cancel the payment stream");

    // Set the end time to the current time to stop future payments
    endTime = now;
  }
}
