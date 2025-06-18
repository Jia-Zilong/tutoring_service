from flask import Blueprint, request, jsonify
from db import mysql

salary_bp = Blueprint('salary', __name__, url_prefix='/api/salary')


@salary_bp.route('', methods=['GET'])
def list_salaries():
    teacher_name = request.args.get('teacher_name')
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')

    query = """
        SELECT schedule_id, teacher_name, level, occupation_name,
               date, start_time, end_time, salary_amount, pay_status
        FROM salary
        WHERE 1=1
    """
    params = []

    if teacher_name:
        query += " AND teacher_name = %s"
        params.append(teacher_name)

    if start_date:
        query += " AND date >= %s"
        params.append(start_date)

    if end_date:
        query += " AND date <= %s"
        params.append(end_date)

    query += " ORDER BY date DESC"

    cur = mysql.connection.cursor()
    cur.execute(query, tuple(params))
    rows = cur.fetchall()
    return jsonify([
        {
            'schedule_id': row[0],
            'teacher_name': row[1],
            'level': row[2],
            'occupation_name': row[3],
            'date': row[4].isoformat() if row[4] else None,
            'start_time': str(row[5]) if row[5] else None,
            'end_time': str(row[6]) if row[6] else None,
            'salary_amount': float(row[7]),
            'pay_status': row[8]
        } for row in rows
    ])


@salary_bp.route('/<int:schedule_id>', methods=['PUT'])
def update_salary_status(schedule_id):
    data = request.json
    pay_status = data.get('pay_status')
    if pay_status not in ('paid', 'unpaid'):
        return jsonify({'error': 'Invalid pay_status'}), 400

    cur = mysql.connection.cursor()
    try:
        cur.execute(
            "UPDATE salary SET pay_status=%s WHERE schedule_id=%s",
            (pay_status, schedule_id)
        )
        mysql.connection.commit()
        return jsonify({'status': 'success'})
    except Exception as e:
        return jsonify({'error': str(e)}), 400


@salary_bp.route('/teachers', methods=['GET'])
def list_teacher_names():
    cur = mysql.connection.cursor()
    cur.execute("SELECT DISTINCT teacher_name FROM salary")
    names = [row[0] for row in cur.fetchall()]
    return jsonify(names)
