from flask import Flask, redirect, url_for
from config import Config
from db import mysql
from auth import auth_bp
from teacher import teacher_bp
from occupation import occ_bp
from schedule import sched_bp
from salary import salary_bp
from fee import fee_bp
from report import report_bp
from backup import backup_bp
from page import page_bp  # 你新增的页面蓝图

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    mysql.init_app(app)

    @app.route('/')
    def home():
        return redirect(url_for('auth.login'))


    # 注册蓝图
    app.register_blueprint(auth_bp)
    app.register_blueprint(teacher_bp, url_prefix='/api/teachers')
    app.register_blueprint(occ_bp)
    app.register_blueprint(sched_bp, url_prefix='/api/schedules')
    app.register_blueprint(salary_bp, url_prefix='/api/salary')
    app.register_blueprint(fee_bp, url_prefix='/api/fee')
    app.register_blueprint(report_bp, url_prefix='/api/reports')
    app.register_blueprint(backup_bp, url_prefix='/api/backup')
    app.register_blueprint(page_bp)  # 页面蓝图，不带前缀，路径直接如 /dashboard.html

    return app

if __name__ == '__main__':
    app = create_app()
    print("Registered routes:")
    for rule in app.url_map.iter_rules():
        print(rule.endpoint, rule)
    app.run(debug=True)
