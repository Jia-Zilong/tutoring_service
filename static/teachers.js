const form = document.getElementById('add-form');
const submitBtn = form.querySelector('button[type="submit"]');
const cancelBtn = document.getElementById('cancel-btn');
let currentEditId = null;

function isValidIdRange(id) {
  return /^[0-9]{4}$/.test(id) && id >= '0001' && id <= '9999';
}

function isValidPhone(phone) {
  return /^1\d{10}$/.test(phone);
}

const addHandler = async e => {
  e.preventDefault();

  const idVal = form.id.value.trim();
  const phoneVal = form.contact.value.trim();

  if (!isValidIdRange(idVal)) {
    alert('ID 必须是 0001-9999 的四位数字');
    return;
  }

  if (!isValidPhone(phoneVal)) {
    alert('请输入正确的电话号码');
    return;
  }

  const payload = {
    id: idVal,
    name: form.name.value.trim(),
    gender: form.gender.value,
    contact: phoneVal,
  };

  const res = await fetch('/api/teachers', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });

  const result = await res.json();
  if (!res.ok) {
    alert(result.error || '添加失败');
    return;
  }

  clearForm();
  loadTeachers();
};

form.onsubmit = addHandler;

function clearForm() {
  form.reset();
  form.id.disabled = false;
  submitBtn.textContent = '添加';
  currentEditId = null;
  form.onsubmit = addHandler;
  removeHighlight();
  cancelBtn.style.display = 'none';
}

function showUpdateForm(id, name, gender, contact) {
  highlightRow(id);
  form.id.value = id;
  form.name.value = name;
  form.gender.value = gender;
  form.contact.value = contact;
  submitBtn.textContent = '更新';
  currentEditId = id;
  form.id.disabled = false;
  cancelBtn.style.display = 'inline-block';

  cancelBtn.onclick = () => {
    clearForm();
  };

  form.onsubmit = async e => {
    e.preventDefault();

    const payload = {
      id: form.id.value.trim(),
      name: form.name.value.trim(),
      gender: form.gender.value,
      contact: form.contact.value.trim(),
    };

    if (!isValidIdRange(payload.id)) {
      alert('ID 必须是 0001-9999 的四位数字');
      return;
    }

    if (!isValidPhone(payload.contact)) {
      alert('请输入正确的11位电话号码');
      return;
    }

    const res = await fetch(`/api/teachers/${currentEditId}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    });

    const result = await res.json();
    if (!res.ok) {
      alert(result.error || '更新失败');
      return;
    }

    clearForm();
    loadTeachers();
  };
}

async function loadTeachers() {
  const res = await fetch('/api/teachers');
  const data = await res.json();
  const tbody = document.querySelector('#teacher-table tbody');
  tbody.innerHTML = '';

  data.forEach(t => {
    const idStr = t[0].toString().padStart(4, '0');

    tbody.innerHTML += `<tr>
      <td>${idStr}</td>
      <td>${t[1]}</td>
      <td>${t[2]}</td>
      <td>${t[3] || ''}</td>
      <td>
        <button onclick="deleteTeacher('${idStr}')">删除</button>
        <button onclick="showUpdateForm('${idStr}','${t[1]}','${t[2]}','${t[3] || ''}')">修改</button>
      </td>
    </tr>`;
  });
}

async function deleteTeacher(id) {
  await fetch(`/api/teachers/${id}`, { method: 'DELETE' });
  loadTeachers();
}

function highlightRow(id) {
  removeHighlight();
  document.querySelectorAll('#teacher-table tbody tr').forEach(row => {
    if (row.children[0].textContent === id) {
      row.classList.add('highlight-row');
    }
  });
}

function removeHighlight() {
  document.querySelectorAll('#teacher-table tbody tr').forEach(row => {
    row.classList.remove('highlight-row');
  });
}

loadTeachers();
