#! /usr/bin/local/python3

from flask import Flask, request
import os

app = Flask(__name__)

@app.route('/', methods=['POST','GET'])
def test():
    return "hello world"


@app.route('/updateData', methods=['POST'])
def synchronizeData():
    # 检查环境是否满足
    # 获取传递来的参数
    name = request.form.get('name')
    # 插入数据库
    return "success"


def prepareContext():
    # 检查是否存在数据库文件
    db_path = './JN.db'
    if not os.path.exists(db_path):
        # 创建数据库
        pass
            
    pass


app.run()
