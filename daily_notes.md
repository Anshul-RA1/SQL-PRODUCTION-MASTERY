actual execution order PostgreSQL follows internally:

Order you WRITE it: Order PostgreSQL EXECUTES it:
────────────────── ──────────────────────────────

1. SELECT ------> 1. FROM → which table?
2. FROM -----> 2. WHERE → filter rows
3. WHERE -----> 3. GROUP BY → group rows (Day 6)
4. GROUP BY -----> 4. HAVING → filter groups (Day 8)
5. HAVING ----> 5. SELECT → pick columns
6. ORDER BY ---> 6. ORDER BY → sort results
7. LIMIT -----> 7. LIMIT → cut results

order u write --> 1,2,3,4,5,6,7
order posgres exec --> 2,3,4,5,1,6,7
