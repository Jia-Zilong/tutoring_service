async function loadTeachers() {
  const res = await fetch('/api/teachers');
  const teachers = await res.json();
  const select = document.getElementById('teacher-select');
  teachers.forEach(t => {
    const opt = document.createElement('option');
    opt.value = t[0]; // 教师ID
    opt.textContent = t[1]; // 教师名字
    select.appendChild(opt);
  });
}

async function showReport() {
  const start = document.getElementById('start-date').value;
  const end = document.getElementById('end-date').value;
  const teacher_id = document.getElementById('teacher-select').value;

  let url = `/api/reports/hours?start=${start}&end=${end}`;
  if (teacher_id) {
    url += `&teacher_id=${teacher_id}`;
  }

  const res = await fetch(url);
  const data = await res.json();
  const tbody = document.querySelector('#report-table tbody');
  tbody.innerHTML = '';

  data.forEach(r => {
    tbody.innerHTML += `
      <tr>
        <td>${r.TeacherID}</td>
        <td>${r.TeacherName}</td>
        <td>${r.Level || '暂无'}</td>
        <td>${r.Subject || '暂无'}</td>
        <td>${r.TotalHours}</td>
      </tr>`;
  });

}

async function loadOccupationStats() {
  const res = await fetch('/api/reports/occupation');
  const data = await res.json();

  const tbody = document.querySelector('#occupation-table tbody');
  tbody.innerHTML = '';

  data.forEach(item => {
    tbody.innerHTML += `
      <tr>
        <td>${item.Subject || '暂无'}</td>
        <td>${item.Level || '暂无'}</td>
        <td>${item.DemandCount}</td>
      </tr>`;
  });
}


document.addEventListener('DOMContentLoaded', () => {
  loadTeachers();
  const today = new Date().toISOString().slice(0, 10);
  document.getElementById('start-date').value = today;
  document.getElementById('end-date').value = today;
});
