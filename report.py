from flask import Blueprint, request, jsonify
from db import mysql
from datetime import timedelta

report_bp = Blueprint('report', __name__)

@report_bp.route('/hours', methods=['GET'])
def get_hours():
    start = request.args.get('start')
    end = request.args.get('end')
    teacher_id = request.args.get('teacher_id', None)

    cur = mysql.connection.cursor()
    cur.callproc('TotalHoursPerTeacherByLevel', [start, end, teacher_id or ''])
    results = cur.fetchall()
    columns = [desc[0] for desc in cur.description]

    data = []
    for row in results:
        item = {}
        for col, val in zip(columns, row):
            if isinstance(val, timedelta):
                total_seconds = int(val.total_seconds())
                hours = total_seconds // 3600
                minutes = (total_seconds % 3600) // 60
                seconds = total_seconds % 60
                val = f"{hours:02d}:{minutes:02d}:{seconds:02d}"
            item[col] = val or '暂无'
        data.append(item)

    cur.close()
    return jsonify(data)



@report_bp.route('/occupation', methods=['GET'])
def get_occ_usage():
    cur = mysql.connection.cursor()
    cur.callproc('CountOccupationUsage')
    results = cur.fetchall()
    columns = [desc[0] for desc in cur.description]
    data = [dict(zip(columns, row)) for row in results]
    cur.close()
    return jsonify(data)
