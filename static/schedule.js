async function loadOptions() {
  const res = await fetch('/api/teachers');
  const teachers = await res.json();
  const teacherSelect = document.getElementById('sel-teacher');
  teacherSelect.innerHTML = teachers.map(t => `<option value="${t[0]}">${t[1]}</option>`).join('');

  const filterSelect = document.getElementById('filter-teacher');
  filterSelect.innerHTML = `<option value="">全部教师</option>` +
    teachers.map(t => `<option value="${t[0]}">${t[1]}</option>`).join('');

  teacherSelect.onchange = loadOccupations;
  await loadOccupations(); // 初始化职业
}


async function loadOccupations() {
  const teacherId = document.getElementById('sel-teacher').value;
  if (!teacherId) return;
  const res = await fetch(`/api/schedules/occupations/${teacherId}`);
  const occupations = await res.json();
  const occSelect = document.getElementById('sel-occupation');
  occSelect.innerHTML = occupations.map(o =>
    `<option value="${o[0]}|${o[1]}">${o[0]} - ${o[1]}</option>`
  ).join('');
}

async function loadSchedules() {
  const res = await fetch('/api/schedules');
  const data = await res.json();
  const tbody = document.querySelector('#schedule-table tbody');
  tbody.innerHTML = '';
  data.forEach(row => {
    const [id, teacher_id, name, start, end, date, occupation, level] = row;
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${teacher_id}</td>
      <td>${name}</td>
      <td>${occupation || '暂无'}</td>
      <td>${level || '暂无'}</td>
      <td>${start}</td>
      <td>${end}</td>
      <td>${date}</td>
      <td>
        <button onclick="editRow('${id}', '${teacher_id}', '${date}', '${start}', '${end}', '${occupation}', '${level}')">修改</button>
        <button onclick="deleteRow(${id})">删除</button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

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

async function filterSchedules() {
  const teacher_id = document.getElementById('filter-teacher').value;
  const start = document.getElementById('filter-start').value;
  const end = document.getElementById('filter-end').value;

  let url = '/api/schedules?';
  if (teacher_id) url += `teacher_id=${teacher_id}&`;
  if (start) url += `start=${start}&`;
  if (end) url += `end=${end}`;

  const res = await fetch(url);
  const data = await res.json();
  renderScheduleTable(data);
}

function clearFilter() {
  document.getElementById('filter-teacher').value = '';
  document.getElementById('filter-start').value = '';
  document.getElementById('filter-end').value = '';
  loadSchedules();
}

function renderScheduleTable(data) {
  const tbody = document.querySelector('#schedule-table tbody');
  tbody.innerHTML = '';
  data.forEach(row => {
    const [id, teacher_id, name, start, end, date, occupation, level] = row;
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${teacher_id}</td>
      <td>${name}</td>
      <td>${occupation || '暂无'}</td>
      <td>${level || '暂无'}</td>
      <td>${start}</td>
      <td>${end}</td>
      <td>${date}</td>
      <td>
        <button onclick="editRow('${id}', '${teacher_id}', '${date}', '${start}', '${end}', '${occupation}', '${level}')">修改</button>
        <button onclick="deleteRow(${id})">删除</button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

function editRow(id, teacher_id, date, start, end, occupation, level) {
  const f = document.getElementById('schedule-form');
  f['sel-teacher'].value = teacher_id;
  f['work-date'].value = date;
  f['start-time'].value = start;
  f['end-time'].value = end;
  f.dataset.mode = 'edit';
  f.dataset.id = id;

  document.getElementById('submit-btn').textContent = '确认修改';
  document.getElementById('cancel-btn').style.display = 'inline-block';

  loadOccupations().then(() => {
    const occSelect = f['sel-occupation'];
    for (let opt of occSelect.options) {
      if (opt.value === `${occupation}|${level}`) {
        occSelect.value = opt.value;
        break;
      }
    }
  });

  // 高亮当前编辑行
  document.querySelectorAll('#schedule-table tbody tr').forEach(tr => {
    tr.classList.remove('editing');
  });
  const trs = document.querySelectorAll('#schedule-table tbody tr');
  for (const tr of trs) {
    if (tr.innerHTML.includes(`editRow('${id}'`)) {
      tr.classList.add('editing');
      break;
    }
  }
}

document.getElementById('cancel-btn').onclick = () => {
  const f = document.getElementById('schedule-form');
  f.reset();
  delete f.dataset.mode;
  delete f.dataset.id;

  document.getElementById('submit-btn').textContent = '登记';
  document.getElementById('cancel-btn').style.display = 'none';

  document.querySelectorAll('#schedule-table tbody tr').forEach(tr => {
    tr.classList.remove('editing');
  });
};

document.getElementById('schedule-form').onsubmit = async e => {
  e.preventDefault();
  const f = e.target;
  const mode = f.dataset.mode || 'add';
  const teacher_id = f['sel-teacher'].value;
  const [occupation_name, level] = f['sel-occupation'].value.split('|');
  const work_date = f['work-date'].value;
  const start_time = f['start-time'].value;
  const end_time = f['end-time'].value;
  const id = f.dataset.id;

  const url = mode === 'edit' ? '/api/schedules/update' : '/api/schedules';
  const body = { teacher_id, occupation_name, level, work_date, start_time, end_time };
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
    document.getElementById('submit-btn').textContent = '登记';
    document.getElementById('cancel-btn').style.display = 'none';
    document.querySelectorAll('#schedule-table tbody tr').forEach(tr => {
      tr.classList.remove('editing');
    });
    loadSchedules();
  } else {
    alert((mode === 'edit' ? '修改' : '登记') + '失败');
  }
};

loadOptions().then(loadSchedules);
