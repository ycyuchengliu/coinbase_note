//Question 3a 
        SELECT u.user_id, COUNT(a.account_id) AS number_of_accounts
        FROM COINBASE.PUBLIC.USERS u
        LEFT JOIN COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
        GROUP BY 1
        ORDER BY 2 DESC;

//Question 3b
        SELECT u.user_id, COUNT(DISTINCT(a.currency)) AS number_of_distinct_currencies
        FROM COINBASE.PUBLIC.USERS u
        LEFT JOIN COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
        GROUP BY 1
        ORDER BY 2 DESC;

//Question 3c
        SELECT u.user_id, u.created_at, DATEDIFF('day', u.created_at, MIN(l.created_at)) AS days_to_first_deposit
        FROM COINBASE.PUBLIC.USERS u
        JOIN COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
        JOIN COINBASE.PUBLIC.LEDGER l ON a.account_id = l.account_id
        WHERE l.amount > 0
        GROUP BY 1,2
        ORDER BY 3 DESC;

//Question 3d
        SELECT u.user_id,
            MIN(CASE WHEN l.amount > 0 THEN l.created_at END) AS first_deposit,
            MIN(CASE WHEN l.amount < 0 THEN l.created_at END) AS first_withdrawal,
            DATEDIFF(
                'day', 
                MIN(CASE WHEN l.amount > 0 THEN l.created_at END),
                MIN(CASE WHEN l.amount < 0 THEN l.created_at END)
            ) AS days_between_first_deposit_and_withdrawal
        FROM 
            COINBASE.PUBLIC.USERS u
        JOIN 
            COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
        JOIN 
            COINBASE.PUBLIC.LEDGER l ON a.account_id = l.account_id
        GROUP BY 1
        HAVING days_between_first_deposit_and_withdrawal IS NOT NULL
        ORDER BY 4 DESC;

//Question 4a
        SELECT 
            CASE
                WHEN u.risk_score IS NULL THEN 'Unknown Risk'
                WHEN u.risk_score >= 50 THEN 'High Risk'
                WHEN u.risk_score BETWEEN 10 AND 49 THEN 'Medium Risk'
                ELSE 'Low Risk'
            END AS risk_rating,
            COUNT(l.ledger_entry_id) AS average_transaction_volume,
            AVG(l.amount) AS average_transaction_amount
        FROM 
            COINBASE.PUBLIC.USERS u
        JOIN 
            COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
        JOIN 
            COINBASE.PUBLIC.LEDGER l ON a.account_id = l.account_id
        GROUP BY 1
        ORDER BY 1;

//Question 4b
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

//Question 5a
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

//Question 5b
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
            has_multiple_accounts_and_not_all_transacted;

//Question 5c
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

//Question 5d
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
            a.currency = 'BTC' AND a.account_type = 'CryptoAccount'
        GROUP BY 
            u.user_id
        ORDER BY 
            latest_btc_transaction_time DESC;

//Question 6
        WITH failure_customers AS (
            SELECT 
                u.user_id,
                COUNT(l.ledger_entry_id) AS usd_transaction_count
            FROM 
                COINBASE.PUBLIC.USERS u
            JOIN 
                COINBASE.PUBLIC.ACCOUNTS a ON u.user_id = a.user_id
            JOIN 
                COINBASE.PUBLIC.LEDGER l ON a.account_id = l.account_id
            WHERE 
                u.risk_score >= 50
                AND a.created_at > '2017-01-01'
                AND a.currency = 'USD'
            GROUP BY 
                u.user_id
            HAVING 
                usd_transaction_count > 2
        )
        SELECT 
            (SELECT COUNT(*) FROM failure_customers) AS failed_num,
            (SELECT COUNT(*) FROM COINBASE.PUBLIC.USERS) AS total_num,
            (failed_num / total_num) * 100 AS failure_rate_percentage;

//Question 7
        SELECT l.LEDGER_ENTRY_ID,
                l. ACCOUNT_ID,
                DATE(l.created_at) AS DATE,
                l.amount, 
                a.currency AS CURRENCY_TYPE,
                a.user_id AS USER_ID
        FROM COINBASE.PUBLIC.LEDGER l
        LEFT JOIN COINBASE.PUBLIC.ACCOUNTS a
        ON l.account_id = a.account_id
        WHERE a.account_type = 'CryptoAccount'
        ORDER BY 3 ASC;