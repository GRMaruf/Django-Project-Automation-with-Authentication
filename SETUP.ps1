param (
    [string]$RootFolder = "Contact Management System",
    [string]$ProjectName = "core",
    [string]$AppName = "myApp",
    [string]$BasicModel = "Contacts",
    [string]$BasicModelLowerCase = "contacts",
    [string]$ProjectTitle = "Contact Management System"
)


# -----------------------------
# ERROR: If There is Any Error
# Run this command -> 
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# -----------------------------

# -----------------------------
# Step 1: Create root folder
# -----------------------------
Write-Host "Creating root folder..." -ForegroundColor Cyan
mkdir $RootFolder -ErrorAction SilentlyContinue
Set-Location $RootFolder

# -----------------------------
# Step 2: Setup virtual environment
# -----------------------------
Write-Host "Creating virtual environment..." -ForegroundColor Cyan
python -m venv .venv

Write-Host "Activating virtual environment..." -ForegroundColor Cyan
& "$PWD\.venv\Scripts\Activate.ps1"

Write-Host "Installing Django, Whitenoise & PILLOW..." -ForegroundColor Cyan
pip install django pillow whitenoise

# -----------------------------
# Step 3: Create Django project in outer folder
# -----------------------------
Write-Host "Creating Django project..." -ForegroundColor Cyan
django-admin startproject $ProjectName .

# -----------------------------
# Step 4: Adjust folder structure & create app
# -----------------------------
Write-Host "Creating app and static folder..." -ForegroundColor Cyan
mkdir static
python manage.py startapp $AppName

# -----------------------------
# Step 5: Create templates and static subfolders
# -----------------------------
Write-Host "Creating templates and static folders..." -ForegroundColor Cyan
"static\css","static\js","static\images","$AppName\templates\master","$AppName\templates\$AppName" | ForEach-Object { mkdir $_ }

# -----------------------------
# Step 6: Create basic templates
# -----------------------------
@"
{% load static %}
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>
      {% block title %}
        $ProjectTitle
      {% endblock %}
    </title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />

    <!-- Custom CSS -->
    <link rel="stylesheet" href="{% static 'css/base.css' %}" />
    <link rel="stylesheet" href="{% static 'css/messages.css' %}" />
  </head>

  <body>
    <!-- Navbar -->
    {% include 'master/nav.html' %}

    <!-- Main Content -->
    <main class="py-4">
      <div class="container">
        {% block content %}

        {% endblock %}
      </div>
    </main>

    <!-- Footer -->
    {% include 'master/footer.html' %}

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
"@ | Set-Content "$AppName\templates\master\base.html"

@"
<nav class="navbar navbar-expand-lg navbar-dark bg-success shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="/">$ProjectTitle</a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link active" href="/">Home</a>
        </li>

        {% if request.user.is_authenticated %}
          <li class="nav-item">
            <a class="nav-link" href="#">$BasicModel</a>
          </li>

          <li class="nav-item">
            <a class="nav-link" href="{% url 'signout' %}">Logout</a>
          </li>
        {% else %}
          <li class="nav-item">
            <a class="nav-link" href="{% url 'signin' %}">Login</a>
          </li>

          <li class="nav-item">
            <a class="nav-link" href="{% url 'signup' %}">Register</a>
          </li>
        {% endif %}
      </ul>

      <form class="d-flex" method="GET">
        <input class="form-control me-2" type="search" name="search" placeholder="Search recipes..." value="{{ request.GET.search }}" />

        <button class="btn btn-light" type="submit">Search</button>
      </form>
    </div>
  </div>
</nav>
"@ | Set-Content "$AppName\templates\master\nav.html"

@"
<footer class="bg-dark text-white mt-5">
  <div class="container py-3">
    <div class="row">
      <div class="col-md-6">
        <h5>$ProjectTitle</h5>
        <p class="mb-0">Practice Project using Django & Bootstrap 5</p>
      </div>

      <div class="col-md-6 text-md-end">
        <p class="mb-0">© 2026 All Rights Reserved</p>
      </div>
    </div>
  </div>
</footer>
"@ | Set-Content "$AppName\templates\master\footer.html"

@"
{% if messages %}
  {% for message in messages %}
    <div class="{{ message.tags }}_message">
      {% if message.tags == 'success' %}
        ✅
      {% elif message.tags == 'error' %}
        ❌
      {% elif message.tags == 'warning' %}
        ⚠️
      {% elif message.tags == 'info' %}
        ℹ️
      {% else %}
        📝
      {% endif %}

      {{ message }}
    </div>
  {% endfor %}
{% endif %}
"@ | Set-Content "$AppName\templates\master\messages.html"

@"
{% load static %}
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Sign In</title>

<!-- Custom CSS -->
<link rel="stylesheet" href="{% static 'css/messages.css' %}">
<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial, sans-serif;
}

body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:linear-gradient(135deg,#4f46e5,#7c3aed);
}

.container{
    background:#fff;
    padding:40px;
    width:350px;
    border-radius:15px;
    box-shadow:0 10px 25px rgba(0,0,0,.2);
}

h2{
    text-align:center;
    margin-bottom:20px;
}

input{
    width:100%;
    padding:12px;
    margin:10px 0;
    border:1px solid #ddd;
    border-radius:8px;
}

button{
    width:100%;
    padding:12px;
    background:#4f46e5;
    color:white;
    border:none;
    border-radius:8px;
    cursor:pointer;
}

button:hover{
    background:#4338ca;
}

p{
    text-align:center;
    margin-top:15px;
}

a{
    color:#4f46e5;
    text-decoration:none;
}
</style>
</head>
<body>

<div class="container">
    <h2>Sign In</h2>

    <form method="post">
        {% csrf_token %}
        {% include 'master/messages.html' %}
        <input type="text" name="username" placeholder="username" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit">Sign In</button>
    </form>

    <p>
        Don't have an account?
        <a href="{% url 'signup' %}">Sign Up</a>
    </p>
</div>
"@ | Set-Content "$AppName\templates\master\signin.html"

@"
{% load static %}
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign Up</title>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="{% static 'css/messages.css' %}">

    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: Arial, sans-serif;
      }
      
      body {
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        background: linear-gradient(135deg, #7c3aed, #4f46e5);
      }
      
      .container {
        background: #fff;
        padding: 40px;
        width: 350px;
        border-radius: 15px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
      }
      
      h2 {
        text-align: center;
        margin-bottom: 20px;
      }
      
      input {
        width: 100%;
        padding: 12px;
        margin: 10px 0;
        border: 1px solid #ddd;
        border-radius: 8px;
      }
      
      .phone-group {
        display: flex;
        align-items: center;
        border: 1px solid #ddd;
        border-radius: 8px;
        margin: 10px 0;
        overflow: hidden;
      }
      
      .phone-group span {
        background: #f5f5f5;
        padding: 12px;
        border-right: 1px solid #ddd;
        color: #555;
        font-weight: bold;
      }
      
      .phone-group input {
        border: none;
        margin: 0;
        width: 100%;
        outline: none;
      }
      
      button {
        width: 100%;
        padding: 12px;
        background: #4f46e5;
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
      }
      
      button:hover {
        background: #4338ca;
      }
      
      p {
        text-align: center;
        margin-top: 15px;
      }
      
      a {
        color: #4f46e5;
        text-decoration: none;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h2>Create Account</h2>

      <form method="post">
        {% csrf_token %}
        {% include 'master/messages.html' %}
        <input type="text" name="username" placeholder="Username" required />
        <input type="password" name="password" placeholder="Password" required />
        <input type="password" name="password2" placeholder="Confirm Password" required />

        <button type="submit">Sign Up</button>
      </form>

      <p>
        Already have an account?
        <a href="{% url 'signin' %}">Sign In</a>
      </p>
    </div>
  </body>
</html>
"@ | Set-Content "$AppName\templates\master\signup.html"

@"
{% extends 'master/base.html' %}

{% block title %}
  Home | $ProjectTitle
{% endblock %}

{% block content %}
<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-xl-9 col-lg-10">

      <div class="card border-0 shadow-lg rounded-4">
        <div class="card-body p-5 text-center">

          <div class="mb-4">
            <i class="bi bi-kanban-fill text-success display-2"></i>
          </div>

          <h1 class="display-5 fw-bold mb-3">
            Welcome to <span class="d-block text-success">$ProjectTitle</span>
          </h1>

          {% include 'master/messages.html' %}

          <p class="lead text-muted mx-auto mb-5" style="max-width: 700px;">
            Organize your work efficiently by creating, updating, and managing
            $BasicModelLowerCase from one simple and user-friendly dashboard.
          </p>

          <div class="row g-4 mb-5">
            <div class="col-md-4">
              <div class="border rounded-3 p-4 h-100">
                <i class="bi bi-list-check fs-1 text-success"></i>
                <h5 class="mt-3">Manage $BasicModel</h5>
                <p class="text-muted mb-0">
                  Create, edit and organize your $BasicModelLowerCase with ease.
                </p>
              </div>
            </div>

            <div class="col-md-4">
              <div class="border rounded-3 p-4 h-100">
                <i class="bi bi-lightning-charge-fill fs-1 text-warning"></i>
                <h5 class="mt-3">Stay Productive</h5>
                <p class="text-muted mb-0">
                  Keep everything organized in one central place.
                </p>
              </div>
            </div>

            <div class="col-md-4">
              <div class="border rounded-3 p-4 h-100">
                <i class="bi bi-shield-check fs-1 text-primary"></i>
                <h5 class="mt-3">Secure Access</h5>
                <p class="text-muted mb-0">
                  Access your data safely with authenticated accounts.
                </p>
              </div>
            </div>
          </div>

          <div class="d-flex justify-content-center gap-3 flex-wrap">
            <a href="#" class="btn btn-success btn-lg px-4">
              <i class="bi bi-list me-2"></i>View All $BasicModel
            </a>

            <a href="{% url 'signout' %}" class="btn btn-outline-danger btn-lg px-4">
              <i class="bi bi-box-arrow-right me-2"></i>Logout
            </a>
          </div>

        </div>
      </div>

    </div>
  </div>
</div>
{% endblock %}
"@ | Set-Content "$AppName\templates\$AppName\index.html"

# -----------------------------
# Step 9: Create simple CSS
# -----------------------------
@"
body {
    background: #f8f9fa;
}

.navbar {
    box-shadow: 0 2px 8px rgba(0, 0, 0, .08);
}

.card {
    border: none;
    border-radius: 15px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, .08);
}

.btn {
    border-radius: 10px;
}

.table {
    background: white;
}

.form-control {
    border-radius: 10px;
}

.form-select {
    border-radius: 10px;
}
"@ | Set-Content "static\css\base.css"

@"
.success_message,
.error_message,
.warning_message,
.info_message,
.debug_message{

    display:block;
    width:100%;
    padding:14px 18px;
    margin:15px 0;
    border-radius:8px;
    font-size:16px;
    font-weight:500;
    border-left:6px solid;
    box-shadow:0 3px 8px rgba(0,0,0,.08);

}

/* Success */

.success_message{

    color:#0f5132;
    background:#d1e7dd;
    border-color:#198754;

}

/* Error */

.error_message{

    color:#842029;
    background:#f8d7da;
    border-color:#dc3545;

}

/* Warning */

.warning_message{

    color:#664d03;
    background:#fff3cd;
    border-color:#ffc107;

}

/* Info */

.info_message{

    color:#055160;
    background:#cff4fc;
    border-color:#0dcaf0;

}

/* Debug */

.debug_message{

    color:#41464b;
    background:#e2e3e5;
    border-color:#6c757d;

}
"@ | Set-Content "static\css\messages.css"

# -----------------------------
# Step 10: Update settings.py
# -----------------------------
Write-Host "Updating settings.py..." -ForegroundColor Cyan
$settingsPath = "$ProjectName\settings.py"

# Add app to INSTALLED_APPS
(Get-Content $settingsPath) -replace "INSTALLED_APPS = \[", "INSTALLED_APPS = [`n    '$AppName'," | Set-Content $settingsPath
(Get-Content $settingsPath) -replace "'django.contrib.staticfiles',", "'whitenoise.runserver_nostatic',`n    'django.contrib.staticfiles'," | Set-Content $settingsPath

# Add app to MIDDLEWARE
(Get-Content $settingsPath) -replace "'django.middleware.security.SecurityMiddleware',", "'django.middleware.security.SecurityMiddleware',`n    'whitenoise.middleware.WhiteNoiseMiddleware'," | Set-Content $settingsPath

# Add templates DIRS
# $settingsContent = Get-Content $settingsPath
# if ($settingsContent -notmatch "DIRS") {
#    (Get-Content $settingsPath) -replace "'DIRS': \[\]", "'DIRS': [BASE_DIR / '$AppName' / 'templates']" | Set-Content $settingsPath
#}

# Add STATICFILES_DIRS
$settingsContent = Get-Content $settingsPath
if ($settingsContent -notmatch "STATIC_ROOT") {
    Add-Content $settingsPath "STATIC_ROOT = BASE_DIR / 'staticfiles/'"
}
if ($settingsContent -notmatch "STATICFILES_DIRS") {
    Add-Content $settingsPath "STATICFILES_DIRS = [ BASE_DIR / 'static' ]"
}
if ($settingsContent -notmatch "STATICFILES_STORAGE") {
    Add-Content $settingsPath "STATICFILES_STORAGE = `"whitenoise.storage.CompressedManifestStaticFilesStorage`""
}
if ($settingsContent -notmatch "MEDIA_URL") {
    Add-Content $settingsPath "MEDIA_URL = 'media/'"
}
if ($settingsContent -notmatch "MEDIA_ROOT") {
    Add-Content $settingsPath "MEDIA_ROOT = BASE_DIR / 'media/'"
}
if ($settingsContent -notmatch "LOGIN_URL") {
    Add-Content $settingsPath "LOGIN_URL = 'signin'"
}

# -----------------------------
# Step 11: Update urls.py
# -----------------------------
Write-Host "Updating urls.py..." -ForegroundColor Cyan
$urlsPath = "$ProjectName\urls.py"

@"
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from myApp.views import home

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('myApp.urls')),
    path('', home, name='home'),
]

# Serve static and media files during development
if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
"@ | Set-Content $urlsPath

# -----------------------------
# Step 12: Create models, views and urls for Home page and authentication
# -----------------------------
Write-Host "Creating models..." -ForegroundColor Cyan
@"
from django.db import models
from django.contrib.auth.models import User
"@ | Set-Content "$AppName\models.py"

Write-Host "Creating views..." -ForegroundColor Cyan
@"
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from myApp.models import *

@login_required
def home(request):
    return render(request, 'myApp/index.html')

def signup(request):
    if request.method == "POST":
        username = request.POST.get('username')
        password = request.POST.get('password')
        password2 = request.POST.get('password2')
        
        if User.objects.filter(username=username).exists():
            messages.warning(request, 'This username already exists.')
            return redirect('signup')

        if password != password2:
            messages.warning(request, 'Two passwords must be same.')
            return redirect('signup')
        
        User.objects.create_user(
            username = username,
            password = password
        )
        messages.success(request, 'Registered successfully.')
        return redirect('signin')
    return render(request, 'master/signup.html')

def signin(request):
    if request.method == "POST":
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        user = authenticate(username=username, password=password)
        if user is None:
            messages.warning(request, 'Invalid credentials.')
            return redirect('signin')

        login(request, user)
        messages.success(request, 'Logged in successfully.')
        return redirect('home')
    return render(request, 'master/signin.html')

@login_required
def signout(request):
    logout(request)
    messages.success(request, 'Logged out successfully.')
    return redirect('signin')
    
"@ | Set-Content "$AppName\views.py"

Write-Host "Creating urls..." -ForegroundColor Cyan
@"
from django.urls import path
from myApp.views import *

urlpatterns = [
    path('signup/', signup, name='signup'),
    path('signin/', signin, name='signin'),
    path('signout/', signout, name='signout'),
]
"@ | Set-Content "$AppName\urls.py"

# -----------------------------
# Step 13: Initial migrate
# -----------------------------
Write-Host "Running migrations..." -ForegroundColor Cyan
python manage.py migrate

# -----------------------------
# Step 14: Create .gitignore
# -----------------------------
@"
.venv/
__pycache__/
*.pyc
db.sqlite3
.env
"@ | Set-Content .gitignore

# -----------------------------
# Step 15: Save requirements
# -----------------------------
pip freeze > requirements.txt

# -----------------------------
# Step 16: Create superuser
# -----------------------------
Write-Host "Creating Django superuser..." -ForegroundColor Cyan

$superuserScript = @"
import os
import django
from django.contrib.auth import get_user_model

os.environ.setdefault('DJANGO_SETTINGS_MODULE', '$ProjectName.settings')
django.setup()

User = get_user_model()

if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', '1234')
    print('Superuser created: username=admin, password=1234')
else:
    print('Superuser already exists')
"@

$superuserScript | Set-Content "create_superuser.py"
python create_superuser.py
Remove-Item "create_superuser.py"

# -----------------------------
# Step 17: Run server
# -----------------------------
Write-Host "`n[DONE] Basic Django project setup complete!" -ForegroundColor Green
Start-Process "http://127.0.0.1:8000/"
python manage.py runserver
