from flask import Blueprint, request, jsonify
from db import mysql
import re

teacher_bp = Blueprint('teacher', __name__)

def is_valid_id(s):
    return bool(re.match(r'^[0-9]{4}$', s)) and '0001' <= s <= '9999'

def is_valid_phone(p):
    return bool(re.match(r'^1\d{10}$', p))

@teacher_bp.route('', methods=['GET'])
def list_teachers():
    cur = mysql.connection.cursor()
    cur.execute("SELECT id, name, gender, phone FROM teachers ORDER BY id")
    rows = cur.fetchall()
    result = []
    for row in rows:
        id_str = str(row[0]).zfill(4)
        result.append([id_str, row[1], row[2], row[3]])
    return jsonify(result)

@teacher_bp.route('', methods=['POST'])
def add_teacher():
    data = request.json
    tid = data.get('id', '').strip()

    if not is_valid_id(tid):
        return jsonify({'error': 'ID 必须是 0001-9999 的四位数字'}), 400
    if not is_valid_phone(data['contact']):
        return jsonify({'error': '请输入正确的电话号码'}), 400

    cur = mysql.connection.cursor()

    cur.execute("SELECT COUNT(*) FROM teachers WHERE id=%s", (tid,))
    if cur.fetchone()[0] > 0:
        return jsonify({'error': 'ID 已存在'}), 400

    cur.execute("SELECT COUNT(*) FROM teachers WHERE name=%s AND phone=%s", (data['name'], data['contact']))
    if cur.fetchone()[0] > 0:
        return jsonify({'error': '该教师信息已存在'}), 400

    try:
        cur.execute(
            "INSERT INTO teachers (id,name,gender,phone) VALUES (%s,%s,%s,%s)",
            (tid, data['name'], data['gender'], data['contact'])
        )
        mysql.connection.commit()
    except Exception as e:
        return jsonify({'error': str(e)}), 400

    return jsonify({'status': 'success'})

@teacher_bp.route('/<old_id>', methods=['PUT'])
def update_teacher(old_id):
    data = request.json
    new_id = data.get('id', '').strip()

    if not is_valid_id(new_id):
        return jsonify({'error': 'ID 必须是 0001-9999 的四位数字'}), 400
    if not is_valid_phone(data['contact']):
        return jsonify({'error': '请输入正确的电话号码'}), 400

    cur = mysql.connection.cursor()

    if new_id != old_id:
        cur.execute("SELECT COUNT(*) FROM teachers WHERE id=%s", (new_id,))
        if cur.fetchone()[0] > 0:
            return jsonify({'error': 'ID 已存在'}), 400

    cur.execute("SELECT COUNT(*) FROM teachers WHERE name=%s AND phone=%s AND id != %s",
                (data['name'], data['contact'], old_id))
    if cur.fetchone()[0] > 0:
        return jsonify({'error': '该教师信息已存在'}), 400

    cur.execute(
        "UPDATE teachers SET id=%s, name=%s, gender=%s, phone=%s WHERE id=%s",
        (new_id, data['name'], data['gender'], data['contact'], old_id)
    )
    mysql.connection.commit()
    return jsonify({'status': 'success'})

@teacher_bp.route('/<id>', methods=['DELETE'])
def delete_teacher(id):
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM teachers WHERE id=%s", (id,))
    mysql.connection.commit()
    return jsonify({'status': 'success'})
