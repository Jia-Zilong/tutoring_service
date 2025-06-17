from flask import Blueprint, request, jsonify
from db import mysql

salary_bp = Blueprint('salary', __name__)

@salary_bp.route('', methods=['GET'])
def list_salaries():
    cur = mysql.connection.cursor()
    cur.execute("SELECT teacher_id, amount, date FROM salary ORDER BY date")
    rows = cur.fetchall()
    return jsonify([
        {
            'teacher_id': row[0],
            'amount': float(row[1]),
            'date': row[2].isoformat() if row[2] else None
        } for row in rows
    ])

@salary_bp.route('', methods=['POST'])
def add_salary():
    data = request.json
    teacher_id = data.get('teacher_id')
    amount = data.get('amount')
    date = data.get('date')

    cur = mysql.connection.cursor()
    try:
        cur.execute(
            "INSERT INTO salary (teacher_id, amount, date) VALUES (%s, %s, %s)",
            (teacher_id, amount, date)
        )
        mysql.connection.commit()
        return jsonify({'status': 'success'})
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@salary_bp.route('/<teacher_id>', methods=['PUT'])
def update_salary(teacher_id):
    data = request.json
    amount = data.get('amount')
    date = data.get('date')

    cur = mysql.connection.cursor()
    try:
        cur.execute(
            "UPDATE salary SET amount=%s, date=%s WHERE teacher_id=%s",
            (amount, date, teacher_id)
        )
        mysql.connection.commit()
        return jsonify({'status': 'success'})
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@salary_bp.route('/<teacher_id>', methods=['DELETE'])
def delete_salary(teacher_id):
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM salary WHERE teacher_id=%s", (teacher_id,))
    mysql.connection.commit()
    return jsonify({'status': 'success'})