import pandas as pd 
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, r2_score
import joblib
from matplotlib import pyplot as plt

print('~~~Training Smart Business Expense Predictor Model~~~')

try:
	data = pd.read_csv('monthly_expenses.csv', index_col = 'Month', parse_dates = True)
	print('Data loaded successfully. shape:', data.shape)
except FileNotFoundError:
	print("Error: monthly_expenses.csv not found. Please run generate_data.py first")
	exit()


X = np.array(range(1, len(data) + 1)).reshape(-1, 1)

Y = data['Expenses_R'] 




X_train, Y_train= X, Y

print(f'Training data size: {len(X_train)} samples.')

model = LinearRegression()
model.fit(X_train, Y_train)


print('Model training complete.')
print(f'\nModel Coefficient (slope): {model.coef_[0]:2f} R/month')
print(f'Model Intercept: R{model.intercept_:.2f}')


Y_pred = model.predict(X_train)
mae = mean_absolute_error(Y_train, Y_pred)

r2 = r2_score(Y_train, Y_pred)

print(f'\nModel Evaluation (on training data):')
print(f' Mean Absolute Error (MAE): R{mae:.2f}')
print(f'R-squared (R2) Score: {r2:.2f}')

plt.figure(figsize = (12,6))
plt.plot(data.index, Y, label = 'Actual Expenses', marker = 'o', linestyle = '-', color = 'indigo', markersize = 4)
plt.plot(data.index, Y_pred, label = 'Predicted Expenses (Model)', linestyle = '--', color = 'pink')
plt.title('Historical Monthly Business Expense')
plt.xlabel('Month')
plt.ylabel('Expenses (R)')
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.savefig('model_predictions.png')
plt.show



model_filename = 'expense_predictor_model.pkl'
joblib.dump(model, model_filename)
print(f'\nMachine learning model saved as {model_filename}')