from flask import Blueprint, request, jsonify
from db import mysql

occ_bp = Blueprint('occupation', __name__, url_prefix='/api/occupation')

@occ_bp.route('', methods=['GET'])
def list_occupations():
    # 返回所有职业登记，包含老师id、职业名和分级
    cur = mysql.connection.cursor()
    cur.execute("SELECT teacher_id, occupation_name, level FROM occupation ORDER BY teacher_id, occupation_name")
    results = cur.fetchall()
    columns = [desc[0] for desc in cur.description]
    data = [dict(zip(columns, row)) for row in results]
    cur.close()
    return jsonify(data)

@occ_bp.route('', methods=['POST'])
def add_occupation():
    # 添加一条老师的职业记录，包含level
    data = request.json
    teacher_id = data.get('teacher_id')
    occupation_name = data.get('occupation_name')
    level = data.get('level')
    if not teacher_id or not occupation_name or not level:
        return jsonify({'status': 'error', 'message': 'teacher_id, occupation_name和level不能为空'}), 400

    # 校验分级和职业是否匹配
    level_options = {
        '小学': ['语文教学', '数学教学', '英语教学'],
        '初中': ['语文教学', '数学教学', '英语教学', '生物教学', '化学教学', '地理教学', '物理教学'],
        '高中': ['语文教学', '数学教学', '英语教学', '生物教学', '化学教学', '地理教学', '物理教学']
    }
    if level not in level_options or occupation_name not in level_options[level]:
        return jsonify({'status': 'error', 'message': f'职业"{occupation_name}"不适用于分级"{level}"'}), 400

    cur = mysql.connection.cursor()
    try:
        cur.execute(
            "INSERT INTO occupation (teacher_id, occupation_name, level) VALUES (%s, %s, %s)",
            (teacher_id, occupation_name, level)
        )
        mysql.connection.commit()
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500
    finally:
        cur.close()
    return jsonify({'status': 'success'})

@occ_bp.route('', methods=['DELETE'])
def delete_occupation():
    # 删除老师的职业记录，需要传 teacher_id, occupation_name 和 level 参数
    teacher_id = request.args.get('teacher_id')
    occupation_name = request.args.get('occupation_name')
    level = request.args.get('level')
    if not teacher_id or not occupation_name or not level:
        return jsonify({'status': 'error', 'message': 'teacher_id, occupation_name和level不能为空'}), 400

    cur = mysql.connection.cursor()
    try:
        cur.execute(
            "DELETE FROM occupation WHERE teacher_id=%s AND occupation_name=%s AND level=%s",
            (teacher_id, occupation_name, level)
        )
        mysql.connection.commit()
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500
    finally:
        cur.close()
    return jsonify({'status': 'success'})
