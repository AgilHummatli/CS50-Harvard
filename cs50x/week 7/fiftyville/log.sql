-- First, I looked at the crime scene report to understand what happened
SELECT * FROM crime_scene_reports
WHERE street = 'Humphrey Street'
AND year = 2025 AND month = 7 AND day = 28;

-- Crime happened at 10:15 at the bakery, 3 witnesses interviewed
-- Next I read the witness interviews to get clues

SELECT * FROM interviews
WHERE year = 2025 AND month = 7 AND day = 28
AND transcript LIKE '%bakery%';

-- Ruth said thief left parking lot 10:15-10:25
-- Eugene said thief withdrew money from Leggett Street ATM
-- Raymond said thief made a short phone call and planned to fly out July 29

-- Clue 1: checking who left the bakery parking lot between 10:15 and 10:25
SELECT * FROM bakery_security_logs
WHERE year = 2025 AND month = 7 AND day = 28
AND hour = 10 AND minute >= 15 AND minute <= 25;

-- Clue 2: checking who withdrew from Leggett Street ATM that morning
SELECT * FROM atm_transactions
WHERE atm_location = 'Leggett Street'
AND year = 2025 AND month = 7 AND day = 28
AND transaction_type = 'withdraw';

-- Clue 3: checking phone calls under 1 minute on July 28
SELECT * FROM phone_calls
WHERE year = 2025 AND month = 7 AND day = 28
AND duration < 60;

-- Narrowing down suspects who match both parking lot and phone call lists
SELECT * FROM people
WHERE license_plate IN ('5P2BI95', '94KL13X', '6P58WS2', '4328GD8', 'G412CB7', 'L93JTIZ', '322W7JE', '0NTHK55')
AND phone_number IN ('(130) 555-0289', '(499) 555-9472', '(367) 555-5533', '(286) 555-6063', '(770) 555-1861', '(031) 555-6622', '(826) 555-1652', '(338) 555-6650');

-- Got 4 suspects: Sofia, Diana, Kelsey, Bruce
-- Now checking which of them also used the ATM

SELECT * FROM people
WHERE id IN (
    SELECT person_id FROM bank_accounts
    WHERE account_number IN (
        SELECT account_number FROM atm_transactions
        WHERE atm_location = 'Leggett Street'
        AND year = 2025 AND month = 7 AND day = 28
        AND transaction_type = 'withdraw'
    )
)
AND id IN (398010, 514354, 560886, 686048);

-- Down to 2 suspects: Diana and Bruce
-- Raymond said thief took earliest flight on July 29, finding that flight

SELECT * FROM flights
WHERE year = 2025 AND month = 7 AND day = 29
AND origin_airport_id = (
    SELECT id FROM airports WHERE city = 'Fiftyville'
)
ORDER BY hour ASC, minute ASC
LIMIT 1;

-- Earliest flight is flight 36 at 8:20, checking which suspect was on it

SELECT * FROM passengers
WHERE flight_id = 36
AND passport_number IN ('3592750733', '5773159633');

-- Bruce was on the flight, so Bruce is the thief
-- Now finding the accomplice, the person Bruce called on July 28

SELECT * FROM people
WHERE phone_number = (
    SELECT receiver FROM phone_calls
    WHERE caller = '(367) 555-5533'
    AND year = 2025 AND month = 7 AND day = 28
    AND duration < 60
);

-- Accomplice is Robin
-- Finally checking which city flight 36 went to

SELECT city FROM airports WHERE id = 4;

-- Thief escaped to New York City
