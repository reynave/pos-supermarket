const fs = require('fs');
const path = require('path');

function ensureTmpDir() {
  const dirPath = path.join(process.cwd(), '../tmp');
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
  return dirPath;
}

function getLogFilePath(prefix) {
  const date = new Date();
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const formattedDate = `${year}-${month}-${day}`;
  return path.join(ensureTmpDir(), `${prefix}_${formattedDate}.txt`);
}

function appendLog(prefix, message) {
  const filePath = getLogFilePath(prefix);
  fs.appendFile(filePath, `${message}\n`, (err) => {
    if (err) {
      console.error(`[BCA LAN] Failed writing ${prefix} log:`, err.message);
    }
  });
}

function addLogs(message) {
  appendLog('log', message);
}

function respLogs(message) {
  appendLog('resp', message);
}

module.exports = {
  addLogs,
  respLogs,
};