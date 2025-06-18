from flask import Blueprint, request, jsonify
from db import mysql

sched_bp = Blueprint('sched', __name__)

@sched_bp.route('', methods=['GET'])
def list_sched():
    teacher_id = request.args.get('teacher_id')
    start_date = request.args.get('start')
    end_date = request.args.get('end')

    query = """
        SELECT id, teacher_id, teacher_name, start_time, end_time, date, occupation_name, level
        FROM schedule
        WHERE 1=1
    """
    params = []
    if teacher_id:
        query += " AND teacher_id = %s"
        params.append(teacher_id)
    if start_date:
        query += " AND date >= %s"
        params.append(start_date)
    if end_date:
        query += " AND date <= %s"
        params.append(end_date)
    query += " ORDER BY date, start_time"

    cur = mysql.connection.cursor()
    cur.execute(query, tuple(params))
    rows = cur.fetchall()
    return jsonify([
        [int(id), teacher_id, teacher_name, str(start), str(end), str(date), occupation_name or '暂无', level or '暂无']
        for id, teacher_id, teacher_name, start, end, date, occupation_name, level in rows
    ])


@sched_bp.route('', methods=['POST'])
def add_sched():
    d = request.json
    teacher_id = d['teacher_id']
    date = d['work_date']
    start = d['start_time']
    end = d['end_time']
    occupation_name = d['occupation_name']
    level = d['level']
    cur = mysql.connection.cursor()
    cur.execute("SELECT name FROM teachers WHERE id = %s", (teacher_id,))
    teacher = cur.fetchone()
    name = teacher[0] if teacher else "未知"
    cur.execute("""
        INSERT INTO schedule (teacher_id, teacher_name, date, start_time, end_time, occupation_name, level)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """, (teacher_id, name, date, start, end, occupation_name, level))
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
        SET teacher_id = %s, teacher_name = %s, date = %s, start_time = %s, end_time = %s,
            occupation_name = %s, level = %s
        WHERE id = %s
    """, (d['teacher_id'], teacher_name, d['work_date'], d['start_time'], d['end_time'],
          d['occupation_name'], d['level'], d['id']))
    mysql.connection.commit()
    return jsonify({'status': 'updated'})

@sched_bp.route('/occupations/<teacher_id>', methods=['GET'])
def get_occupations_by_teacher(teacher_id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT occupation_name, level FROM occupation WHERE teacher_id = %s", (teacher_id,))
    rows = cur.fetchall()
    return jsonify(rows)
