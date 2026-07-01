SELECT *
FROM mission3_dataset;

# Cleaning tipis
-- Ganti nama record (Packages dan Travel & Leisure (Flight
SELECT * FROM mission3_dataset 
WHERE Purchase_Category = 'Packages)';

UPDATE mission3_dataset
SET Purchase_Category = 'Packages'
WHERE Purchase_Category = 'Packages)';

SELECT * FROM mission3_dataset 
WHERE Purchase_Category = 'Travel & Leisure (Flights';

UPDATE mission3_dataset
SET Purchase_Category = 'Travel & Leisure Flights'
WHERE Purchase_Category = 'Travel & Leisure (Flights';

SELECT DISTINCT Purchase_Category 
FROM mission3_dataset;

-- Mencari data NULL atau BLANK
SELECT * FROM mission3_dataset WHERE Frequency_of_Purchase IS NULL;
SELECT * FROM mission3_dataset WHERE Frequency_of_Purchase = '';

SELECT DISTINCT Frequency_of_Purchase 
FROM mission3_dataset
ORDER BY Frequency_of_Purchase ASC;

## Jawab Pertanyaan
# No. 1
SELECT COUNT(*) AS total_transaksi_perempuan
FROM mission3_dataset
WHERE Gender = 'Female';

# No. 2
SELECT Location, COUNT(DISTINCT Customer_ID) AS total_customers
FROM mission3_dataset
GROUP BY Location
ORDER BY total_customers DESC
LIMIT 5;

# No. 3
SELECT Discount_Used, COUNT(*) AS total
FROM mission3_dataset
WHERE Brand_Loyalty = 5
GROUP BY Discount_Used;

# No. 4
SELECT Purchase_Intent, 
       ROUND(AVG(Purchase_Amount), 0) AS avg_amount, 
       ROUND(AVG(Frequency_of_Purchase), 2) AS avg_frequency
FROM mission3_dataset
GROUP BY Purchase_Intent
ORDER BY avg_amount DESC;

# No. 5
SELECT Purchase_Channel, 
       ROUND(AVG(Purchase_Amount), 0) AS avg_amount, 
       ROUND(AVG(Frequency_of_Purchase), 2) AS avg_frequency
FROM mission3_dataset
GROUP BY Purchase_Channel;

# No. 6
SELECT Customer_Loyalty_Program_Member, 
       ROUND(AVG(Purchase_Amount), 0) AS avg_amount, 
       ROUND(AVG(Frequency_of_Purchase), 2) AS avg_frequency
FROM mission3_dataset
GROUP BY Customer_Loyalty_Program_Member;

# No.7
SELECT Customer_ID, 
       SUM(Purchase_Amount) AS total_spent, 
       MAX(Location) AS Location, 
       MAX(Purchase_Channel) AS Channel, 
       MAX(Brand_Loyalty) AS Brand_Loyalty
FROM mission3_dataset
GROUP BY Customer_ID
ORDER BY total_spent DESC
LIMIT 10;


# # Analisis Tambahan

# No. 8
SELECT Location, 
       ROUND(AVG(Purchase_Amount), 0) as avg_spend,
       SUM(CASE WHEN Customer_Loyalty_Program_Member = 'TRUE' THEN 1 ELSE 0 END) as total_member,
       COUNT(*) as total_customers
FROM mission3_dataset
GROUP BY Location
HAVING avg_spend > (SELECT AVG(Purchase_Amount) FROM mission3_dataset)
ORDER BY avg_spend DESC;

-- alternative
SELECT 
    Location, 
    Income_Level,
    ROUND(AVG(Purchase_Amount), 0) as Avg_Spend,
    COUNT(Customer_ID) as Customer_Count
FROM mission3_dataset
GROUP BY Location, Income_Level
HAVING COUNT(Customer_ID) > 5 -- Filter agar data yang muncul relevan secara statistik
ORDER BY Avg_Spend DESC, mission3_dataset;

-- 
SELECT 
    Location, 
    Income_Level,
    Gender,
    Purchase_Intent,
    ROUND(AVG(Purchase_Amount), 0) as Avg_Spend,
    COUNT(Customer_ID) as Total_Customers,
    -- Memisahkan jumlah member dan non-member untuk strategi kampanye
    SUM(CASE WHEN Customer_Loyalty_Program_Member = 'TRUE' THEN 1 ELSE 0 END) as Existing_Members,
    SUM(CASE WHEN Customer_Loyalty_Program_Member = 'FALSE' THEN 1 ELSE 0 END) as Potential_New_Members
FROM mission3_dataset
GROUP BY 
    Location, 
    Income_Level, 
    Gender, 
    Purchase_Intent
HAVING 
    -- 1. Filter agar data relevan secara statistik (minimal ada 5 orang dalam satu segmen)
    COUNT(Customer_ID) > 5 
    -- 2. Filter hanya segmen yang memiliki daya beli di atas rata-rata perusahaan
    AND AVG(Purchase_Amount) > (SELECT AVG(Purchase_Amount) FROM mission3_dataset)
ORDER BY Potential_New_Members DESC, Avg_Spend DESC, Total_Customers DESC;
--
-- yg dipake ini yg di bawah
SELECT 
    Location, 
    Income_Level,
    Gender,
    Purchase_Intent,
    ROUND(AVG(Purchase_Amount), 0) as Avg_Spend,
    COUNT(Customer_ID) as Total_Customers,
    SUM(CASE WHEN Customer_Loyalty_Program_Member = 'TRUE' THEN 1 ELSE 0 END) as Existing_Members,
    SUM(CASE WHEN Customer_Loyalty_Program_Member = 'FALSE' THEN 1 ELSE 0 END) as Potential_New_Members
FROM mission3_dataset
GROUP BY 
    Location, 
    Income_Level, 
    Gender, 
    Purchase_Intent
HAVING 
    COUNT(Customer_ID) > 5
    AND AVG(Purchase_Amount) > (SELECT AVG(Purchase_Amount) FROM mission3_dataset)
ORDER BY Potential_New_Members DESC
LIMIT 3;

# No. 9
SELECT Purchase_Category, 
       Purchase_Channel, 
       Purchase_Intent,
       COUNT(*) as frequency
FROM mission3_dataset
WHERE Brand_Loyalty = 5
GROUP BY Purchase_Category, Purchase_Channel, Purchase_Intent
ORDER BY frequency DESC;

-- alternative
SELECT 
    Purchase_Category,
    ROUND(AVG(Purchase_Amount), 0) as Avg_Spend,
    Frequency_of_Purchase,
    COUNT(Customer_ID) as No_of_Customer
FROM mission3_dataset
WHERE Brand_Loyalty = 5
GROUP BY Frequency_of_Purchase, Purchase_Category
ORDER BY Frequency_of_Purchase DESC, Avg_Spend DESC;

-- code fix
SELECT 
    Purchase_Category,
    Purchase_Intent,
    ROUND(AVG(Purchase_Amount), 0) as Avg_Spend,
    ROUND(AVG(Frequency_of_Purchase), 0) as Avg_Frequency 
FROM mission3_dataset
WHERE Brand_Loyalty = 5
GROUP BY 
    Purchase_Category, 
    Purchase_Intent
ORDER BY Avg_Spend DESC;

SELECT ROUND(AVG(Purchase_Amount), 0)
FROM mission3_dataset;

# No. 10
SELECT Discount_Used, 
       ROUND(AVG(Product_Rating), 1) as avg_rating,
       Purchase_Intent,
       COUNT(*) as customer_count
FROM mission3_dataset
GROUP BY Discount_Used, Purchase_Intent;

-- code fix
SELECT 
    Discount_Used,
    ROUND(AVG(Brand_Loyalty), 2) as Avg_Loyalty_Score,
    COUNT(Customer_ID) as Total_Customers,
    GROUP_CONCAT(DISTINCT Purchase_Intent) as Common_Intents
FROM mission3_dataset
GROUP BY Discount_Used;

