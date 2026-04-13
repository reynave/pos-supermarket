const net = require('net');
const { Router } = require('express');
const {
    buildBcaLanPacket,
    parseResponse,
    buildFailureResp,
} = require('../utils/bca-lan.protocol');
const { addLogs, respLogs } = require('../utils/bca-lan.logs');
const {
    getDefaultEchoPayload,
    getDefaultLanPort,
    getDefaultLanIp,
} = require('../utils/bca-lan.config');

const router = Router();
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const utils = require('./../utils/utils');
const { bcaXor } = require('./../utils/bcaXor');
let STX = "\x02";
let ETX = "\x03";

/*
POST /api/payment/bca-lan/payment
Content-Type: application/json
Contoh body:

{
	"ip": "192.168.1.10",
	"port": "80",
	"amount": 15000,
	"transType": "01",
	"reffNumber": "123456789012",
	"timeoutMs": 60000
}
*/ 
router.post('/payment-VER-AI', async (req, res) => {
    const date = new Date();
    const body = { ...req.body };
    const envPort = Number(process.env.ENV_PORT || process.env.BCA_LAN_PORT || 80);
    const targetIp = body.ip || getDefaultLanIp();
    const targetPort = Number(body.port || envPort);
    const timeoutMs = Number(process.env.BCA_LAN_PAYMENT_TIMEOUT_MS || 300000);

    if (body.RNN) {
        body.reffNumber = body.RNN;
        delete body.RNN;
    }

    if (!targetIp) {
        return res.status(400).json({
            success: false,
            message: 'ip is required (or set BCA_LAN_IP in .env)',
        });
    }

    const rest = buildBcaLanPacket({
        amount: Number(body.amount || 0),
        transType: body.transType || '01',
        reffNumber: body.reffNumber,
        dummyCc: String(process.env.DUMMYCC || '0').trim() === '1',
    });

    const client = new net.Socket();
    client.connect({ host: targetIp, port: targetPort }, function () {
        console.log(`BCA server on ${targetIp}:${targetPort} ${date}`);
        console.log(`Request : ${rest.postDataNote}`);
        addLogs(`bill : ${body.bill || ''} terminalId : ${body.terminalId || ''}`);
        addLogs(`Request : ${rest.postDataNote}`);
        client.write(rest.packet);
    });

    client.on('data', function (data) {
        console.log('Response Message EDC:', data.toString('latin1'));

        try {
            client.write('\x06');
        } catch (_err) {
            // ignore ACK write errors during shutdown race
        }

        if (data.toString('latin1').length > 50) {
            const response = {
                success: true,
                message: 'Transaction approved',
                responseMessage: data.toString('latin1'),
                resp: parseResponse(data, 3),
            };

            addLogs(`Response : ${data.toString('latin1')}`);
            respLogs(data.toString('latin1'));
            client.destroy();
            res.json(response);
        }
    });

    client.on('error', function (err) {
        console.error('Connection error:', err.message);
        const response = {
            resp: {
                RespCode: 'S2',
                response: 'Bad request, please try again!',
            },
            success: false,
            message: 'Connection error',
        };

        addLogs('');
        addLogs(date.toString());
        addLogs('Response Error: Bad request, please try again!');
        respLogs(`Response Error: Bad request ${targetIp}`);

        if (!res.headersSent) {
            res.json(response);
        }
        client.destroy();
    });

    client.on('close', function () {
        console.log('Connection closed');
    });

    await sleep(timeoutMs);

    if (!res.headersSent) {
        const response = {
            success: false,
            resp: {
                RespCode: 'S2',
                response: 'Bad request, please try again!',
            },
            message: 'Timeout waiting for response',
        };

        addLogs('');
        addLogs(date.toString());
        addLogs('Response Timeout: Bad request, please try again!');
        respLogs(`Response Error: Bad request ${targetIp}`);

        res.json(response);
        client.destroy();
    }
});

/*

{
    "amount" : 42450,
    "transType" : "01",
    "ip" : "192.168.1.123"
}
*/
router.post('/payment', async (req, res) => {
    let date = new Date();
    const body = req.body;
    const cart = req.body.cart;
    const env_port = Number(req.body.port || process.env.ENV_PORT || process.env.BCA_LAN_PORT || 80);
    if (body['RNN']) {
        body['reffNumber'] = body['RNN'];
        delete body['RNN'];
    }
    console.log(body);

    const rest = bcaXor(body);

    const client = new net.Socket();
    client.connect({ host: body['ip'], port: env_port }, function () {

        console.log(`BCA server on  ${body['ip']}:${env_port} ${date} `);
        console.log('Request : ' + rest.postDataNote);
        //  console.log('Request HEX : '+strHex+ LRC);
        addLogs('bill :  ' + body['bill']+' terminalId : '+ body['terminalId']);
        addLogs('Request :  ' + rest.postDataNote);
        // addLogs('Request HEX:  ' + rest.strHex + LRC);

        client.write(rest.postData);
    });

    // Listener untuk menangkap data dari EDC
    client.on('data', function (data) {
        console.log('Response Message EDC:', data.toString());
        client.write('\x06'); // Mengirim ACK kembali ke EDC

        // Misalnya, lakukan pengecekan untuk kondisi transaksi yang diinginkan
        if (data.toString().length > 50) {
            // Jika transaksi disetujui, kirim respons JSON 
            const response = {
                success: true,
                message: 'Transaction approved',
                responseMessage: data.toString(),
                resp: utils.strToArray(data, 3),
            };
            addLogs('Response : ' + data.toString());
            respLogs(data.toString());

            client.destroy(); // Hentikan koneksi setelah selesai
            res.json(response); // Kirim respons JSON ke client
        }
    });

    // Handler untuk kesalahan koneksi
    client.on('error', function (err) {
        console.error('Connection error:', err.message);
        const response = {
            resp: {
                RespCode: 'S2',
                response: "Bad request, please try again!",
            },
            success: false,
            message: 'Connection error'
        };
        addLogs("");
        addLogs(date);
        addLogs('Response Error: Bad request, please try again!');

        respLogs('Response Error: Bad request ' + body['ip']);

        res.json(response);
        // res.status(500).json(response); // Kirim respons error JSON ke client
        client.destroy();

    });

    // Handler untuk penutupan koneksi
    client.on('close', function () {
        console.log('Connection closed');
    });

    // Tunggu selama X detik untuk respons dari EDC
    await sleep(300 * 1000); // 300 detik timeout

    // Jika tidak ada respons dari EDC dalam 10 detik, kirim timeout response
    if (!res.headersSent) {
        const response = {
            success: false,
            resp: {
                RespCode: 'S2',
                response: "Bad request, please try again!",
            },
            message: 'Timeout waiting for response'
        };
        addLogs("");
        addLogs(date);
        addLogs('Response Timeout: Bad request, please try again!');

        respLogs('Response Error: Bad request ' + body['ip']);

        res.json(response);
        // res.status(500).json(response); // Kirim respons timeout JSON ke client
        client.destroy();

    }


});
 
/*
GET /api/payment/bca-lan/echo-test
Contoh:
/api/payment/bca-lan/echo-test?ip=192.168.1.10
*/ 
router.get('/echoTest', async (req, res) => {
    const client = new net.Socket();
    const ip = req.query.ip;
    let date = new Date() + " " + ip;
    const env_port = Number(req.query.port || process.env.ENV_PORT || process.env.BCA_LAN_PORT || 80);
    const echoTestBCA = process.env.ECHOTESTBCA || getDefaultEchoPayload();
   
    console.log(`BCA 17 - server on echoTest  ${ip}:${env_port}`);
   
    addLogs("");
    addLogs(date);

    client.connect({ host: ip, port: env_port }, function () {
        console.log(`BCA 17 - server on  ${ip}:${env_port}`);
        addLogs("echoTestBCA " + echoTestBCA);
        client.write(echoTestBCA);
    });
    // Listener untuk menangkap data dari EDC
    client.on('data', function (data) {
        console.log('Received data from EDC:', data.toString());
        client.write('\x06'); // Mengirim ACK kembali ke EDC

        // Misalnya, lakukan pengecekan untuk kondisi transaksi yang diinginkan
        if (data.toString().length > 50) {
            // Jika transaksi disetujui, kirim respons JSON 

            const response = {
                success: true,
                message: 'Echo Test success',
                resp: utils.strToArray(data, 3),
            };
            addLogs(JSON.stringify(response));
            client.destroy(); // Hentikan koneksi setelah selesai
            res.json(response); // Kirim respons JSON ke client
        }
    });

    // Handler untuk kesalahan koneksi
    client.on('error', function (err) {
        console.error('Connection error:', err.message);
        const response = {
            success: false,
            message: 'Connection error'
        };
        addLogs(JSON.stringify(response));
        res.status(500).json(response); // Kirim respons error JSON ke client
        client.destroy(); // Hentikan koneksi setelah selesai
    });

    // Handler untuk penutupan koneksi
    client.on('close', function () {
        console.log('Connection closed');
    });

    // Tunggu selama 10 detik untuk respons dari EDC
    await sleep(60000); // 10 detik timeout

    // Jika tidak ada respons dari EDC dalam 10 detik, kirim timeout response
    if (!res.headersSent) {
        const response = {
            success: false,
            message: 'Timeout waiting for response'
        };
        addLogs(JSON.stringify(response));
        res.status(500).json(response); // Kirim respons timeout JSON ke client
        client.destroy(); // Hentikan koneksi setelah selesai
    }

});

// GET /api/payment/bca-lan/check
router.get('/check', (req, res) => {
    console.log('BCA LAN module check',process.env.NODE_ENV);
    return res.status(200).json({
        success: true,
        message: 'BCA LAN module ready',
        timestamp: new Date().toISOString(),
    });
});

module.exports = router;
