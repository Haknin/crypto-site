from flask import Flask, render_template, session, jsonify
import requests

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Set a secret key for session encryption

@app.route("/")
def home_page():
    session['visits'] = session.get('visits', 0) + 1  # Increment page visit count
    return render_template("HomePage.html")

@app.route("/eth")
def eth():
    session['visits'] = session.get('visits', 0) + 1  # Increment page visit count

    eth_response = requests.get("https://api.coinstats.app/public/v1/coins/ethereum")     # Make a GET request to the CoinDesk API
    if eth_response.status_code == 200:
        eth_price = eth_response.json()["coin"]["price"]
        
    # Pass the Ethereum price data to the template
    return render_template("eth.html", eth_price=eth_price)

@app.route("/btc")
def btc():
    session['visits'] = session.get('visits', 0) + 1  # Increment page visit count

    btc_response = requests.get("https://api.coindesk.com/v1/bpi/currentprice.json")
    if btc_response.status_code == 200:
        bitcoin_price = btc_response.json()["bpi"]["USD"]["rate"]

    # Pass the Bitcoin price data to the template
    return render_template("btc.html", bitcoin_price=bitcoin_price)

@app.route("/visit_count")
def visit_count():
    count = session.get('visits', 0)
    return jsonify(count=count)

if __name__ == '__main__':
    app.run()
