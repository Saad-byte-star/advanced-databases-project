// recommendations.js - Recommendations Page
const apiBase = 'http://localhost:3001';

async function fetchStudents() {
  const res = await fetch(`${apiBase}/students`);
  return res.json();
}

async function fetchRecommendation(studentId) {
  const res = await fetch(`${apiBase}/recommendations/${studentId}`);
  if (!res.ok) return null;
  return res.json();
}

async function init() {
  const students = await fetchStudents();
  const studentSelect = document.getElementById('studentSelect');
  const reportDiv = document.getElementById('recommendationReport');
  students.forEach(stu => {
    const opt = document.createElement('option');
    opt.value = stu.id;
    opt.textContent = stu.name;
    studentSelect.appendChild(opt);
  });
  async function updateReport() {
    const studentId = studentSelect.value;
    reportDiv.textContent = 'Loading...';
    const rec = await fetchRecommendation(studentId);
    if (rec && rec.report) {
      reportDiv.textContent = rec.report;
    } else {
      reportDiv.textContent = 'No recommendation found for this student.';
    }
  }
  studentSelect.onchange = updateReport;
  if (students.length > 0) {
    studentSelect.value = students[0].id;
    updateReport();
  }
}

window.onload = init;
