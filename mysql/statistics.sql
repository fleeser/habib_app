# Anzahl der verliehenen Bücher

WITH months AS (
    SELECT 1 AS month
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
    UNION ALL SELECT 10
    UNION ALL SELECT 11
    UNION ALL SELECT 12
)
SELECT
    m.month,
    COUNT(b.book_id) AS books_count
FROM
    months m
LEFT JOIN (
    SELECT
        MONTH(borrows.created_at) AS month,
        borrows.book_id
    FROM
        borrows
    WHERE 
        YEAR(borrows.created_at) = 2024
) b ON m.month = b.month
GROUP BY 
    m.month
ORDER BY 
    m.month;

# Wie viele von den neuen Büchern sind gekauft / geschenkt

WITH months AS (
    SELECT 1 AS month
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
    UNION ALL SELECT 10
    UNION ALL SELECT 11
    UNION ALL SELECT 12
)
SELECT
    m.month,
    COALESCE(b.bought_0_count, 0) AS bought_0_count,
    COALESCE(b.bought_1_count, 0) AS bought_1_count
FROM
    months m
LEFT JOIN (
    SELECT
        MONTH(books.received_at) AS month,
        SUM(CASE WHEN books.bought = 0 THEN 1 ELSE 0 END) AS bought_0_count,
        SUM(CASE WHEN books.bought = 1 THEN 1 ELSE 0 END) AS bought_1_count
    FROM
        books
    WHERE
        YEAR(books.received_at) = 2024
    GROUP BY
        MONTH(books.received_at)
) b ON m.month = b.month
ORDER BY
    m.month;