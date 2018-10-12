#! /usr/bin/local/python3

from flask import Flask, request
import os
import sqlite3

app = Flask(__name__)

@app.route('/', methods=['POST','GET'])
def test():
    return "hello world"


@app.route('/updateData', methods=['POST'])
def synchronizeData():
    # 检查环境是否满足
    # 获取传递来的参数
    name = request.form.get('name')
    print(name)
    # 插入数据库
    return "success"


@app.route('/updateGroup', methods=['POST'])
def synchronizeGroup():
    pass


def prepareContext():
    # 检查是否存在数据库文件
    db_path = './JN.db'
    if not os.path.exists(db_path):
        # 创建数据库
        conn = sqlite3.connect(db_path)
        print(conn)
            
    pass


app.run()
