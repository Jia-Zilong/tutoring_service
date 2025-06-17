from flask import Blueprint, request, jsonify
from db import mysql

fee_bp = Blueprint('fee', __name__)

@fee_bp.route('', methods=['GET'])
def list_fees():
    cur = mysql.connection.cursor()
    cur.execute("SELECT teacher_id, occupation_name, amount, date FROM fee ORDER BY date")
    rows = cur.fetchall()
    return jsonify([
        {
            'teacher_id': row[0],
            'occupation_name': row[1],
            'amount': float(row[2]),
            'date': row[3].isoformat() if row[3] else None
        } for row in rows
    ])

@fee_bp.route('', methods=['POST'])
def add_fee():
    data = request.json
    teacher_id = data.get('teacher_id')
    occupation_name = data.get('occupation_name')
    amount = data.get('amount')
    date = data.get('date')

    cur = mysql.connection.cursor()
    try:
        cur.execute(
            "INSERT INTO fee (teacher_id, occupation_name, amount, date) VALUES (%s, %s, %s, %s)",
            (teacher_id, occupation_name, amount, date)
        )
        mysql.connection.commit()
        return jsonify({'status': 'success'})
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@fee_bp.route('/<teacher_id>', methods=['PUT'])
def update_fee(teacher_id):
    data = request.json
    occupation_name = data.get('occupation_name')
    amount = data.get('amount')
    date = data.get('date')

    cur = mysql.connection.cursor()
    try:
        cur.execute(
            "UPDATE fee SET occupation_name=%s, amount=%s, date=%s WHERE teacher_id=%s",
            (occupation_name, amount, date, teacher_id)
        )
        mysql.connection.commit()
        return jsonify({'status': 'success'})
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@fee_bp.route('/<teacher_id>', methods=['DELETE'])
def delete_fee(teacher_id):
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM fee WHERE teacher_id=%s", (teacher_id,))
    mysql.connection.commit()
    return jsonify({'status': 'success'})