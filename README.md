# 🍽️ Restaurant Crisis Data Analysis (SQL + Power BI Dashboard)

### 📊 Live Dashboard  
🔗 **View Dashboard Here:** [Power BI Live Dashboard](https://drive.google.com/file/d/1La9pBWl9W0CKJ5ZA-Lrrit_VbKUGXRQ_/view?usp=sharing)  

---

### 🖼️ Dashboard Preview  
![Restaurant Dashboard](dashboard_screenshot.png)

---

## 🧠 Project Overview

This is an **unguided end-to-end project** — everything from **data cleaning**, **SQL analysis**, and **data modeling** to **dashboard creation** was done by me independently.

The goal of this project was to analyze restaurant sales and operations data to extract insights on **revenue, customer growth, and delivery performance**.  
It combines **SQL (for analysis)** and **Power BI (for visualization)** to create a comprehensive analytical solution.

---

## 🧩 SQL Analysis

I performed SQL-based analysis on datasets including:
- `fact_orders`
- `dim_customers`
- `dim_restaurants`
- `dim_delivery_partner`
- `dim_menu_items`

### 🔍 Key SQL Insights
1. **Total Orders by City**  
2. **Top 10 Customers by Spend**  
3. **Cancelled Orders by Cuisine Type**  
4. **Churned Users (before & after June 2025)**  
5. **Monthly Customer Growth**  
6. **Average Delivery Time by Partner**

Each SQL query helped build a foundation for Power BI metrics and KPIs.

---

## ⚙️ Power BI Dashboard

After importing the cleaned data into Power BI, I created data relationships and calculated measures for analysis.

### 🧮 Key Measures (DAX)

```DAX
Total Sales = SUM(fact_orders[total_amount])

Total Customers = DISTINCTCOUNT(dim_customers[customer_id])

Avg Delivery Time = AVERAGE(fact_orders[delivery_time])

Cancelled Orders = CALCULATE(
    COUNT(fact_orders[order_id]),
    fact_orders[order_status] = "Cancelled"
)

Net Sales = [Total Sales] - SUM(fact_orders[discount_amount])
```

## 📈 Key Metrics & Visuals

| KPI | Description | Visualization |
|------|--------------|----------------|
| 💰 **Total Sales** | Overall sales amount | Card |
| 👥 **Total Customers** | Unique customers | Card |
| 🏙️ **Sales by City** | Sales distribution across cities | Bar Chart |
| 📅 **Sales Over Time** | Monthly sales growth | Line Chart |
| 🍽️ **Category Breakdown** | Sales by cuisine type | Pie Chart |
| ⏱️ **Delivery Performance** | Avg delivery time by city | Clustered Column Chart |
| 📈 **Customer Growth** | Monthly increase in new customers | Line Chart |
| 🔄 **Cancelled Orders** | Cancellation trends by restaurant type | Column Chart |

---

## 📦 Tools & Technologies

- **SQL (PostgreSQL)** – Data extraction and analysis  
- **Power BI** – Dashboard creation and KPI visualization  
- **Excel / CSV** – Data source files  
- **GitHub** – Version control and project showcase  

---

## 📚 Learnings

- Designed an **end-to-end data pipeline** using SQL and Power BI.  
- Practiced **data modeling** and **relationship building** in Power BI.  
- Learned to convert **raw data into business insights** using DAX and visual storytelling.  
- Strengthened my ability to handle an **unguided real-world data analytics project** from scratch.  

---

## 🧑‍💻 Author

**Anuj Negi**  
📍 Dehradun, Uttarakhand  
📧 [anuj.negi.54@gmail.com](mailto:anuj.negi.54@gmail.com)  

🌐 [Portfolio](https://anujnegi-portfolio.netlify.app/) | [LinkedIn](https://linkedin.com/in/anuj-negi-8a032830b) | [GitHub](https://github.com/Anuj-data)


