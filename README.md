# 🛒 GlobalMart Sales Analysis  
### End-to-End Business Intelligence with SQL, Power BI & ETL  

## 💡 Tech Stack  

![Power BI](https://img.shields.io/badge/Power_BI-FF9900?style=for-the-badge&logo=powerbi&logoColor=white)  
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-3776AB?style=for-the-badge&logo=postgresql&logoColor=white)  
![Git](https://img.shields.io/badge/Git-B1361E?style=for-the-badge&logo=git&logoColor=white)  
![VS Code](https://img.shields.io/badge/VSCode-2962FF?style=for-the-badge&logo=visual%20studio&logoColor=white)  
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)  

---

## 📌 Project Overview  

This project provides a **comprehensive business intelligence solution** for *GlobalMart*, a multinational retailer operating in multiple countries. The goal is to streamline sales tracking, consolidate data from different sources, and generate **insightful dashboards** using Power BI.

To achieve this, data from various sources (including Azure Cloud databases and CSV files) was **cleaned, transformed, and centralized** in Power BI for further analysis. The report is interactive, allowing users to **drill down into KPIs** and track sales performance over time.

Additionally, **SQL queries** were written to provide direct access to the database for deeper analysis, and a **Python-based database connector** was created to automate query execution.

> 🔹 *All data used in this project is fictional and was created solely for learning and demonstration purposes.*

---

## 🏬 Business Challenge  

**GlobalMart** faced difficulties in **tracking sales, managing customer data, and visualizing business performance** due to its scattered data sources.  
The company required:  
✅ A **centralized data model** for structured reporting  
✅ **Interactive dashboards** to track sales trends and key performance indicators (KPIs)  
✅ **SQL-based queries** to allow easy data retrieval without relying on Power BI  

---

## 🔹 Power BI Dashboard  

A multi-page Power BI report was developed, enabling users to analyze:  
📊 **Sales performance** across different regions  
📈 **Trends in revenue & customer behavior**  
🏷️ **Product-wise sales insights**  
📍 **Store locations and sales distribution**  

### **Star Schema Data Model**  

To efficiently structure the dataset, a **star schema** was implemented in Power BI, ensuring optimal performance and easy navigation.  

![Star Schema Model](/images-readme/data_model.png)  

---

## ⚙️ SQL Queries for Business Insights  

SQL queries were created to fetch real-time insights from the **centralized Azure database**. Below is an example query that retrieves total revenue and order counts by store type:  

```sql
-- Sales & Orders Summary by Store Type
CREATE VIEW "Store Sales Overview" AS
SELECT 
    "Store Type",
    "Revenue",
    "Revenue" / SUM("Revenue") OVER () AS "Percentage of Total Revenue",
    "Total Orders"
FROM (
    SELECT 
        ds.store_type AS "Store Type",
        SUM(o.product_quantity * dp.sale_price) AS "Revenue", 
        COUNT(*) AS "Total Orders"
    FROM orders o
    JOIN dim_product dp ON dp.product_code = o.product_code
    JOIN dim_store ds ON ds.store_code = o.store_code
    JOIN dim_date dd ON dd.date = o.order_date
    GROUP BY "Store Type"
) AS store_data;
