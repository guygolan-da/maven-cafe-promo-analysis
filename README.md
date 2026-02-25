# ☕ Maven Café — Analyzing 30-Day Promotional Offers

![SQL](https://img.shields.io/badge/SQL-Server-blue?logo=microsoftsqlserver)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?logo=powerbi)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

## 📌 Project Overview

Maven Café sent promotional offers to its registered customers to boost sales over a 30-day period.  
This project analyzes customer responses to those offers and provides a **data-driven strategy** for future promotional messaging and targeting.

---

## 🎯 Business Questions

| # | Question |
|---|----------|
| Q1 | Which customer segment demonstrated the strongest response, and what offer structure should be used for future targeting? |
| Q2 | Which campaign generated the highest total revenue to justify its recurrence? |
| Q3 | Which offer mechanics and delivery timings achieved the highest conversion rates from "Offer Received" to "Offer Completed"? |

---

## 🗂️ Dataset

**Source:** [Kaggle — Café Rewards Offer Dataset](https://www.kaggle.com/datasets/arshmankhalid/caf-rewards-offer-dataset)

| Table | Count | Notes |
|-------|-------|-------|
| Offers | 10 | 3 types: Informational, BOGO, Discount |
| Customers | 17,000 → **14,825** | Filtered out 2,175 records with missing age/gender/income |
| Events | 306,534 | All customer interactions over 30 days |

---

## 🛠️ Tools & Methodology

```
Kaggle (CSV) ──► SQL Server (Cleaning + Views) ──► Power BI (Visualization)
```

- **Data Cleaning:** Used `JSON_VALUE` to parse nested JSON fields; filtered invalid records (age=118)
- **Feature Engineering:** Created CTEs with age, income, and membership tenure bins
- **Abstraction Layer:** SQL Views as Single Source of Truth for all business logic
- **Visualization:** Interactive dashboards built in Power BI

---

## 📁 Repository Structure

```
maven-cafe-promo-analysis/
│
├── data/
│   ├── offers.csv
│   ├── customers.csv
│   └── events.csv
│
├── sql/
│   ├── cleaning.sql      # JSON parsing, type conversion, exploratory checks
│   ├── views.sql         # Abstraction layer: customers_clean, completed_offers, offer_results
│   └── analysis.sql      # Business questions Q1 / Q2 / Q3
│
├── powerbi/
│   └── maven_cafe_analysis.pbix
│
├── presentation/
│   └── maven_cafe_presentation.pdf
│
└── README.md
```

---

## 📸 Visualizations

**Top 200 Customers — Demographics Distribution (Q1)**
![Top 200 Customers Distributions](images/Top_200_Customers_Distributions.PNG)

**Completed Offers — Revenue by Offer Type (Q2)**
![Completed Offers - Offer Types & Revenue](images/Completed_Offers___Offer_Types___Revenue.PNG)

**Conversion Rate by Distribution Day (Q3)**
![Conversion Rate by Distribution](images/Conversion_Rate_by_Distribution.PNG)

---

## 📊 Key Findings

### 👤 Target Audience (Q1)
- **Core segment:** Female customers (52%), aged **50–69**, earning **$50K–$89K**
- Customer value peaks in **Years 2 and 3** of membership
- Customers in Year 1 and income below $49K are under-represented in top performers

### 💰 Revenue Analysis (Q2)
- **Discount offers** dominated with **$197K** (63% of total revenue)
- **BOGO offers** contributed **$113K** (37%)
- Informational offers generated **$0** — recommend re-evaluation
- Highest difficulty tiers (10 & 20) drove **74%** of total revenue
- Total transaction volume: **$1,775,451**

### 📈 Conversion Funnel (Q3)
- 76,277 offers sent → 75% viewed → 44% completed overall
- **Best timing: Day 25** → **61% conversion rate**
- **Worst timing: Day 15** → only **30% conversion rate**
- 10-day duration discount offers exclusively drove the Day 25 peak

---

## ✅ Strategic Recommendations

| Focus Area | Recommendation |
|------------|----------------|
| **Audience** | Maintain current strategy for ages 50–69; prioritize $60K–$89K income bracket |
| **Offers** | Prioritize discount offers; re-evaluate informational offers (zero revenue) |
| **Structure** | Difficulty ratings 10 & 20; 10-day duration; $5 reward tier |
| **Retention** | Increase loyalty initiatives toward end of Year 1 |
| **Timing** | Replicate Day 25 send model to achieve peak 61% conversion |

---

## 🚀 How to Run

1. Load the CSV files into SQL Server (tables: `offers`, `customers`, `events`)
2. Run `sql/cleaning.sql` — parses JSON fields and validates data
3. Run `sql/views.sql` — creates the abstraction layer views
4. Run `sql/analysis.sql` — executes all business queries
5. Open `powerbi/maven_cafe_analysis.pbix` → update data source → refresh

---

## 👤 Author

Made by [Guy Golan](https://www.linkedin.com/in/guy-golan-a077b8157/) | [GitHub](https://github.com/guygolan-da)
