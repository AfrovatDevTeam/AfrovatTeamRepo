import pandas as pd  #for data malipulation
import numpy as np   #for numerical operations
from matplotlib import pyplot as plt   #for displaying data

#configuaration for dat generation
num_months = 36 #generate data for 3 years (36 months)
start_date = '2023-01-01' #date our expense data starts
base_expense = 10000  #base monthly expense in Rand
monthly_increase = 200  ##average monthly increase in Rand
random_fluctuation = 1500 # max rando fluctuation in Rand

print('~~~Generating Synthetic Business Expense Data~~~')

#1 generate dates
#range of monthly dates
dates = pd.date_range(start = start_date, periods = num_months, freq = 'MS')

#2 generate expense
#calculate expenses with a base, a trend, and random noise
expenses = []
for i in range(num_months):
	#base expense = linear increase + random noise 
	expense = base_expense + (i * monthly_increase) + np.random.uniform(-random_fluctuation, random_fluctuation)
	expenses.append(max(5000, round(expense, 2))) #ensures expenses are at least R5000 and rounded to atleast 2 decimal points

#3 create pandas dataframe
#dataframe: a table-likee structure used for data
data = pd.DataFrame({
		'Month' : dates,
		'Expenses_R' : expenses
		})
#set Month as an index  for time series analysis
data.set_index('Month', inplace = True)

print("Data generated successfully. First 5 rows")
print(data.head())

#4 visualize the generated data
plt.figure(figsize =(12,6)) #size
plt.plot(data.index, data['Expenses_R'], marker='o', linestyle='-', color = 'pink', markersize=4)
plt.title('Joseph\'s Historical Monthly Business Expenses (R)')
plt.xlabel('Month')
plt.ylabel('Expenses (R)')
plt.grid(True)
plt.tight_layout() #prevents labels from overlapping
plt.savefig('historical_expenses.png') #save plot as an image
plt.show() #displays plot

#5 save data to csv
#saving data to a csv file for later use
data.to_csv('monthly_expenses.csv')
print("\nHistorical expense data saved to monthly_expenses.csv")
