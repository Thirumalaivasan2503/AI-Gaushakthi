/**
 * Frontend Auth & OTP Verification Unit Tests
 */

// Mobile Number Validation helper
export function validateIndianMobile(phoneNum: string): boolean {
  const cleaned = phoneNum.replace(/\D/g, '');
  return cleaned.length === 10 && /^[6-9]\d{9}$/.test(cleaned);
}

// 6-digit OTP formatting & parsing helper
export function parseOtpInput(pastedString: string): string[] {
  const digits = pastedString.replace(/\D/g, '').slice(0, 6);
  const result = ['', '', '', '', '', ''];
  for (let i = 0; i < digits.length; i++) {
    result[i] = digits[i];
  }
  return result;
}

// Simple test runner for verification
export function runAuthUnitTests(): { total: number; passed: number; failed: number } {
  let passed = 0;
  let total = 0;

  function assert(condition: boolean, msg: string) {
    total++;
    if (condition) {
      passed++;
      console.log(`[PASS] ${msg}`);
    } else {
      console.error(`[FAIL] ${msg}`);
    }
  }

  // 1. Mobile number validation tests
  assert(validateIndianMobile('9876543210') === true, 'Valid 10-digit Indian mobile (9876543210)');
  assert(validateIndianMobile('6381294051') === true, 'Valid 10-digit Indian mobile starting with 6');
  assert(validateIndianMobile('1234567890') === false, 'Invalid mobile starting with 1');
  assert(validateIndianMobile('987654321') === false, 'Invalid 9-digit length mobile');
  assert(validateIndianMobile('98765432100') === false, 'Invalid 11-digit length mobile');

  // 2. 6-digit OTP paste parsing tests
  const parsed = parseOtpInput('849201');
  assert(parsed.join('') === '849201', 'Pasted 6-digit OTP correctly parsed');
  assert(parsed.length === 6, 'OTP array length is 6');

  const partialParsed = parseOtpInput('123');
  assert(partialParsed.join('') === '123', 'Partial pasted 3-digit OTP handled');
  assert(partialParsed[3] === '', '4th digit empty on partial paste');

  console.log(`Auth Unit Tests Result: ${passed}/${total} Passed.`);
  return { total, passed, failed: total - passed };
}

// Execute tests on import
runAuthUnitTests();
