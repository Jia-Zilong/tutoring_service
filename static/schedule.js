// 加载教师下拉选项
async function loadOptions() {
  const res = await fetch('/api/teachers');
  const teachers = await res.json();
  const select = document.getElementById('sel-teacher');
  select.innerHTML = teachers.map(t => `<option value="${t[0]}">${t[1]}</option>`).join('');
}

// 加载表格数据
async function loadSchedules() {
  const res = await fetch('/api/schedules');
  const data = await res.json();
  const tbody = document.querySelector('#schedule-table tbody');
  tbody.innerHTML = '';
  data.forEach(row => {
    const [id, teacher_id, name, start, end, date] = row;
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${teacher_id}</td>
      <td>${name}</td>
      <td>${start}</td>
      <td>${end}</td>
      <td>${date}</td>
      <td>
        <button onclick="editRow('${id}', '${teacher_id}', '${date}', '${start}', '${end}')">修改</button>
        <button onclick="deleteRow(${id})">删除</button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

// 删除记录
async function deleteRow(id) {
  if (!confirm('确认删除这条作息记录吗？')) return;
  const res = await fetch('/api/schedules/delete', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ id })
  });
  const result = await res.json();
  if (result.status === 'deleted') {
    alert('删除成功');
    loadSchedules();
  } else {
    alert('删除失败');
  }
}

// 编辑：将选中的数据填入表单
function editRow(id, teacher_id, date, start, end) {
  const f = document.getElementById('schedule-form');
  f['sel-teacher'].value = teacher_id;
  f['work-date'].value = date;
  f['start-time'].value = start;
  f['end-time'].value = end;
  f.dataset.mode = 'edit';
  f.dataset.id = id;
}

// 表单提交
document.getElementById('schedule-form').onsubmit = async e => {
  e.preventDefault();
  const f = e.target;
  const mode = f.dataset.mode || 'add';
  const teacher_id = f['sel-teacher'].value;
  const work_date = f['work-date'].value;
  const start_time = f['start-time'].value;
  const end_time = f['end-time'].value;
  const id = f.dataset.id;

  if (!/^\d{4}-\d{2}-\d{2}$/.test(work_date)) {
    alert('请输入正确的日期格式：YYYY-MM-DD');
    return;
  }

  const year = parseInt(work_date.slice(0, 4), 10);
  if (year < 2022 || year > 2025) {
    alert('年份必须在 2022 到 2025 之间');
    return;
  }

  const url = mode === 'edit' ? '/api/schedules/update' : '/api/schedules';
  const body = { teacher_id, work_date, start_time, end_time };
  if (mode === 'edit') body.id = id;

  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body)
  });

  const result = await res.json();
  if (result.status === 'success' || result.status === 'updated') {
    alert(mode === 'edit' ? '修改成功' : '登记成功');
    f.reset();
    delete f.dataset.mode;
    delete f.dataset.id;
    loadSchedules();
  } else {
    alert((mode === 'edit' ? '修改' : '登记') + '失败');
  }
};

// 初始化
loadOptions().then(loadSchedules);
