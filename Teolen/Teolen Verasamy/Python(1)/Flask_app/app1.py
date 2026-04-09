from Flask import flask
app=flask(__name__)

@app.route('/')
def home():
	return "Hello world this is Teolen's first Flask application."

	if __name__:'__main__'
	app.run(debug = True)