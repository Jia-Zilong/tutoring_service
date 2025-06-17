# db.py
from flask_mysqldb import MySQL
from flask import Flask
import config

mysql = MySQL()

def init_db(app: Flask):
    app.config.from_object(config)
    mysql.init_app(app)
