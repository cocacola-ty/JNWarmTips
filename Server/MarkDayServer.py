#! /usr/bin/local/python3

from flask import Flask

app = Flask(__name__)

@app.route('/', methods=['POST','GET'])
def test():
    return "hello world"


app.run()
