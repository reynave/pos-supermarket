const net = require('net');
const pool = require('../config/database');
const { addLogs, respLogs } = require('../utils/bca-lan.logs');
const {
  DEFAULT_BCA_LAN_PORT,
  getDefaultLanIp,
  getDefaultLanPort,
  getDefaultTimeoutMs,
  getDefaultMinResponseLength,
  getDefaultEchoPayload,
  parseRawPayload,
} = require('../utils/bca-lan.config');
const {
  buildBcaLanPacket,
  parseResponse,
  buildFailureResp,
} = require('../utils/bca-lan.protocol');

async function findPaymentTypeById(id) {
  const [rows] = await pool.query(
    `SELECT id, name, connectionType, ip, port
     FROM payment_type
     WHERE id = ?
     LIMIT 1`,
    [id],
  );

  return rows[0] || null;
}

async function resolveConnection({ paymentTypeId, ip, port }) {
  const defaultLanPort = getDefaultLanPort();

  if (ip) {
    return {
      ip,
      port: Number(port || defaultLanPort),
      source: 'request',
    };
  }

  if (!paymentTypeId) {
    const defaultLanIp = getDefaultLanIp();

    if (defaultLanIp) {
      return {
        ip: defaultLanIp,
        port: Number(port || defaultLanPort),
        source: 'env',
      };
    }

    throw new Error('Either paymentTypeId/ip request param or BCA_LAN_IP env is required');
  }

  const paymentType = await findPaymentTypeById(paymentTypeId);
  if (!paymentType) {
    throw new Error('Payment type not found');
  }

  if (!paymentType.ip) {
    throw new Error('Payment type does not have IP configured');
  }

  return {
    ip: paymentType.ip,
    port: Number(paymentType.port || defaultLanPort),
    source: 'payment_type',
    paymentType,
  };
}

function sendLanPacket({ ip, port, packet, timeoutMs, minResponseLength }) {
  return new Promise((resolve, reject) => {
    const client = new net.Socket();
    let resolved = false;
    let responseBuffer = Buffer.alloc(0);
    const effectiveTimeoutMs = Number(timeoutMs || getDefaultTimeoutMs());
    const effectiveMinResponseLength = Number(minResponseLength || getDefaultMinResponseLength());

    const onDone = (err, data) => {
      if (resolved) return;
      resolved = true;
      clearTimeout(timer);
      client.removeAllListeners();
      client.destroy();

      if (err) {
        reject(err);
      } else {
        resolve(data);
      }
    };

    const timer = setTimeout(() => {
      onDone(new Error('Timeout waiting for response'));
    }, effectiveTimeoutMs);

    client.on('data', (chunk) => {
      responseBuffer = Buffer.concat([responseBuffer, chunk]);

      try {
        client.write('\x06');
      } catch (_err) {
        // ignore ACK write errors, main response is still captured in buffer
      }

      if (responseBuffer.length >= effectiveMinResponseLength) {
        onDone(null, responseBuffer);
      }
    });

    client.on('error', (err) => {
      onDone(new Error(`Connection error: ${err.message}`));
    });

    client.on('close', () => {
      if (!resolved && responseBuffer.length > 0) {
        onDone(null, responseBuffer);
      }
    });

    client.connect({ host: ip, port: Number(port || getDefaultLanPort()) }, () => {
      client.write(packet);
    });
  });
}

async function executeBcaLanPayment(payload) {
  const connection = await resolveConnection(payload);
  const packetData = buildBcaLanPacket({
    amount: payload.amount,
    transType: payload.transType || '01',
    reffNumber: payload.reffNumber,
    dummyCc: String(process.env.DUMMYCC || '0') === '1',
  });

  try {
    const raw = await sendLanPacket({
      ip: connection.ip,
      port: connection.port,
      packet: packetData.packet,
      timeoutMs: payload.timeoutMs,
    });

    const responseMessage = raw.toString('latin1');
    const resp = parseResponse(raw, 3);
    const approved = resp.RespCode === '00';

    return {
      success: approved,
      message: approved ? 'Transaction approved' : 'Transaction declined',
      responseMessage,
      requestMessage: packetData.postDataNote,
      resp,
      connection,
    };
  } catch (err) {
    return {
      success: false,
      message: err.message,
      responseMessage: '',
      requestMessage: packetData.postDataNote,
      resp: buildFailureResp('S2'),
      connection,
    };
  }
}

async function echoTestBcaLan(payload) {
  const connection = await resolveConnection(payload);
  const echoPayload = getDefaultEchoPayload();
  const timeoutMs = Number(payload.timeoutMs || getDefaultTimeoutMs());

  if (!echoPayload) {
    throw new Error('BCA_LAN_ECHO_TEST or ECHOTESTBCA env is required');
  }

  return new Promise((resolve) => {
    const client = new net.Socket();
    const requestPacket = parseRawPayload(echoPayload);
    const date = `${new Date()} ${connection.ip}`;
    let finished = false;
    let responseBuffer = Buffer.alloc(0);

    addLogs('');
    addLogs(date);

    const finish = (result) => {
      if (finished) return;
      finished = true;
      clearTimeout(timer);
      client.destroy();
      resolve({
        ...result,
        connection,
      });
    };

    client.connect({ host: connection.ip, port: connection.port }, () => {
      console.log(`[BCA LAN] echo-test server on ${connection.ip}:${connection.port}`);
      addLogs(`echoTestBCA ${echoPayload}`);
      client.write(requestPacket);
    });

    client.on('data', (data) => {
      responseBuffer = Buffer.concat([responseBuffer, data]);
      console.log('[BCA LAN] Received data from EDC:', data.toString('latin1'));

      try {
        client.write('\x06');
      } catch (_err) {
        // ignore ACK errors during socket shutdown
      }

      if (responseBuffer.toString('latin1').length > getDefaultMinResponseLength()) {
        const response = {
          success: true,
          message: 'Echo test success',
          responseMessage: responseBuffer.toString('latin1'),
          resp: parseResponse(responseBuffer, 3),
        };

        addLogs(JSON.stringify(response));
        respLogs(response.responseMessage);
        finish(response);
      }
    });

    client.on('error', (err) => {
      console.error('[BCA LAN] Connection error:', err.message);
      const response = {
        success: false,
        message: 'Connection error',
        errorDetail: err.message,
        resp: buildFailureResp('S2'),
      };

      addLogs(JSON.stringify(response));
      respLogs(`Connection error ${connection.ip}: ${err.message}`);
      finish(response);
    });

    client.on('close', () => {
      console.log('[BCA LAN] Connection closed');
    });

    const timer = setTimeout(() => {
      const response = {
        success: false,
        message: 'Timeout waiting for response',
        resp: buildFailureResp('S2'),
      };

      addLogs(JSON.stringify(response));
      respLogs(`Timeout ${connection.ip}`);
      finish(response);
    }, timeoutMs);
  });
}

module.exports = {
  executeBcaLanPayment,
  echoTestBcaLan,
};
