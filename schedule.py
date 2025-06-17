from flask import Blueprint, request, jsonify
from db import mysql

sched_bp = Blueprint('sched', __name__)

@sched_bp.route('', methods=['GET'])
def list_sched():
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT id, teacher_id, teacher_name, start_time, end_time, date
        FROM schedule
        ORDER BY date, start_time
    """)
    rows = cur.fetchall()
    return jsonify([
        [int(id), teacher_id, teacher_name, str(start), str(end), str(date)]
        for id, teacher_id, teacher_name, start, end, date in rows
    ])

@sched_bp.route('', methods=['POST'])
def add_sched():
    d = request.json
    teacher_id = d['teacher_id']
    date = d['work_date']
    start = d['start_time']
    end = d['end_time']
    cur = mysql.connection.cursor()
    cur.execute("SELECT name FROM teachers WHERE id = %s", (teacher_id,))
    teacher = cur.fetchone()
    name = teacher[0] if teacher else "未知"
    cur.execute("""
        INSERT INTO schedule (teacher_id, date, start_time, end_time, teacher_name)
        VALUES (%s, %s, %s, %s, %s)
    """, (teacher_id, date, start, end, name))
    mysql.connection.commit()
    return jsonify({'status': 'success'})

@sched_bp.route('/delete', methods=['POST'])
def delete_sched():
    d = request.json
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM schedule WHERE id = %s", (d['id'],))
    mysql.connection.commit()
    return jsonify({'status': 'deleted'})

@sched_bp.route('/update', methods=['POST'])
def update_sched():
    d = request.json
    cur = mysql.connection.cursor()
    cur.execute("SELECT name FROM teachers WHERE id = %s", (d['teacher_id'],))
    teacher = cur.fetchone()
    teacher_name = teacher[0] if teacher else "未知"
    cur.execute("""
        UPDATE schedule
        SET teacher_id = %s, teacher_name = %s, date = %s, start_time = %s, end_time = %s
        WHERE id = %s
    """, (d['teacher_id'], teacher_name, d['work_date'], d['start_time'], d['end_time'], d['id']))
    mysql.connection.commit()
    return jsonify({'status': 'updated'})
