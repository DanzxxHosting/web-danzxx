document.getElementById('loginForm')?.addEventListener('submit', function (e) {
  e.preventDefault();
  // Simulasi login
  const email = document.getElementById('email').value;
  const password = document.getElementById('password').value;

  if (email === "admin@danzxx.com" && password === "123456") {
    alert("Login berhasil!");
    window.location.href = "index.html";
  } else {
    alert("Email atau password salah!");
  }
});

document.getElementById('signupForm')?.addEventListener('submit', function (e) {
  e.preventDefault();
  alert("Registrasi berhasil! Silakan login.");
  window.location.href = "login.html";
});

function searchProduct() {
  const searchValue = document.getElementById('searchBar').value.toLowerCase();
  const products = document.querySelectorAll('.product-card');

  products.forEach((product) => {
    const productName = product.querySelector('h3').innerText.toLowerCase();
    if (productName.includes(searchValue)) {
      product.style.display = 'block';
    } else {
      product.style.display = 'none';
    }
  });
}