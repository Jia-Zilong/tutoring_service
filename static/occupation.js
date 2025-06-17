const levelOptions = {
  '小学': ['语文教学', '数学教学', '英语教学'],
  '初中': ['语文教学', '数学教学', '英语教学', '生物教学', '化学教学', '地理教学', '物理教学'],
  '高中': ['语文教学', '数学教学', '英语教学', '生物教学', '化学教学', '地理教学', '物理教学']
};

async function loadTeachers() {
  const res = await fetch('/api/teachers');
  const teachers = await res.json();
  const select = document.getElementById('teacher-select');
  teachers.forEach(t => {
    const opt = document.createElement('option');
    opt.value = t.id || t[0];  // 兼容不同格式
    opt.textContent = t.name || t[1];
    select.appendChild(opt);
  });
}

function updateOccupationOptions() {
  const levelSelect = document.getElementById('level-select');
  const occupationSelect = document.getElementById('occupation-select');
  const level = levelSelect.value;

  occupationSelect.innerHTML = '<option value="">请选择职业</option>';

  if (!level || !levelOptions[level]) {
    occupationSelect.disabled = true;
    return;
  }

  levelOptions[level].forEach(occ => {
    const opt = document.createElement('option');
    opt.value = occ;
    opt.textContent = occ;
    occupationSelect.appendChild(opt);
  });

  occupationSelect.disabled = false;
}

async function loadOccupations() {
  const res = await fetch('/api/occupation');
  const data = await res.json();
  const tbody = document.querySelector('#occupation-table tbody');
  tbody.innerHTML = '';
  data.forEach(item => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${item.teacher_id}</td>
      <td>${item.occupation_name}</td>
      <td>${item.level}</td>
      <td><button class="delete-btn" data-teacher="${item.teacher_id}" data-occ="${item.occupation_name}" data-level="${item.level}">删除</button></td>
    `;
    tbody.appendChild(tr);
  });

  // 绑定删除事件
  document.querySelectorAll('.delete-btn').forEach(btn => {
    btn.addEventListener('click', async () => {
      const teacher_id = btn.getAttribute('data-teacher');
      const occupation_name = btn.getAttribute('data-occ');
      const level = btn.getAttribute('data-level');
      if (confirm(`确定删除教师 ${teacher_id} 的职业 "${occupation_name}" (分级：${level}) 吗？`)) {
        const res = await fetch(`/api/occupation?teacher_id=${teacher_id}&occupation_name=${encodeURIComponent(occupation_name)}&level=${encodeURIComponent(level)}`, {
          method: 'DELETE'
        });
        const result = await res.json();
        if (result.status === 'success') {
          loadOccupations();
        } else {
          alert('删除失败: ' + result.message);
        }
      }
    });
  });
}

document.addEventListener('DOMContentLoaded', () => {
  loadTeachers();
  loadOccupations();

  document.getElementById('level-select').addEventListener('change', updateOccupationOptions);

  document.getElementById('add-btn').addEventListener('click', async () => {
    const teacher_id = document.getElementById('teacher-select').value;
    const occupation_name = document.getElementById('occupation-select').value;
    const level = document.getElementById('level-select').value;
    if (!teacher_id) {
      alert('请选择教师');
      return;
    }
    if (!level) {
      alert('请选择分级');
      return;
    }
    if (!occupation_name) {
      alert('请选择职业');
      return;
    }
    const res = await fetch('/api/occupation', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({teacher_id, occupation_name, level})
    });
    const result = await res.json();
    if (result.status === 'success') {
      // 重置职业选择框，但分级保持选中状态
      document.getElementById('occupation-select').value = '';
      loadOccupations();
    } else {
      alert('添加失败: ' + result.message);
    }
  });
});
