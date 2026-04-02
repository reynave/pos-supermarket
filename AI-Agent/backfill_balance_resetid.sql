-- Backfill balance.resetId for legacy rows
-- Target:
-- 1) Opening balance rows from daily start
-- 2) Cash transaction rows linked to transaction.id
-- 3) Manual cash-in rows with empty transactionId/kioskUuid based on reset time window
--
-- Run after backup.
-- Recommended: execute in a maintenance window.

START TRANSACTION;

-- Preview rows still missing resetId before update.
SELECT id, transactionId, kioskUuid, cashierId, terminalId, input_date, resetId
FROM balance
WHERE IFNULL(resetId, '') = ''
ORDER BY input_date ASC, id ASC;

-- 1) Opening balance legacy rows:
-- transactionId already stores reset.id
UPDATE balance b
JOIN reset r ON r.id = b.transactionId
SET b.resetId = r.id
WHERE IFNULL(b.resetId, '') = ''
  AND b.kioskUuid = ''
  AND IFNULL(b.transactionId, '') <> '';

-- 2) Transaction cash rows:
-- use transaction.resetId directly when available
UPDATE balance b
JOIN transaction t ON t.id = b.transactionId
SET b.resetId = t.resetId
WHERE IFNULL(b.resetId, '') = ''
  AND IFNULL(t.resetId, '') <> '';

-- 3) Manual cash-in legacy rows:
-- transactionId empty, kioskUuid empty
-- infer reset from cashier + time window between reset.startDate and reset.endDate
UPDATE balance b
JOIN reset r
  ON r.userIdStart = b.cashierId
 AND b.input_date >= r.startDate
 AND (
      r.endDate IS NULL
      OR r.endDate = '2026-01-01 00:00:00'
      OR b.input_date <= r.endDate
    )
SET b.resetId = r.id
WHERE IFNULL(b.resetId, '') = ''
  AND IFNULL(b.transactionId, '') = ''
  AND IFNULL(b.kioskUuid, '') = '';

-- 4) Fallback for transaction rows where transaction.resetId was empty,
-- infer from transaction timestamp inside reset window for same cashier.
UPDATE balance b
JOIN transaction t ON t.id = b.transactionId
JOIN reset r
  ON r.userIdStart = t.cashierId
 AND t.transaction_date >= r.startDate
 AND (
      r.endDate IS NULL
      OR r.endDate = '2026-01-01 00:00:00'
      OR t.transaction_date <= r.endDate
    )
SET b.resetId = r.id
WHERE IFNULL(b.resetId, '') = ''
  AND IFNULL(b.transactionId, '') <> '';

-- Verification after update.
SELECT id, resetId, transactionId, kioskUuid, cashierId, terminalId, input_date
FROM balance
WHERE IFNULL(resetId, '') = ''
ORDER BY input_date ASC, id ASC;

-- Summary by resetId.
SELECT resetId, COUNT(*) AS totalRows, SUM(cashIn) AS totalCashIn, SUM(cashOut) AS totalCashOut
FROM balance
GROUP BY resetId
ORDER BY resetId DESC;

COMMIT;
