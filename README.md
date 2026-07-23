# 🧾 Financial Transaction Customer Analytics

*Help a financial institution understand customer behaviour, identify valuable customers, predict churn, and improve customer engagement using SQL.*



## 📌 Table of Contents

* <a href="#overview">Overview</a>
* <a href="#business-problem">Business Problem</a>
* <a href="#dataset">Dataset</a>
* <a href="#tools- &amp;-technologies">Tools \& Technologies</a>
* <a href="#project-structure">Project Structure</a>
* <a href="#data-cleaning--preparation">Data Cleaning \& Preparation</a>
* <a href="#research- &amp;-key-findings">Research Questions \& Key Findings</a>
* <a href="#final-recommendations">Final Recommendations</a>
* <a href="#author- &amp;-contact">Author \& Contact</a>


<h2><a class="anchor" id="overview"></a>Overview</h2>

Financial institutions generate millions of customer transactions every day. Analyzing this data helps understand customer behavior, improve customer retention, identify high-value customers, and support data-driven business decisions. This project performs an end-to-end customer analytics workflow using MySQL and Excel, covering customer demographics, spending patterns, customer segmentation, customer lifetime value (CLV), churn analysis, customer acquisition, and executive business KPIs.


<h2><a class="anchor" id="business-problem"></a>Business Problem</h2>

This project aims to:

* Analyze customer demographics and financial profiles.
* Identify high-value customers through spending and CLV analysis.
* Understand customer spending behavior across merchants and locations.
* Segment customers for targeted marketing and personalized services.
* Detect customers at risk of churn using transaction history.
* Measure customer acquisition trends and business growth.
* Create business KPIs to support executive decision-making.


<h2><a class="anchor" id="dataset"></a>Dataset</h2>

comprehensive financial dataset combines transaction records, customer information, and card data from a banking institution, spanning across the 2010s decade.

1. <strong>User Data</strong>

&#x20;  Contains customer demographic and financial information.

&#x20;  Columns

* id
* current\_age
* retirement\_age
* birth\_year
* birth\_month
* gender
* address
* per\_capita\_income
* yearly\_income
* total\_debt
* credit\_score
* num\_credit\_cards



2\. <strong>Card Information</strong>

&#x20;  Contains customer card and account information.

&#x20;  Columns

* id
* client\_id
* card\_brand
* card\_type
* card\_number
* expires
* cvv
* has\_chip
* num\_cards\_issued
* credit\_limit	
* acct\_open\_date
* year\_pin\_last\_changed
* card\_on\_dark\_web



3\. <strong>Transaction Data</strong>

&#x20;  Contains transaction-level information.

&#x20;  Columns

* id
* date	
* client\_id
* card\_id
* amount
* use\_chip
* merchant\_id	
* merchant\_city
* merchant\_state
* zip
* mcc
* errors




<h2><a class="anchor" id="tools- &amp;-technologies"></a>Tools &amp; Technologies</h2>

* SQL (Common Table Expressions, Joins, Filtering, Window Functions, Aggregate Functions, Stored Procedures, Views)
* Excel
* GitHub


<h2><a class="anchor" id="project-structure"></a>Project Structure</h2>

```
financial-transaction-analysis/

│

├── Dataset/

│   ├── users\_data.csv

│   ├── cards\_data.csv

│   └── transactions\_data.csv

│

├── SQL Scripts/

│   ├── 01\_Load\_Dataset.sql

│   ├── 02\_Exploratory\_Data\_Analysis.sql

│   ├── 03\_Customer\_Demographics.sql

│   ├── 04\_Spending\_Analysis.sql

│   ├── 05\_Customer\_Segmentation.sql

│   ├── 06\_Customer\_Lifetime\_Value.sql

│   ├── 07\_Customer\_Behaviour.sql

│   ├── 08\_Customer\_Preferences\_Recommendations.sql

│   ├── 09\_Churn\_Analysis.sql

│   ├── 10\_Customer\_Acquisition.sql

│   ├── 11\_Business\_KPIs.sql

│   ├── 12\_Views.sql

│   └── 13\_Stored\_Procedures.sql

│

└── README.md



```


<h2><a class="anchor" id="data-cleaning--preparation"></a>Data Cleaning &amp; Preparation</h2>

* Verified and standardized data types for dates, numeric values, and text fields to support accurate calculations and analysis.
* Handled missing and blank values using NULLIF().
* Checked for duplicate records and validated data consistency across the three tables.



<h2><a class="anchor" id="research-&amp;-key-findings"></a>Research Questions &amp; Key Findings</h2>

<p>The analysis uncovered valuable insights into customer behavior, spending patterns, and overall business performance.</p>

<strong>Customer Demographics</strong> 
* Analyzed customer demographics including age, gender, annual income, debt, and credit score.
* The average annual income was 45,011.92, with an average credit score of 714.03.

<strong>Spending Analysis</strong> 
* Analyzed spending trends across customers using transaction history.
* The dataset contains 1,131 customers with a total spending of 17,799,606.40.
* The average transaction value was 46.77.

<strong>Customer Segmentation</strong>
Customers were segmented based on income, spending, debt, and credit score.
<table>
  <thead>
    <tr>
      <th>Customer Segment</th>
      <th>Description</th>
      <th>Percentage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>VIP</td>
      <td>High Income + High Spending</td>
      <td>2.30%</td>
    </tr>
    <tr>
      <td>Premium</td>
      <td>Good Credit Score + High Spending</td>
      <td>15.74%</td>
    </tr>
    <tr>
      <td>Regular</td>
      <td>Average Spending Customers</td>
      <td>74.83%</td>
    </tr>
    <tr>
      <td>Budget</td>
      <td>Low Spending Customers</td>
      <td>3.36%</td>
    </tr>
    <tr>
      <td>Risk</td>
      <td>High Debt + Low Credit Score</td>
      <td>4.07%</td>
    </tr>
  </tbody>
</table>

<p>The majority of customers (74.83%) belong to the Regular segment, while VIP customers account for only 2.30%, indicating a relatively small group of high-value customers.</p>

<strong>Customer Lifetime Value (CLV)</strong> 
* Calculated Total Spending, Average Spending, Transaction Frequency, Relationship Duration, and Estimated CLV.
* Ranked customers using RANK(), DENSE_RANK(), and NTILE() to identify high-value customers.


<strong>Customer Behaviour</strong>
* Analyzed spending patterns across merchants, merchant categories, cities, transaction methods, and card types.
* Evaluated customer activity using monthly and daily spending trends.


<strong>Churn Analysis</strong>
* Classified customers as Active, At Risk, or Churned using transaction inactivity rules.
* Based on the current business rules, 1,128 customers were classified as active.

<strong>Customer Acquisition</strong>
* Evaluated monthly and yearly customer acquisition trends using account opening dates.

<p> <strong>Business KPIs</strong> <br>
<table>
  <tr>
    <th>KPI</th>
    <th>Value</th>
  </tr>
  <tr>
    <td>Total Customers</td>
    <td>1,131</td>
  </tr>
  <tr>
    <td>Active Customers</td>
    <td>1,128</td>
  </tr>
  <tr>
    <td>Total Spending</td>
    <td>17,799,606.40</td>
  </tr>
  <tr>
    <td>Average Transaction</td>
    <td>46.77</td>
  </tr>
  <tr>
    <td>Average CLV</td>
    <td>1,372,251.22</td>
  </tr>
  <tr>
    <td>Average Credit Score</td>
    <td>714.03</td>
  </tr>
  <tr>
    <td>Average Annual Income</td>
    <td>45,011.92</td>
  </tr>
  <tr>
    <td>Average Total Debt</td>
    <td>56,636.18</td>
  </tr>
</table> </p>

<p> <strong>Key Insights</strong> <br>
<ul>
  <li>The customer base is dominated by the Regular segment (74.83%), with a relatively small VIP segment (2.30%).</li>
  <li>Customers have an average annual income of 45,011.92 and an average credit score of 714.03.</li>
  <li>The dataset contains 17.8 million in total customer spending across 1,131 customers.</li>
  <li>Business KPIs provide a comprehensive overview of customer activity and spending behavior.</li>
</ul>
</p>


<h2><a class="anchor" id="final-recommendations"></a>Final Recommendations</h2>

* <strong>Prioritize high-value customers</strong> by offering personalized rewards, exclusive benefits, and loyalty programs to improve customer retention and maximize Customer Lifetime Value (CLV).
* <strong>Develop targeted strategies for each customer segment.</strong> Design premium services for VIP and Premium customers, while creating engagement campaigns for Budget and Risk segments.
* <strong>Implement proactive churn management</strong> by regularly monitoring inactive customers and launching timely retention campaigns before they become churned.
* <strong>Leverage spending behavior insights</strong> to recommend relevant merchant categories, products, and offers based on customer preferences and transaction history.
* <strong>Optimize customer acquisition strategies</strong> by analyzing acquisition trends and focusing marketing efforts on the most effective time periods and customer segments.
* <strong>Monitor key business KPIs</strong> such as Total Spending, Average Transaction Value, Customer Lifetime Value, and Churn Rate through interactive dashboards to support data-driven decision-making.
* <strong>Continuously update customer segmentation and CLV models</strong> as new transaction data becomes available to ensure business strategies remain relevant and effective.


<h2><a class="anchor" id="author- &amp;-contact"></a>Author &amp; Contact</h2>

**Vani Sharma**   
Data Analyst  
📧 Email: vanisharma2014@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/vani-sharma-82a790221/)


