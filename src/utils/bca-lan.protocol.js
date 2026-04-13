const STX = '\x02';
const ETX = '\x03';

const RESPONSE_MAP = {
  '  ': 'Null',
  '00': 'Approve',
  '54': 'Decline Expired Card',
  '55': 'Decline Incorrect PIN',
  P2: 'Read Card Error',
  P3: 'User press Cancel on EDC',
  Z3: 'EMV Card Decline',
  CE: 'Connection Error/Line Busy',
  TO: 'Connection Timeout',
  PT: 'EDC Problem',
  aa: 'Decline (aa represent two digit alphanumeric value from EDC)',
  S2: 'TRANSAKSI GAGAL, ULANGI TRANSAKSI DI EDC',
  S3: 'TXN BLM DIPROSES, MINTA SCAN QR, S4 TXN EXPIRED',
};

function msgToBinArr(msg) {
  return msg.split('').map((char) => binToArry(hex2bin(textToHex(char))));
}

function textToHex(text) {
  let hexString = '';
  for (let i = 0; i < text.length; i += 1) {
    hexString += text.charCodeAt(i).toString(16).padStart(2, '0');
  }
  return hexString;
}

function binToArry(msg) {
  return msg.split('').map((n) => parseInt(n, 10));
}

function hex2bin(hex) {
  let binaryString = '';
  for (let i = 0; i < hex.length; i += 2) {
    const hexPair = hex.substr(i, 2);
    const decimal = parseInt(hexPair, 16);
    binaryString += decimal.toString(2).padStart(8, '0');
  }
  return binaryString;
}

function pad(num, size) {
  const str = `000000000${num}`;
  return str.substr(str.length - size);
}

function xorOperation(arrays) {
  if (!arrays.length) return null;
  const result = arrays[0].slice();

  for (let i = 1; i < arrays.length; i += 1) {
    const currentArray = arrays[i];
    if (currentArray.length !== result.length) return null;

    for (let j = 0; j < result.length; j += 1) {
      result[j] = result[j] !== currentArray[j] ? 1 : 0;
    }
  }

  return result;
}

function binaryArrayToHex(binaryArray) {
  let hexString = '';
  for (let i = 0; i < binaryArray.length; i += 4) {
    const binaryDigits = binaryArray.slice(i, i + 4).join('');
    hexString += parseInt(binaryDigits, 2).toString(16).toUpperCase();
  }
  return hexString;
}

function toFixedLength(value, length) {
  const safe = String(value || '');
  return safe.padEnd(length, ' ').slice(0, length);
}

function buildBcaLanPacket({ amount, transType = '01', reffNumber, dummyCc = false }) {
  const version = '\x02';

  let transAmount = String(amount || 0).padStart(10, '0') + '00';
  if (transType === '32') {
    transAmount = ' '.repeat(12);
  }

  const otherAmount = '000000000000';
  let pan = ' '.repeat(19);
  let expireDate = '    ';

  if (dummyCc) {
    pan = '4556330000000191   ';
    expireDate = '2803';
  }

  const cancelReason = '00';
  const invoiceNumber = '000000';
  const authCode = '000000';
  const installmentFlag = ' ';
  const redeemFlag = ' ';
  const dccFlag = 'N';
  const installmentPlan = '000';
  const installmentTenor = '00';
  const genericData = ' '.repeat(12);
  const reff = toFixedLength(reffNumber || '', 12);
  const originalDate = '    ';
  const bcaFiller = ' '.repeat(50);

  const messageData =
    transAmount +
    otherAmount +
    pan +
    expireDate +
    cancelReason +
    invoiceNumber +
    authCode +
    installmentFlag +
    redeemFlag +
    dccFlag +
    installmentPlan +
    installmentTenor +
    genericData +
    reff +
    originalDate +
    bcaFiller;

  const totalLength = version.length + transType.length + messageData.length;

  const binArray = [];
  binArray.push(binToArry(hex2bin(pad(totalLength, 4).slice(0, 2))));
  binArray.push(binToArry(hex2bin(pad(totalLength, 4).slice(-2))));
  binArray.push([0, 0, 0, 0, 0, 0, 1, 0]);
  binArray.push(binToArry(hex2bin(textToHex(transType).slice(0, 2))));
  binArray.push(binToArry(hex2bin(textToHex(transType).slice(-2))));

  msgToBinArr(messageData).forEach((bits) => binArray.push(bits));
  binArray.push(binToArry(hex2bin('03')));

  const lrc = binaryArrayToHex(xorOperation(binArray));
  const body = `${STX}\x01\x50${version}${transType}${messageData}${ETX}`;

  return {
    packet: Buffer.concat([Buffer.from(body, 'latin1'), Buffer.from(lrc, 'hex')]),
    postDataNote: `${body}${lrc}`,
  };
}

function parseResponse(data, offset = 3) {
  const text = Buffer.isBuffer(data) ? data.toString('latin1') : String(data || '');
  const respCodeRaw = text.slice(offset + 50, offset + 52);
  const respCode = respCodeRaw.replace(/ +/g, '');

  return {
    length: text.length,
    TransType: text.slice(offset + 1, offset + 3).replace(/ +/g, ''),
    TransAmount: text.slice(offset + 3, offset + 15).replace(/ +/g, ''),
    PAN: text.slice(offset + 25, offset + 43).replace(/ +/g, ''),
    RespCode: respCode,
    RRN: text.slice(offset + 52, offset + 64).replace(/ +/g, ''),
    ApprovalCode: text.slice(offset + 64, offset + 70).replace(/ +/g, ''),
    DateTime: text.slice(offset + 70, offset + 84).replace(/ +/g, ''),
    MerchantId: text.slice(offset + 84, offset + 99).replace(/ +/g, ''),
    TerminalId: text.slice(offset + 99, offset + 107).replace(/ +/g, ''),
    OfflineFlag: text.slice(offset + 107, offset + 108).replace(/ +/g, ''),
    response: RESPONSE_MAP[respCodeRaw] || RESPONSE_MAP[respCode] || 'Unknown response code',
  };
}

function buildFailureResp(code = 'S2') {
  return {
    RespCode: code,
    response: RESPONSE_MAP[code] || 'Transaction failed',
  };
}

module.exports = {
  buildBcaLanPacket,
  parseResponse,
  buildFailureResp,
};
