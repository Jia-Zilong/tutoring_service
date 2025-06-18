import subprocess
import time
import os
from flask import Blueprint, send_from_directory, request, jsonify
from config import Config
from db import mysql  # 你的db初始化
from MySQLdb.cursors import DictCursor

backup_bp = Blueprint('backup', __name__, url_prefix='/api/backup')

BACKUP_DIR = 'backups'
os.makedirs(BACKUP_DIR, exist_ok=True)

@backup_bp.route('/backup_now', methods=['POST'])
def backup_now():
    data = request.get_json() or {}
    desc = data.get('description', '').strip()
    ts = time.strftime('%Y%m%d_%H%M%S')
    fn = f"backup_{ts}.sql"
    path = os.path.join(BACKUP_DIR, fn)
    cmd = f"mysqldump -h{Config.MYSQL_HOST} -u{Config.MYSQL_USER} " + \
          f"-p{Config.MYSQL_PASSWORD} {Config.MYSQL_DB} > {path}"
    try:
        subprocess.run(cmd, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        return jsonify({'status': '备份失败', 'error': str(e)}), 500

    try:
        with mysql.connection.cursor() as cursor:
            cursor.execute(
                "INSERT INTO backup_history (backup_name, backup_time, description) VALUES (%s, NOW(), %s)",
                (fn, desc)
            )
            mysql.connection.commit()
    except Exception as e:
        return jsonify({'status': '写入备份历史失败', 'error': str(e)}), 500

    return jsonify({'status': f'已备份为 {fn}'})


@backup_bp.route('/list', methods=['GET'])
def list_backups():
    try:
        cursor = mysql.connection.cursor(DictCursor)
        cursor.execute(
            "SELECT backup_name, backup_time, description FROM backup_history ORDER BY backup_time DESC"
        )
        rows = cursor.fetchall()
        cursor.close()

        for r in rows:
            if r['backup_time']:
                dt = r['backup_time']
                r['time'] = f"{dt.year}年{dt.month}月{dt.day}日 {dt.hour:02d}:{dt.minute:02d}:{dt.second:02d}"
            else:
                r['time'] = ''
        return jsonify({'files': rows})
    except Exception as e:
        return jsonify({'files': [], 'error': str(e)}), 500


@backup_bp.route('/restore_from_file', methods=['POST'])
def restore_from_file():
    data = request.get_json()
    fn = data.get('filename') if data else None
    if not fn or not fn.endswith('.sql'):
        return jsonify({'status': '无效的文件名'}), 400
    path = os.path.join(BACKUP_DIR, fn)
    if not os.path.exists(path):
        return jsonify({'status': '文件不存在'}), 404
    cmd = f"mysql -h{Config.MYSQL_HOST} -u{Config.MYSQL_USER} " + \
          f"-p{Config.MYSQL_PASSWORD} {Config.MYSQL_DB} < {path}"
    try:
        subprocess.run(cmd, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        return jsonify({'status': '恢复失败', 'error': str(e)}), 500
    return jsonify({'status': f'成功恢复到 {fn}'})


@backup_bp.route('/file/<path:filename>', methods=['GET'])
def download_file(filename):
    return send_from_directory(BACKUP_DIR, filename, as_attachment=True)


@backup_bp.route('/delete', methods=['POST'])
def delete_backup():
    data = request.get_json()
    fn = data.get('filename') if data else None
    if not fn or not fn.endswith('.sql'):
        return jsonify({'status': '无效的文件名'}), 400

    path = os.path.join(BACKUP_DIR, fn)
    if not os.path.exists(path):
        return jsonify({'status': '文件不存在'}), 404

    try:
        os.remove(path)
    except Exception as e:
        return jsonify({'status': '删除文件失败', 'error': str(e)}), 500

    try:
        with mysql.connection.cursor() as cursor:
            cursor.execute("DELETE FROM backup_history WHERE backup_name = %s", (fn,))
            mysql.connection.commit()
    except Exception as e:
        return jsonify({'status': '删除备份历史失败', 'error': str(e)}), 500

    return jsonify({'status': f'已删除备份文件 {fn}'})
