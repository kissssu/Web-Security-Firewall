#!/usr/bin/python3

from flask import Flask, render_template, request, redirect, url_for, session

app = Flask(__name__, template_folder='web-pages')
app.secret_key = 'secret_123'  # Replace with a strong secret key

# Sample user data (replace with proper database integration)
users = {
    'admin': {'password': 'admin123', 'role': 'admin'},
    'user1': {'password': 'user123', 'role': 'user'}
}

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if username in users and users[username]['password'] == password:
            session['username'] = username
            session['role'] = users[username]['role']
            return redirect(url_for('dashboard'))
        else:
            return render_template('login.html', error='Invalid username or password')
    return render_template('login.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        # Implement signup logic (e.g., add user to database)
        # ...
        return redirect(url_for('login'))
    return render_template('signup.html')

@app.route('/dashboard')
def dashboard():
    if 'username' in session:
        username = session['username']
        role = session['role']
        return render_template('dashboard.html', username=username, role=role)
    else:
        return redirect(url_for('login'))

@app.route('/logout')
def logout():
    session.pop('username', None)
    session.pop('role', None)
    return redirect(url_for('home'))

if __name__ == '__main__':
    app.run(debug=True)