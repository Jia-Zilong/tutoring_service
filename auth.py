from flask import Blueprint, request, session, redirect, url_for, render_template
from db import mysql

auth_bp = Blueprint('auth', __name__, template_folder='templates')

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user = request.form['username']
        pwd = request.form['password']

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM admin WHERE username=%s AND password=%s", (user, pwd))
        result = cur.fetchone()
        cur.close()

        if result:
            session['user'] = user
            return redirect(url_for('page.dashboard'))
        return '登录失败', 401

    return render_template('login.html')

@auth_bp.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('auth.login'))
