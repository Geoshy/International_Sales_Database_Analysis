# 1. Introduction:
In this project, we would use SQL using the Microsft SQL Server DBMS to export specific dataset from the main database (International Sales Database) using SQL queries, then we would use Python using Jupyter Notebook to analyze the exported dataset through cleaning it, then describe statistical characteristics (Mean - Median - IQR - Min - Max), dealing with outliers using (Pandas Library), and finally visualize the data using different python libraries such as (Matplotlib - Seaborn - Plotly), to show different trends and patterns from between the data.

You can see all SQL queries for the project here: [SQL_Queries folder](/SQL_Queries/), and Python Jupyter Notebooks here:[Python_Analysis](Python_Analysis).

# 2. Tools I Used:
To thoroughly explore the data analyst job market, I utilized the capabilities of a range of essential tools:
1. **SQL:** allowing me to query the database and explore critical insights.
2. **Microsoft SQL Server:** database management system.
3. **Python:** as it a powerhouse in data analysis, thanks to its simplicity, flexibility, and the vast array of libraries it offers.
4. **Visual Studio Code:** for database management and executing SQL queries, and for Python coding for analysis.
5. **Jupyter Notebook:** It is an interactive web-based environment that allows users to create and share documents containing live code, visualizations, and narrative text, using Python language.
6. **Git & GitHub:** for sharing my SQL scripts and analysis.

# 3. SQL Queries Analysis (Microsoft SQL Server & VS Code):

### **3.1. Create Datebase:**
- Create a Database (InternationalCompanySalesData) to Upload Data from the Excel Sheet on it,
by Using (SQL Server Import and Export Wizard) to Import Data Into Database.
- Make Sure That All Columns in All Tables Have The Suitable Data Type.
- Before Finish Import Data Into Database.

```sql
USE MASTER;
GO

CREATE DATABASE InternationalCompanySalesData;
```
### **3.2. Extract Full Join Data Set:**
- Extract Full Join Data from tables (Customer - Order - Product - Supplier) into one table to analyze it using Python.
```sql
USE InternationalCompanySalesData;
GO

SELECT 
    C.*, O.*, P.*, S.*
FROM
    Customer AS C
    FULL JOIN [Order] AS O ON C.Id = O.CustomerId
    FULL JOIN OrderItem AS OI ON O.Id = OI.OrderId
    FULL JOIN Product AS P ON OI.ProductId = P.Id
    FULL JOIN Supplier AS S ON P.SupplierId = S.Id;
```
# 4. Python Analysis (VS Code & Jupyter Notebook):
- First, we would export the result from the last SQL query into a CSV file, then read it in VS Code using the Python pandas library to import it as a dataframe to start analysis on it.
- Second, we would inspect the dataframe to find all dataframe problems to clean and fix it.
- Third, we would start the Data Exploratory step, through Univariate, Bivariate, and Multivariate analysis, using suitable plots and charts to discover different patterns and trends between data.
- We can summarize the steps of the analysis using Python into this chart:

![alt text](Figs/F1.png)

### **4.1. Data Cleaning Step:**  
- In this step, we should check our dataframe column's data type, check the columns' name, and nan- values, and check the numerical and categorical columns to fix any problems before analysis.   
- After we checked the dataframe, we found these issues.

**Issues**:

**1- Delete Rows With Nan OrderId Values:**
```python
df_copy = df_copy[df_copy["OrderId"].notna()]
```
**2. Change the Data Type of the OrderDate Column from Object (String) to Datetime Data Type:**
```python
df_copy["OrderDate"] = pd.to_datetime(df_copy["OrderDate"])
```
**3. Change the Data Type of Columns (CustomerId - OrderId - OrderNumber - ProductId - SuplierId) from Float to Integer Data Type:**
```python
change_columns = ["CustomerId", "OrderId", "OrderNumber", "ProductId", "SupplierId"]
for column in list(df_copy.columns):
    if column in change_columns:
        df_copy[column] = df_copy[column].astype(int)
```
**4. Rename Columns (City.1 - Country.1 - Phone.1) as They Similar to Previous Columns:**
```python
df_copy.rename(columns={
    "City.1":"SupplierCity",
    "Country.1":"SupplierCountry",
    "Phone.1":"SupplierPhone"
}, inplace=True)
```

- Then, we would create a function collecting all data cleaning steps in one function to save time in the next analysis steps 

**5- Create Function Wrang (Data Wrangling) With Optional Variables (None):**
```python
def wrang(
    dataframe,
    encoding = None,
    dropnanvalues = None,
    duplicatevlues = None,
    datecolumn = None,
    renamedcolumns = None  
):
    # Loading Data From CSV File:
    df = pd.read_csv(dataframe, encoding= encoding)

    # Drop Nan Value Of Specific Columns:
    df.dropna(subset=dropnanvalues, inplace=True)

    # Remove Duplicates From Specific Columns:
    df.drop_duplicates(subset=duplicatevlues, inplace=True)

    # Convert Date Column From Object to Datetime:
    df[datecolumn] = pd.to_datetime(df[datecolumn])

    # Rename Columns Names:
    df.rename(columns= renamedcolumns, inplace=True)

    # Stripe and Lowercase Columns Names:
    df.columns = df.columns.str.strip().str.lower()
    return(df)    
```
**6- Create New Dataframe (Orders) By Using Wrang User-Defined Function to use this Dataframe as Main Dataframe In all Next Steps:**
```python
orders = wrang(dataframe="Full_Join_Data.csv",
               encoding="latin-1",
               dropnanvalues=["OrderId"],
               duplicatevlues="OrderId",
               datecolumn="OrderDate",
               renamedcolumns={"City.1":"SupplierCity", "Country.1":"SupplierCountry", "Phone.1":"SupplierPhone"})
```
**7- Then We Would Convert columns ["customerid", "orderid", "ordernumber", "productid", "supplierid"], to Integer Data Type:**
```python
columns_edit = ["customerid", "orderid", "ordernumber", "productid", "supplierid"]
for column in list(orders.columns):
    if column in columns_edit:
        orders[column] = orders[column].astype(int)
```
### **4.2. Data Exploration Step (Exploratory Data Analysis "EDA"):** 
 - Data exploration is a main step in data analysis involving the use of data visualization tools and statistical techniques to uncover data set characteristics and initial patterns.

### **1- Univariate Analysis:**

**Analysis Quantitative Column In The Data (totalamount):**

**(1) Descriptive Statistics Summary:**

- We use describe method to find Descriptive statistics about Dataframe:
```python
orders["totalamount"].describe()
```
```
| Statistic | Value       |
|-----------|-------------|
| count     | 830.000000  |
| mean      | 1631.877819 |
| std       | 1990.613963 |
| min       | 12.500000   |
| 25%       | 480.000000  |
| 50%       | 1015.900000 |
| 75%       | 2028.650000 |
| max       | 17250.000000|
```
**(2) Data Shape Using (Histogram):**

**Using Plot( ) Function of Pandas Library:**

![alt text](Figs/F2.png)

**Histogram Shape Analysis:**

- First, the shape of the curve is (Right-Skewed) or (Positive-Skewed).

- In this case, the mean is more than the median (mean > median).

- We note that most of our data in the histogram is concentrated in the left side.

- We note that the median (black line) is closer to most data on the left side.

- Unlike mean which is closer to higher values data which is right skewed of the curve.

- So, the median in this case is more accurate and can be used in measure of the center.

**(3) Five Number Summary: (Min - Q1 - Median(Q2) - Q3 - Max) Using (Box Plot):**

**Five Number Summary:**
- We used five number summary to find the outliers in our data, a five-number summary simply consists of the smallest data value (Min), the first quartile (Q1), the median (Q2), the third quartile (Q3), and the largest data value (Max). 
    -	Min
    -	Q1
    -	Median
    -	Q3
    -	Max
```python
Min = orders["totalamount"].min()
Q1 = orders["totalamount"].quantile(0.25)
Q2 = orders["totalamount"].median()
Q3 = orders["totalamount"].quantile(0.75)
Max = orders["totalamount"].max()
```

**IQR:**

- Interquartile range tells you the spread of the middle half of your distribution.

    - Q1 = 25% of the dataset.
    - Q2 = Median = 50% of the dataset.
    - Q3 = 75% of the dataset.
    - IQR = Q3 – Q1
    - Lower Boundary = Q1 – (1.5 * IQR)
    - Upper Boundary = Q3 + (1.5 * IQR)
- Outliers are the values that is less than or equal lower boundary and more than or equal upper boundary.
```python
IQR = Q3 - Q1
lower_boundary = Q1 - (1.5 * IQR)
upper_boundary = Q3 + (1.5 * IQR)
```
**Box Plot:**

**Using Plotly Library:**

![alt text](Figs/F3.PNG)

**Using Seaborn Library:**

![alt text](Figs/F4.png)


**Combination Of Histogram Chart and Box Plot Chart Showing Invoices Amount Distribution**

```python
fig, ax = plt.subplots(2,1)
fig.tight_layout(h_pad=2)

def salaryFormat(x, position):
    return(f"${int(x / 1000)}K")

ax[0].hist(x=orders["totalamount"], bins=30, edgecolor="black")
ax[0].set_title("Distribution of Total Amount of Invoices")
ax[0].xaxis.set_major_formatter(plt.FuncFormatter(salaryFormat))
ax[0].axvline(x=(orders["totalamount"]).median(), color="red", linestyle="--", label="Median")
ax[0].axvline(x=(orders["totalamount"]).mean(), color="black", linestyle="--", label="Mean")
ax[0].axvline(x=(orders["totalamount"]).quantile(0.25), color="yellow", linestyle="--", label="Q1")
ax[0].axvline(x=(orders["totalamount"]).quantile(0.75), color="yellow", linestyle="--", label="Q3")
ax[0].legend(loc="upper right")

ax[1].boxplot(x=orders["totalamount"], vert=False)
ax[1].set_yticks([])
ax[1].xaxis.set_major_formatter(plt.FuncFormatter(salaryFormat))
ax[1].set_xlabel("Total Amount In (USD$)")
ax[1].axvline(x=(orders["totalamount"]).median(), color="red", linestyle="--")
ax[1].axvline(x=(orders["totalamount"]).mean(), color="black", linestyle="--")
ax[1].axvline(x=(orders["totalamount"]).quantile(0.25), color="yellow", linestyle="--")
ax[1].axvline(x=(orders["totalamount"]).quantile(0.75), color="yellow", linestyle="--")
```
![alt text](Figs/F5.png)

**Box Plot Analysis:**

- From the box plot and five-number summary analysis, we note that the upper boundary is almost equal = 4351.625.

- The number of rows (invoices) that are bigger or equal to the upper boundary is 56 rows (invoices).

- In fact, I see that 56 rows to be considered outliers is not correct compared to the total number of rows of the dataframe (830).

- The second reason is due to the values from 4K to 15K are close together, which means that the difference between them is small.

- In this case, I will consider that values more than 15K are considered outliers, as their values are differentiated more.

**Dealing With Ouliers:**
- Total Number of Rows >= Upper Boundary = 3 Rows
- Total Number of Rows <= Lower Boundary = 0 Rows
```python
orders = orders[orders["totalamount"] < 15000]
```
**Analysis Qualitative (Categorical ) Data Exploratory:**

**Bar Chart Analysis:**

**City Column Analysis Using Bar Chart:**

***1-Using Plot( ) Function of Pandas Library:***

![alt text](Figs/F6.png)

***2-Using Matplotlib Library:***

![alt text](Figs/F7.png)

**City Bar Chart Analysis:**
1. **Cities with High Counts:**
   - The two cities dominating this chart are London and Rio de Janeiro because they have an extremely high count, far ahead of other cities.
   - The next tier of cities with considerable high counts includes São Paulo, Boise, and Cunevaldez.

2. **Sharp Descent After the Top Cities:**
   - After top five, the count comes down sharply. Other cities also tend to show a gradual downward trend.

3. **Potential Categories for Investigation or Impact:**
   - The data would almost suggest that businesses or initiatives with such a dataset will probably find the top 10 cities beneficial for impact. On the other hand, the tail-end of the cities may prove interesting for countries with niche opportunities.

**Country Column Analysis Using Bar Chart:**

***1.Using Seaborn Library:***

![alt text](Figs/F9.png)

***2.Using Plotly Library:***

![alt text](Figs/F8.png)

**Countries Bar Chart Analysis:**
- With top two absolute counts which are more than any other country, **Germany** and **USA** turned out to be the topmost countries in the bar chart.
- The top three were followed by **Brazil**, **France**, and the **UK**.
- After the top five countries in the chart, the counts see a steady declining trend that has gone much closer to even representation in mid-tier countries, such as **Venezuela**, **Austria**, and **Sweden**. 
- Countries like **Argentina**, **Portugal**, **Poland**, and **Norway**, together add very little to the total counts, but add variety to the dataset.
- This data has countries across continents, besides covering Europe and America; it appears to be a worldwide dataset.
- Germany and the USA are critical areas, again by counts, but also by the indications of the chart showing possibilities to look beyond the high counts into mid-tier countries.

**Country Column Analysis Using Pie Chart Using Matplotlib Library:**
```python
plt.figure(figsize=(15, 8))
country_chart.plot(
    kind="pie",
    startangle=90,
    autopct="%1.1f%%",
    legend=True,            
)
plt.title("Country-wise Order Distribution", fontsize=16)
plt.tight_layout()
plt.ylabel(" ")

```
![alt text](Figs/F10.png)

**Pie Chart Analysis:**
- Through the preliminary analysis, we see that London is the city that has the largest share of purchasing our products with 46 invoices, but Germany and United States are the the most purchasing countries for dataset products with 121 invoices and 14.7% of our total sales.
