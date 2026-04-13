const DEFAULT_BCA_LAN_PORT = 80;
const DEFAULT_TIMEOUT_MS = 60000;
const DEFAULT_MIN_RESPONSE_LENGTH = 50;

function normalizeEnvText(value) {
  if (value === undefined || value === null) return '';

  let text = String(value).trim();
  if (!text) return '';

  if (
    (text.startsWith('"') && text.endsWith('"')) ||
    (text.startsWith("'") && text.endsWith("'"))
  ) {
    text = text.slice(1, -1);
  }

  return text;
}

function getDefaultEchoPayload() {
  return normalizeEnvText(
    process.env.ECHOTESTBCA
      || process.env.BCA_LAN_ECHO_TEST
      || process.env.ECHOTESTBCA_V2
      || process.env.ECHOTESTBCA_V1
      || process.env.ECHOTESTBCA_V3,
  );
}

function getEchoPayloadByVersion(version) {
  const ver = String(version || '').trim();

  if (ver === '1') {
    return normalizeEnvText(process.env.ECHOTESTBCA_V1) || getDefaultEchoPayload();
  }
  if (ver === '2') {
    return normalizeEnvText(process.env.ECHOTESTBCA_V2) || getDefaultEchoPayload();
  }
  if (ver === '3') {
    return normalizeEnvText(process.env.ECHOTESTBCA_V3) || getDefaultEchoPayload();
  }

  return getDefaultEchoPayload();
}

function getDefaultLanPort() {
  return Number(
    normalizeEnvText(process.env.ENV_PORT)
      || normalizeEnvText(process.env.BCA_LAN_PORT)
      || DEFAULT_BCA_LAN_PORT,
  );
}

function getDefaultLanIp() {
  return normalizeEnvText(process.env.BCA_LAN_IP);
}

function getDefaultTimeoutMs() {
  return Number(normalizeEnvText(process.env.BCA_LAN_TIMEOUT_MS) || DEFAULT_TIMEOUT_MS);
}

function getDefaultMinResponseLength() {
  return Number(
    normalizeEnvText(process.env.BCA_LAN_MIN_RESPONSE_LENGTH) || DEFAULT_MIN_RESPONSE_LENGTH,
  );
}

function parseRawPayload(payload) {
  if (!payload) return Buffer.alloc(0);
  if (Buffer.isBuffer(payload)) return payload;

  const text = String(payload);
  if (text.startsWith('hex:')) {
    const hex = text.slice(4).replace(/\s+/g, '');
    return Buffer.from(hex, 'hex');
  }

  return Buffer.from(text, 'latin1');
}

module.exports = {
  DEFAULT_BCA_LAN_PORT,
  DEFAULT_TIMEOUT_MS,
  DEFAULT_MIN_RESPONSE_LENGTH,
  normalizeEnvText,
  getDefaultEchoPayload,
  getEchoPayloadByVersion,
  getDefaultLanPort,
  getDefaultLanIp,
  getDefaultTimeoutMs,
  getDefaultMinResponseLength,
  parseRawPayload,
};