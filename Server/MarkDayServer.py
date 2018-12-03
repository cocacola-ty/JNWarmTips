#!/usr/bin/local/python3

import os
import sqlite3
import json
from flask import Flask, request, Response

APP = Flask(__name__)

@APP.route('/', methods=['POST', 'GET'])
def test():
    """
    test method
    """
    return "hello world"


@APP.route('/updateData', methods=['POST'])
def synchronize_data():
    """
    更新APP端数据
    """
    # 检查环境是否满足
    # 获取传递来的参数
    #print(request.form)
    datas = request.form.get('datas')
    data = json.loads(datas)
    print(data[0])

    # 插入数据库
    content = json.dumps({"code":"200"})
    res = Response(content, mimetype="APPlication/json")
    return res


@APP.route('/updateGroup', methods=['POST'])
def synchronize_group():
    """
    更新小组数据
    """
    pass


def prepare_context():
    """
    准备数据环境
    """

    # 检查是否存在数据库文件
    db_path = './JN.db'
    if not os.path.exists(db_path):
        # 创建数据库
        conn = sqlite3.connect(db_path)
        print(conn)


APP.run()
