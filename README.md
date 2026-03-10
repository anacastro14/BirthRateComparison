# Teenage Pregnancy and Development: A Regional Analysis

## Project Overview

This project investigates the relationship between teenage pregnancy rates and the Human Development Index (HDI) across Latin America, Western Europe, and Eastern Europe. Teenage pregnancy is a significant global health issue, and rates often correlate with a country's access to education, healthcare, and overall standard of living.

This repository contains the analysis and R code used to compare these regions and quantify the impact of development levels on teenage birth rates, using data from 2022.

## Table of Contents

*   [Dataset](#dataset)
*   [Methods](#methods)
*   [Results](#results)
*   [Conclusion](#conclusion)
*   [Installation](#installation)
*   [Usage](#usage)
*   [Contributing](#contributing)
*   [License](#license)
*   [References](#references)

## Dataset

The data was compiled from official statistical organizations for various countries within three distinct regions. For each country, the primary metric was calculated: the percentage of live births to teenage mothers (under 20 years old) out of the total live births in 2022.

The countries were grouped as follows:
*   **Latin America (LATAM)**: Mexico, Brazil, Colombia, Peru, Chile, Uruguay, Dominican Republic, Panama, and Ecuador.
*   **Eastern Europe (E. Europe)**: Bulgaria, Czech Republic, Kazakhstan, Turkey, Slovakia, and Serbia.
*   **Western Europe (W. Europe)**: UK, Spain, Germany, Netherlands, Switzerland, Belgium, Italy, Portugal, Norway, and Sweden.

## Methods

The analysis was conducted in R with the following methodology:

1.  **Data Aggregation**: Sourced 2022 birth data to calculate the percentage of teenage births per country.
2.  **Regional Comparison**: A violin plot was generated to visualize the distribution and inequality of teenage birth rates between the three regions.
3.  **Inequality Analysis**: The **Slope Index of Inequality (SII)** was calculated to measure the relationship between socioeconomic deprivation (using HDI as a proxy) and teenage birth rates.
4.  **Data Transformation**: To facilitate a linear analysis and improve interpretation, two key transformations were applied:
    *   The **Human Development Index (HDI)** was transformed into a deprivation score using the formula `0.01 + 1 / HDI`. A higher value on this new scale indicates a lower level of development.
    *   The **percentage of teenage births** was log-transformed to normalize its distribution and stabilize variance for the SII calculation.

## Results

The analysis revealed significant disparities between the regions.

*   **Regional Inequality**: The violin plot clearly shows that Western Europe has the lowest and most consistent teenage birth rates. Latin America has the highest rates, with significant variation between countries. Eastern Europe falls in the middle.

    
    <img width="814" height="616" alt="image" src="https://github.com/user-attachments/assets/50475fde-b515-4057-9c5c-7b4f70303fba" />
    
*   **Slope Index of Inequality (SII)**: The analysis yielded an SII of **4.08**. Given the log-transformed data, this indicates an exponential increase in teenage birth rates as a country's development level decreases. The findings show that the countries with the lowest development experience teenage birth percentages approximately **59.16 times higher** than the most developed countries.

    <img width="814" height="616" alt="image" src="https://github.com/user-attachments/assets/e14f0c51-2f44-4cab-be02-387122e14e5d" />

## Conclusion

The results strongly highlight that lower levels of human development, as measured by the HDI, are correlated with significantly higher rates of teenage pregnancy. The vast disparities between regions, particularly between Western Europe and Latin America, underscore the profound impact of socioeconomic factors and access to health and education services.

These findings call for urgent, evidence-based actions to reduce teenage pregnancy rates, especially in less developed nations.

## Installation

To run this project, you need to have R and RStudio installed. The analysis relies on packages for data manipulation and visualization. You can install the necessary R packages by running the following command in your R console:

```R
install.packages(c("tidyverse", "ggplot2"))
```

## Usage
To get a local copy up and running, follow these simple steps.

1. Clone the repository (replace your-username with your actual GitHub username):

```bash
git clone https://github.com/anacastro14/teenage-pregnancy-analysis.git
```
2. Navigate to the project directory:
```Bash
cd teenage-pregnancy-analysis
```
3. Place your plot images (e.g., plot1.png, plot2.png) inside a folder named images.
4. Open the R script (analysis.R) in RStudio.
5. Run the script to reproduce the analysis and results.

## Contributing
Contributions make the open-source community an amazing place to learn and create. Any contributions you make are greatly appreciated.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

## License
Distributed under the MIT License. See LICENSE file for more information.

## References
WHO. (2024, April 10). Adolescent pregnancy. World Health Organization. Retrieved from https://www.who.int/news-room/fact-sheets/detail/adolescent-pregnancy

WHO. (n.d.). Human development index. World Health Organization. Retrieved from https://www.who.int/data/nutrition/nlis/info/human-development-index



