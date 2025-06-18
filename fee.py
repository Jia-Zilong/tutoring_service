from flask import Blueprint, request, jsonify
from db import mysql
from datetime import timedelta

def format_time(t):
    if t is None:
        return None
    if hasattr(t, 'strftime'):
        return t.strftime('%H:%M')
    if isinstance(t, timedelta):
        total_seconds = int(t.total_seconds())
        hours = total_seconds // 3600
        minutes = (total_seconds % 3600) // 60
        return f'{hours:02}:{minutes:02}'
    return str(t)

fee_bp = Blueprint('fee', __name__, url_prefix='/api/fee')

@fee_bp.route('', methods=['GET'])
def list_fees():
    teacher_name = request.args.get('teacher_name')
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')

    query = """
        SELECT schedule_id, teacher_name, level, occupation_name, date, start_time, end_time, fee_amount, pay_status 
        FROM fee
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

    query += " ORDER BY date DESC, start_time"

    cur = mysql.connection.cursor()
    cur.execute(query, params)
    rows = cur.fetchall()

    fees = []
    for row in rows:
        fee = {
            'schedule_id': row[0],
            'teacher_name': row[1],
            'level': row[2],
            'occupation_name': row[3],
            'date': row[4].isoformat() if row[4] else None,
            'start_time': format_time(row[5]),
            'end_time': format_time(row[6]),
            'fee_amount': float(row[7]),
            'pay_status': row[8]
        }
        fees.append(fee)

    cur.close()
    return jsonify(fees)

@fee_bp.route('/<int:schedule_id>', methods=['PUT'])
def update_fee_status(schedule_id):
    data = request.json
    status = data.get('pay_status')
    if status not in ('paid', 'unpaid'):
        return jsonify({'error': 'Invalid pay_status'}), 400

    cur = mysql.connection.cursor()
    cur.execute("UPDATE fee SET pay_status = %s WHERE schedule_id = %s", (status, schedule_id))
    mysql.connection.commit()
    cur.close()
    return jsonify({'status': 'success'})

@fee_bp.route('/<int:schedule_id>', methods=['DELETE'])
def delete_fee(schedule_id):
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM fee WHERE schedule_id = %s", (schedule_id,))
    mysql.connection.commit()
    cur.close()
    return jsonify({'status': 'deleted'})
