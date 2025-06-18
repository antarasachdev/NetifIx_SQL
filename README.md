# NetifIx_SQL


## 📺 Netflix Titles Dataset Analytics 

![Netflix Banner](https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg)

### 📌 Overview

This project uses SQL (MySQL) to analyze the [Netflix Titles Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download) . This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.
---

### 🧾 Dataset Details

- **Dataset**: `netflix_titles.csv`
- **Source**: Kaggle
- **Key Columns**: `title`, `cast`, `country`, `date_added`, `release_year`, `listed_in`
- **Primary Focus**: 
  -Analyze the distribution of content types (movies vs TV shows).
  -Identify the most common ratings for movies and TV shows.
  -List and analyze content based on release years, countries, and durations.
  -Explore and categorize content based on specific criteria and keywords.

---

### 🔍 Problem: Multi-Actor `cast` Field

The `cast` column contains actor names separated by commas, e.g.

```
"Amitabh Bachchan, Shah Rukh Khan, Deepika Padukone"
```

Since MySQL doesn't support `UNNEST` like PostgreSQL, we simulate the split using `SUBSTRING_INDEX`.

---

### ✅ Solution Query

We extract the **first 3 actors** from each row using `UNION ALL`:

```sql
SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(`cast`, ',', 1), ',', -1)) AS actor
FROM netflix_titles
WHERE country LIKE '%India%' AND `cast` IS NOT NULL

UNION ALL

SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(`cast`, ',', 2), ',', -1)) AS actor
FROM netflix_titles
WHERE country LIKE '%India%' AND `cast` IS NOT NULL

UNION ALL

SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(`cast`, ',', 3), ',', -1)) AS actor
FROM netflix_titles
WHERE country LIKE '%India%' AND `cast` IS NOT NULL;
```

---

### 📊 Example Output

| actor             |
|------------------|
| Shah Rukh Khan   |
| Deepika Padukone |
| Nawazuddin Siddiqui |

---

### 📈 Possible Extensions

- Show **most frequent actors** using `GROUP BY actor ORDER BY COUNT(*) DESC`
- Expand beyond 3 actors by adding more `UNION ALL` blocks
- Add year-wise analysis or genre-specific actor appearance

---

### 🧰 Tech Stack

| Tool        | Purpose                    |
|-------------|----------------------------|
| MySQL       | SQL Querying               |
| Kaggle      | Data Source                |
| VS Code     | Readme .md                 |
| GitHub      | Project Hosting & Sharing  |

---


### 📝 License

This project is for educational purposes only. Data sourced from Kaggle.
