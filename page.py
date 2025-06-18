from flask import Blueprint, render_template, session, redirect, url_for
from functools import wraps  # 这里改成从functools导入wraps


page_bp = Blueprint('page', __name__, template_folder='templates')

def login_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        if 'user' not in session:
            return redirect(url_for('auth.login'))
        return func(*args, **kwargs)
    return wrapper

@page_bp.route('/dashboard.html')
@login_required
def dashboard():
    return render_template('dashboard.html')

@page_bp.route('/teachers.html')
@login_required
def teachers():
    return render_template('teachers.html')

@page_bp.route('/schedule.html')
@login_required
def schedule():
    return render_template('schedule.html')

@page_bp.route('/report.html')
@login_required
def report():
    return render_template('report.html')

@page_bp.route('/occupation.html')
@login_required
def occupation():
    return render_template('occupation.html')

@page_bp.route('/salary.html')
@login_required
def salary():
    return render_template('salary.html')

@page_bp.route('/fee.html')
@login_required
def fee():
    return render_template('fee.html')

@page_bp.route('/backup.html')
@login_required
def backup():
    return render_template('backup.html')
