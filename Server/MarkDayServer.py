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
    datas = request.form.get('datas')
    data = json.loads(datas)

    # 插入数据库
    connection = prepare_context()
    cursor = connection.cursor()
    cursor.execute("")

    # 返回需要本地进行更新的数据
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
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    create_group_sql = """
        create table if not exists group_table (
            group_id integer primary key not null,
            group_name text not null,
            group_type integer default 0,
            deleted integer default 0,
            update_time integer
        )
    """
    cur.execute(create_group_sql)

    create_category_sql = """
    create table if not exists category_table (
        category_id integer primary key not null,
        category_name text not null,
        group_id integer,
        deleted integer default 0,
        update_time integer,
        foreign key(group_id) references group_table(group_id)
    )
    """
    cur.execute(create_category_sql)

    create_list_sql = """
    create table if not exists list_table(
        item_id integer primary key not null,
        content text not null,
        start_time integer default 0,
        end_time integer default 0,
        group_id integer,
        category_id integer,
        category_name text,
        notification integer default 0,
        finished integer default 0,
        deleted integer default 0,
        update_time integer,
        foreign key(group_id) references group_table(group_id),
        foreign key(category_id) references category_table(category_id)
    )
    """
    cur.execute(create_list_sql)

    create_event_type_table = """
    create table if not exists event_type_table (
        event_type_id integer primary key autoincrement,
        event_type_name text,
        color text not null
    )
    """
    init_data_sql = """
    insert or ignore into event_type_table (
        'event_type_id','event_type_name','color'
    ) values (0, '个人', 'FF364F'),(1, '工作', '00BFFF')
    """
    cur.execute(create_event_type_table)
    cur.execute(init_data_sql)

    create_events_sql = """
    create table if not exists events_table(
        events_id integer primary key not null,
        content text not null,
        show_date date not null,
        event_type_id integer not null,
        event_type_color varchar(10),
        start_time integer default 0,
        end_time integer default 0,
        notification integer default 0,
        deleted integer default 0,
        update_time integer
    )
    """
    cur.execute(create_events_sql)

    return conn


APP.run()
