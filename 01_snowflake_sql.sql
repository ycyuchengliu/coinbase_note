//3. Calculate and plot the following distributions:
//Number of accounts per user.

SELECT user_id, COUNT(account_id) AS number_Of_account
FROM COINBASE.PUBLIC.ACCOUNTS
GROUP BY 1
ORDER BY 2 DESC; 

SELECT 
    u.user_id,
    COUNT(a.account_id) AS number_of_accounts
FROM 
    COINBASE.PUBLIC.USERS u
LEFT JOIN 
    COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
GROUP BY 
    1
ORDER BY 
    number_of_accounts DESC;

//Number of distinct currencies per user.
SELECT user_id, COUNT(DISTINCT(currency)) AS number_of_distinct_currencies
FROM COINBASE.PUBLIC.ACCOUNTS
GROUP BY 1
ORDER BY 2 DESC;

//Number of days it takes for users to make their first deposit.
SELECT u.user_id, u.created_at, DATEDIFF('day', u.created_at, MIN(l.created_at)) AS days_to_first_deposit
FROM COINBASE.PUBLIC.USERS u
JOIN COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
JOIN COINBASE.PUBLIC.LEDGER l ON a.account_id = l.account_id
WHERE l.amount > 0  //Assuming deposits have positive amounts
GROUP BY 1,2
ORDER BY 3;

//Number of days between a user’s first deposit and first withdrawal.
SELECT u.user_id,
    MIN(CASE WHEN l.amount > 0 THEN l.created_at END) AS first_deposit,
    MIN(CASE WHEN l.amount < 0 THEN l.created_at END) AS first_withdrawal,
    DATEDIFF(
        'day', 
        MIN(CASE WHEN l.amount > 0 THEN l.created_at END),  -- First deposit date
        MIN(CASE WHEN l.amount < 0 THEN l.created_at END)   -- First withdrawal date
    ) AS days_between_first_deposit_and_withdrawal
FROM 
    COINBASE.PUBLIC.USERS u
JOIN 
    COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
JOIN 
    COINBASE.PUBLIC.LEDGER l ON a.account_id = l.account_id
//WHERE u.user_id = '504519fbd7b1d8d86f6624d31aa0ff84'
GROUP BY 1
HAVING days_between_first_deposit_and_withdrawal IS NOT NULL
ORDER BY 4 DESC;

//4. Calculate and present the following:
//4.1 Average transaction volume for high risk, medium risk, and low risk customers 
SELECT 
    CASE
        WHEN u.risk_score IS NULL THEN 'Unknown Risk'
        WHEN u.risk_score >= 50 THEN 'High Risk'
        WHEN u.risk_score BETWEEN 10 AND 49 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_rating,
    AVG(l.amount) AS average_transaction_volume
FROM 
    COINBASE.PUBLIC.USERS u
JOIN 
    COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
JOIN 
    COINBASE.PUBLIC.LEDGER l ON a.account_id = l.account_id
GROUP BY 
    1
ORDER BY 
    1;

//4.2
WITH user_account_counts_with_risk_rating AS (
    SELECT 
        u.user_id,
        COUNT(a.account_id) AS number_of_accounts,
        CASE 
            WHEN u.risk_score IS NULL THEN 'Unknown Risk'
            WHEN u.risk_score >= 50 THEN 'High Risk'
            WHEN u.risk_score BETWEEN 10 AND 49 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS risk_rating
    FROM 
        COINBASE.PUBLIC.USERS u
    LEFT JOIN 
        COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
    GROUP BY 
        u.user_id, u.risk_score
)
SELECT risk_rating, AVG(number_of_accounts) AS average_number_of_accounts
FROM user_account_counts_with_risk_rating
GROUP BY 1
ORDER BY 1;

//5. Calculate and present the following in a table at user level:
//A True/False indicator for users with multiple crypto accounts 
SELECT 
    u.user_id,
    COUNT(a.account_id),
    CASE 
        WHEN COUNT(a.account_id) > 1 THEN 'True'
        ELSE 'False'
    END AS if_has_multiple_crypto_accounts
FROM 
    COINBASE.PUBLIC.USERS u
LEFT JOIN 
    COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
WHERE a.account_type = 'CryptoAccount'
GROUP BY 1
ORDER BY 2 ASC
;

//B. 
WITH user_crypto_accounts AS (
    SELECT 
        u.user_id,
        a.account_id,
        COUNT(l.ledger_entry_id) AS transaction_count
    FROM 
        COINBASE.PUBLIC.USERS u
    LEFT JOIN 
        COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
    LEFT JOIN 
        COINBASE.PUBLIC.LEDGER l ON a.account_id = l.account_id
    //WHERE U.USER_ID = '2e4781a5b1a1fdedda28cbe09b703857'
    WHERE a.account_type = 'CryptoAccount'
    GROUP BY 1,2
    ORDER BY 1,2
),
users_with_multiple_accounts AS (
    SELECT 
        user_id,
        SUM(CASE WHEN transaction_count = 0 THEN 1 ELSE 0 END) AS accounts_without_transactions,
        COUNT(account_id) AS total_crypto_accounts
    FROM 
        user_crypto_accounts
    GROUP BY 
        user_id
)
SELECT 
    user_id,
    CASE 
        WHEN total_crypto_accounts > 1 AND accounts_without_transactions > 0 THEN 'True'
        ELSE 'False'
    END AS has_multiple_accounts_and_not_all_transacted
FROM 
    users_with_multiple_accounts
ORDER BY 
    user_id;

//c.
SELECT 
    u.user_id,
    LISTAGG(DISTINCT a.currency, ', ') WITHIN GROUP (ORDER BY a.currency) AS transacted_currencies
FROM 
    COINBASE.PUBLIC.USERS u
JOIN 
    COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
JOIN 
    COINBASE.PUBLIC.LEDGER l ON a.account_id = l.account_id
GROUP BY 
    u.user_id
ORDER BY 
    u.user_id;

//D
SELECT 
    u.user_id,
    MAX(l.created_at) AS latest_btc_transaction_time
FROM 
    COINBASE.PUBLIC.USERS u
JOIN 
    COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
JOIN 
    COINBASE.PUBLIC.LEDGER l ON a.account_id = l.account_id
WHERE 
    a.currency = 'BTC'  AND a.account_type = 'CryptoAccount'
GROUP BY 
    u.user_id
ORDER BY 
    latest_btc_transaction_time DESC;
