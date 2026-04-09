from flask import Flask, jsonify, request, render_template
import joblib
import numpy as np 
import os #checks if model file exists

app=Flask(__name__)   #creates an instance for the Flask application


#~~~Machine Learning Model Loading~~~
#define the path to our saved model file.
MODEL_PATH = 'expense_predictor_model.pkl'

#intialize the model variable to None. It will be loaded when the app starts
model = None

#check if the model file exists before trying to load it.
if os.path.exists(MODEL_PATH):
	model = joblib.load(MODEL_PATH)#loads trained model from thr file 
	print(f'Machine Learning Model loaded successfully from {MODEL_PATH}') 
else:
	#if model isnt found this is displayed
	print(f'WARNING :Model file {MODEL_PATH} not found. Please run train_model.py first')

#api routes 

@app.route('/')#decorator to define the root URL route.
def home():
	"""Returns a simple welcome message as JSON when the root URL is accessed"""
	#jsonify converts python dictionary into JSON response.
	return render_template('home.html')

@app.route('/predict_expense', methods = ['POST'])#define a route for expense prediction, only accepting POST requsts.
def predict_expense():
	"""Predicts business expenses based on a given month number using the loaded ML model"""
	#checks if the model was loaded successfuly. if not , returns an error.
	if model is None:
		 return jsonify({"error": "Expense prediction model not available. Please train model first."}), 500 #500 internal server error

		 # get JSON dat sent int the request body.
	request_data = request.get_json()

		 #basic validation to check if 'month_number' is present in the request data.
	if not request_data or 'month_number' not in request_data:
		 return jsonify({"error: please provide 'month_number' in the request body"}), 400 #400 bad request
	try:
		#extract month number from the request data
		month_number = int(request_data['month_number'])

		#validate month_number to be positive
		if month_number <= 0 :
		 		return jsonify({"error" : "'month_number' must be a positive integar."}), 400

		#the model expects a 2D array for input, even for single predictions
		#we can convert the month number to a numpy array and reshape it.
		prediction_input = np.array([[month_number]])

		#make the prediction using the  loaded  machine learning model
		predicted_expense = model.predict(prediction_input)[0]

		#ensure the predicted expense is not negative and round to 2 decimal places
		predicted_expense = max(0, round(predicted_expense, 2))

		#return prediction as a JSON response
		return jsonify({
		 	"month_number" : month_number,
		 	"predicted_expense_R" : predicted_expense
		 })
	except ValueError:
		#handle cases where 'month_number' is not a vaild integar.
		return jsonify({"error":"Invaild 'month_number' value. Must be an  integer."}), 400
	except Exception as e:
		 	#catch any other unexpected errors during the prediction process.
		 	return jsonify({"error" : f"An unexpected error occured during prediction: {str(e)}"}), 500 #500 internal server error


#~~run the Flask Application ~~
#this block ensures the app runs only when the script is exected directly.
if __name__ : '__main__'
#debug - True enables debug mode : provides detailed  error messages and auto_reloads the server on code vhanges.
app.run(debug=True)

