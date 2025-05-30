// subjects-good-at.js - Subjects Good At Page
const apiBase = 'http://localhost:3001';

async function fetchStudents() {
  const res = await fetch(`${apiBase}/students`);
  return res.json();
}

async function fetchSubjectsGoodAt(studentId) {
  const res = await fetch(`${apiBase}/subjects-good-at/${studentId}`);
  return res.json();
}

async function init() {
  const students = await fetchStudents();
  const studentSelect = document.getElementById('studentSelect');
  const subjectsDiv = document.getElementById('subjectsGoodAt');
  students.forEach(stu => {
    const opt = document.createElement('option');
    opt.value = stu.id;
    opt.textContent = stu.name;
    studentSelect.appendChild(opt);
  });
  async function updateSubjects() {
    const studentId = studentSelect.value;
    subjectsDiv.textContent = 'Loading...';
    const subjects = await fetchSubjectsGoodAt(studentId);
    if (subjects.length > 0) {
      subjectsDiv.innerHTML = '<ul class="list-disc pl-6">' +
        subjects.map(s => `<li><b>${s.subject_name}</b> (${s.current_level})</li>`).join('') +
        '</ul>';
    } else {
      subjectsDiv.textContent = 'No record found for this student.';
    }
  }
  studentSelect.onchange = updateSubjects;
  if (students.length > 0) {
    studentSelect.value = students[0].id;
    updateSubjects();
  }
}

window.onload = init;
