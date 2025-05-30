// main.js - Placement Test Entry Page
const apiBase = 'http://localhost:3001';

async function fetchStudents() {
  const res = await fetch(`${apiBase}/students`);
  return res.json();
}

async function fetchSubjects() {
  const res = await fetch(`${apiBase}/subjects`);
  return res.json();
}

function renderSubjects(subjects) {
  const container = document.getElementById('subjectsContainer');
  container.innerHTML = '';
  subjects.forEach(subj => {
    const div = document.createElement('div');
    div.className = 'mb-2 flex items-center';
    div.innerHTML = `
      <label class="w-1/2">${subj.subject_name}</label>
      <input type="number" min="0" max="1" step="0.001" name="score_${subj.id}" class="w-1/2 border rounded p-1 ml-2" placeholder="Score (0-1)" required>
    `;
    container.appendChild(div);
  });
}

async function init() {
  const students = await fetchStudents();
  const subjects = await fetchSubjects();
  const studentSelect = document.getElementById('studentSelect');
  students.forEach(stu => {
    const opt = document.createElement('option');
    opt.value = stu.id;
    opt.textContent = stu.name;
    studentSelect.appendChild(opt);
  });
  renderSubjects(subjects);

  document.getElementById('placementForm').onsubmit = async (e) => {
    e.preventDefault();
    const student_id = studentSelect.value;
    const scores = subjects.map(subj => {
      const val = parseFloat(document.querySelector(`[name=score_${subj.id}]`).value);
      return { subject_id: subj.id, score: val };
    });
    const res = await fetch(`${apiBase}/placement-tests`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ student_id, scores })
    });
    const msg = document.getElementById('resultMsg');
    if (res.ok) {
      msg.textContent = 'Placement test submitted successfully!';
      msg.className = 'text-green-600 mt-4';
    } else {
      const err = await res.json();
      msg.textContent = 'Error: ' + (err.error || 'Submission failed');
      msg.className = 'text-red-600 mt-4';
    }
  };
}

window.onload = init;
