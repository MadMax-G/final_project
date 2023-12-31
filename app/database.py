from flask import Flask, render_template, request, redirect, url_for
from pymongo import MongoClient

app = Flask(__name__)

# Connect to your MongoDB instance
client = MongoClient('mongodb://root:3yGWpZ7jeS@34.78.116.136:27017/')
db = client['links']  # Change 'key_value_db' to your preferred database name
collection = db['projects']


@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        key = request.form['key']
        value = request.form['value']

        # Insert the new key-value pair into MongoDB
        collection.insert_one({'key': key, 'value': value})

    links = list(collection.find())  # Retrieve all key-value pairs from MongoDB

    return render_template('index.html', links=links)


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=9090)
