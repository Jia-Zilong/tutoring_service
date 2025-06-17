# backup.py
import subprocess, time, os
from flask import Blueprint, send_file, request
from config import Config

backup_bp = Blueprint('backup', __name__)

@backup_bp.route('/download', methods=['GET'])
def download_backup():
    ts = int(time.time())
    fn = f"backup_{ts}.sql"
    cmd = f"mysqldump -h{Config.MYSQL_HOST} -u{Config.MYSQL_USER} " + \
          f"-p{Config.MYSQL_PASSWORD} {Config.MYSQL_DB} > {fn}"
    subprocess.run(cmd, shell=True)
    return send_file(fn, as_attachment=True)

@backup_bp.route('/restore', methods=['POST'])
def restore_db():
    f = request.files['file']
    fn = f.filename
    f.save(fn)
    cmd = f"mysql -h{Config.MYSQL_HOST} -u{Config.MYSQL_USER} " + \
          f"-p{Config.MYSQL_PASSWORD} {Config.MYSQL_DB} < {fn}"
    subprocess.run(cmd, shell=True)
    os.remove(fn)
    return {'status': 'restored'}
