# =========================================================
# MEDIAPP - IMPROVED FULL BACKEND
# Flask + SQL Server (MSSQL)
# =========================================================

import os
import re
import time
import smtplib
import logging
import hashlib
import secrets
import pyodbc

from functools import wraps
from datetime import datetime, timedelta

from dotenv import load_dotenv

from flask import (
    Flask,
    render_template,
    request,
    redirect,
    url_for,
    jsonify,
    session,
    flash
)

from flask_talisman import Talisman
from flask_wtf.csrf import CSRFProtect

from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

from werkzeug.security import (
    generate_password_hash,
    check_password_hash
)

from email_validator import (
    validate_email,
    EmailNotValidError
)

from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# =========================================================
# LOAD ENVIRONMENT VARIABLES
# =========================================================

load_dotenv()

# =========================================================
# FLASK APP
# =========================================================

app = Flask(__name__)

app.secret_key = os.getenv("SECRET_KEY")

# =========================================================
# LOGGING
# =========================================================

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

# =========================================================
# SECURITY
# =========================================================

csrf = CSRFProtect(app)

ENV = os.getenv("ENV", "development").lower()

if ENV == "production":

    Talisman(
        app,
        force_https=True,
        strict_transport_security=True,
        session_cookie_secure=True,
        frame_options="DENY",
        referrer_policy="strict-origin-when-cross-origin"
    )

# =========================================================
# COOKIE SETTINGS
# =========================================================

app.config.update(

    SESSION_COOKIE_NAME="mediapp_session",

    SESSION_COOKIE_HTTPONLY=True,

    SESSION_COOKIE_SAMESITE="Lax",

    SESSION_COOKIE_SECURE=(ENV == "production"),

    REMEMBER_COOKIE_SECURE=(ENV == "production"),

    REMEMBER_COOKIE_HTTPONLY=True,

    REMEMBER_COOKIE_SAMESITE="Lax"
)

# =========================================================
# SESSION TIMEOUT
# =========================================================

app.permanent_session_lifetime = timedelta(minutes=30)

# =========================================================
# RATE LIMITER
# =========================================================

limiter = Limiter(
    key_func=get_remote_address,
    app=app,
    default_limits=["200 per day", "50 per hour"]
)

# =========================================================
# DATABASE CONNECTION
# =========================================================

pyodbc.pooling = True

def get_db_connection():

    driver = os.getenv("DB_DRIVER")
    server = os.getenv("DB_SERVER")
    database = os.getenv("DB_NAME")
    username = os.getenv("DB_USERNAME")
    password = os.getenv("DB_PASSWORD")

    try:

        conn = pyodbc.connect(
            f"DRIVER={{{driver}}};"
            f"SERVER={server};"
            f"DATABASE={database};"
            f"UID={username};"
            f"PWD={password};"
            f"Encrypt=yes;"
            f"TrustServerCertificate=yes;",
            timeout=5
        )

        return conn

    except Exception as e:

        logging.error(f"Database connection error: {e}")

        raise

# =========================================================
# HELPER FUNCTIONS
# =========================================================

def clean_input(value):

    if value is None:
        return None

    value = value.strip()

    return value if value else None

def check_length(value, max_length):

    if value is None:
        return False

    return len(value) <= max_length

def is_valid_email(email):

    if not email:
        return False, None

    try:

        result = validate_email(email)

        return True, result.email

    except EmailNotValidError:

        return False, None

def password_validation(password):

    if len(password) < 8:
        return False, "Password must be at least 8 characters"

    if not re.search(r"[A-Z]", password):
        return False, "Must contain uppercase letter"

    if not re.search(r"[a-z]", password):
        return False, "Must contain lowercase letter"

    if not re.search(r"[0-9]", password):
        return False, "Must contain number"

    if not re.search(r"[!@#$%^&*(),.?\":{}|<>]", password):
        return False, "Must contain special character"

    return True, "Strong password"

# =========================================================
# ROLE REQUIRED DECORATOR
# =========================================================

def role_required(role):

    def wrapper(f):

        @wraps(f)
        def decorated_function(*args, **kwargs):

            if "user_id" not in session:

                flash("Please log in first.")

                return redirect(url_for("home"))

            if session.get("role") != role:

                return jsonify({
                    "message": "Unauthorized"
                }), 403

            return f(*args, **kwargs)

        return decorated_function

    return wrapper

# =========================================================
# HOME PAGE
# =========================================================

@app.route("/")
@app.route("/home")
def home():

    return render_template(
        "first_page.html",
        page_title="MediApp"
    )

# =========================================================
# LOGIN
# =========================================================

@app.route("/login", methods=["POST"])
@limiter.limit("5 per minute")
def login():

    session.clear()

    session.permanent = True

    username = clean_input(
        request.form.get("username")
    )

    password = request.form.get("password")

    role = clean_input(
        request.form.get("role")
    )

    if not username or not password or not role:

        return jsonify({
            "message": "Missing credentials"
        }), 400

    if not check_length(username, 50):

        return jsonify({
            "message": "Invalid username"
        }), 400

    if role not in ["staff", "patient"]:

        return jsonify({
            "message": "Invalid role"
        }), 400

    password = password.strip()

    try:

        with get_db_connection() as conn:

            cursor = conn.cursor()

            cursor.execute("""
                SELECT
                    Users_ID,
                    Role,
                    Username,
                    PasswordHash,
                    Failed_Attempts,
                    Lockout_Until
                FROM USERS
                WHERE Username = ?
                AND Role = ?
            """, (username, role))

            user = cursor.fetchone()

            if not user:

                time.sleep(0.5)

                return jsonify({
                    "message": "Invalid credentials"
                }), 401

            user_id = user[0]
            db_role = user[1]
            stored_hash = user[3]
            failed_attempts = user[4]
            lockout_until = user[5]

            # =============================================
            # LOCKOUT CHECK
            # =============================================

            if lockout_until and lockout_until > datetime.now():

                return jsonify({
                    "message": "Account temporarily locked"
                }), 403

            # =============================================
            # PASSWORD CHECK
            # =============================================

            if not check_password_hash(
                stored_hash,
                password
            ):

                if failed_attempts + 1 >= 5:

                    cursor.execute("""
                        UPDATE USERS
                        SET
                            Failed_Attempts = Failed_Attempts + 1,
                            Lockout_Until = ?
                        WHERE Users_ID = ?
                    """, (
                        datetime.now() + timedelta(minutes=1),
                        user_id
                    ))

                else:

                    cursor.execute("""
                        UPDATE USERS
                        SET Failed_Attempts =
                        Failed_Attempts + 1
                        WHERE Users_ID = ?
                    """, (user_id,))

                conn.commit()

                return jsonify({
                    "message": "Invalid credentials"
                }), 401

            # =============================================
            # RESET FAILED ATTEMPTS
            # =============================================

            cursor.execute("""
                UPDATE USERS
                SET
                    Failed_Attempts = 0,
                    Lockout_Until = NULL
                WHERE Users_ID = ?
            """, (user_id,))

            conn.commit()

            # =============================================
            # SESSION
            # =============================================

            session["user_id"] = user_id
            session["username"] = username
            session["role"] = db_role

            logging.info(f"Login success: {username}")

            if db_role == "staff":

                return redirect(
                    url_for("staff_dashboard")
                )

            return redirect(
                url_for("patient_dashboard")
            )

    except Exception as e:

        logging.error(f"Login error: {e}")

        return jsonify({
            "message": "Internal server error"
        }), 500

# =========================================================
# CREATE USER
# =========================================================

@app.route("/create_user", methods=["POST"])
@limiter.limit("3 per minute")
def create_user():

    username = clean_input(
        request.form.get("username")
    )

    password = request.form.get("password")

    email_raw = request.form.get("email")

    role = clean_input(
        request.form.get("role")
    )

    staff_code = request.form.get("staff_code")

    if not username or not password \
    or not email_raw or not role:

        return jsonify({
            "message": "Missing credentials"
        }), 400

    if not check_length(username, 50):

        return jsonify({
            "message": "Username too long"
        }), 400

    # =============================================
    # EMAIL VALIDATION
    # =============================================

    email_input = clean_input(email_raw)

    valid_email, email = is_valid_email(
        email_input
    )

    if not valid_email:

        return jsonify({
            "message": "Invalid email"
        }), 400

    # =============================================
    # ROLE VALIDATION
    # =============================================

    if role not in ["staff", "patient"]:

        return jsonify({
            "message": "Invalid role"
        }), 400

    # =============================================
    # PASSWORD VALIDATION
    # =============================================

    valid_password, validation_message = \
        password_validation(password)

    if not valid_password:

        return jsonify({
            "message": validation_message
        }), 400

    # =============================================
    # STAFF SECRET CODE
    # =============================================

    if role == "staff":

        secret_code = os.getenv(
            "STAFF_SECRET_CODE"
        )

        if staff_code != secret_code:

            return jsonify({
                "message": "Invalid staff code"
            }), 401

    # =============================================
    # HASH PASSWORD
    # =============================================

    password_hash = generate_password_hash(
        password
    )

    try:

        with get_db_connection() as conn:

            cursor = conn.cursor()

            cursor.execute("""
                SELECT Users_ID
                FROM USERS
                WHERE Username = ?
                OR Email = ?
            """, (
                username,
                email
            ))

            existing_user = cursor.fetchone()

            if existing_user:

                return jsonify({
                    "message":
                    "User already exists"
                }), 409

            cursor.execute("""
                INSERT INTO USERS
                (
                    Role,
                    Username,
                    PasswordHash,
                    Email
                )
                VALUES (?, ?, ?, ?)
            """, (
                role,
                username,
                password_hash,
                email
            ))

            conn.commit()

            logging.info(
                f"User created: {username}"
            )

            return jsonify({
                "message":
                "User created successfully"
            }), 201

    except Exception as e:

        logging.error(f"Create user error: {e}")

        return jsonify({
            "message":
            "Internal server error"
        }), 500

# =========================================================
# PASSWORD RESET EMAIL
# =========================================================

def send_reset_email(to_email, token):

    reset_link = (
        f"{os.getenv('BASE_URL')}"
        f"/reset_password?token={token}"
    )

    subject = "Password Reset"

    body = f"""
Hello,

We received a request to reset your password.

Click the link below:

{reset_link}

This link expires in 15 minutes.

If you did not request this,
please ignore this email.

MediApp Team
"""

    msg = MIMEMultipart()

    msg["From"] = os.getenv("EMAIL_SENDER")
    msg["To"] = to_email
    msg["Subject"] = subject

    msg.attach(MIMEText(body, "plain"))

    try:

        with smtplib.SMTP(
            os.getenv("SMTP_SERVER"),
            int(os.getenv("SMTP_PORT")),
            timeout=10
        ) as server:

            server.starttls()

            server.login(
                os.getenv("SMTP_USERNAME"),
                os.getenv("SMTP_PASSWORD")
            )

            server.send_message(msg)

        logging.info("Reset email sent")

    except Exception as e:

        logging.error(f"Email error: {e}")

# =========================================================
# CLEAN TOKENS
# =========================================================

def cleanup_expired_tokens():

    try:

        with get_db_connection() as conn:

            cursor = conn.cursor()

            cursor.execute("""
                DELETE FROM password_reset_tokens
                WHERE expires_at < GETDATE()
            """)

            conn.commit()

    except Exception as e:

        logging.error(f"Cleanup error: {e}")

# =========================================================
# REQUEST PASSWORD RESET
# =========================================================

@app.route("/request_password_reset", methods=["POST"])
@limiter.limit("3 per minute")
def request_password_reset():

    username = clean_input(
        request.form.get("username")
    )

    if not username:

        return jsonify({
            "message": "Invalid username"
        }), 400

    try:

        with get_db_connection() as conn:

            cursor = conn.cursor()

            cursor.execute("""
                SELECT Users_ID, Email
                FROM USERS
                WHERE Username = ?
            """, (username,))

            user = cursor.fetchone()

            if not user:

                time.sleep(0.5)

                return jsonify({
                    "message":
                    "If user exists, email sent"
                }), 200

            user_id = user[0]
            email = user[1]

            token = secrets.token_urlsafe(32)

            token_hash = hashlib.sha256(
                token.encode()
            ).hexdigest()

            expires_at = (
                datetime.now() +
                timedelta(minutes=15)
            )

            cursor.execute("""
                INSERT INTO
                password_reset_tokens
                (
                    users_id,
                    token,
                    expires_at,
                    used
                )
                VALUES (?, ?, ?, 0)
            """, (
                user_id,
                token_hash,
                expires_at
            ))

            conn.commit()

            cleanup_expired_tokens()

            send_reset_email(email, token)

            return jsonify({
                "message":
                "If user exists, email sent"
            }), 200

    except Exception as e:

        logging.error(
            f"Password reset request error: {e}"
        )

        return jsonify({
            "message":
            "Internal server error"
        }), 500

# =========================================================
# RESET PASSWORD PAGE
# =========================================================

@app.route("/reset_password", methods=["GET"])
def reset_password_page():

    token = request.args.get("token")

    if not token:

        return jsonify({
            "message": "Missing token"
        }), 400

    token_hash = hashlib.sha256(
        token.encode()
    ).hexdigest()

    try:

        with get_db_connection() as conn:

            cursor = conn.cursor()

            cursor.execute("""
                SELECT users_id
                FROM password_reset_tokens
                WHERE token = ?
                AND used = 0
                AND expires_at > GETDATE()
            """, (token_hash,))

            row = cursor.fetchone()

            if not row:

                return jsonify({
                    "message":
                    "Invalid or expired token"
                }), 400

            return render_template(
                "reset_password.html",
                token=token
            )

    except Exception as e:

        logging.error(f"Token error: {e}")

        return jsonify({
            "message":
            "Internal server error"
        }), 500

# =========================================================
# PROCESS RESET PASSWORD
# =========================================================

@app.route("/reset_password", methods=["POST"])
@limiter.limit("3 per minute")
def process_reset_password():

    token = request.form.get("token")

    new_password = request.form.get(
        "new_password"
    )

    confirm_password = request.form.get(
        "confirm_password"
    )

    if not token:

        return jsonify({
            "message": "Missing token"
        }), 400

    if not new_password or not confirm_password:

        return jsonify({
            "message":
            "Missing password fields"
        }), 400

    if new_password != confirm_password:

        return jsonify({
            "message":
            "Passwords do not match"
        }), 400

    valid, msg = password_validation(
        new_password
    )

    if not valid:

        return jsonify({
            "message": msg
        }), 400

    token_hash = hashlib.sha256(
        token.encode()
    ).hexdigest()

    try:

        with get_db_connection() as conn:

            cursor = conn.cursor()

            cursor.execute("""
                SELECT users_id
                FROM password_reset_tokens
                WHERE token = ?
                AND used = 0
                AND expires_at > GETDATE()
            """, (token_hash,))

            row = cursor.fetchone()

            if not row:

                return jsonify({
                    "message":
                    "Invalid or expired token"
                }), 400

            user_id = row[0]

            new_hash = generate_password_hash(
                new_password
            )

            cursor.execute("""
                UPDATE USERS
                SET PasswordHash = ?
                WHERE Users_ID = ?
            """, (
                new_hash,
                user_id
            ))

            cursor.execute("""
                UPDATE password_reset_tokens
                SET used = 1
                WHERE token = ?
            """, (token_hash,))

            conn.commit()

            return redirect(
                url_for("home") +
                "?reset=success"
            )

    except Exception as e:

        logging.error(f"Reset error: {e}")

        return jsonify({
            "message":
            "Internal server error"
        }), 500

# =========================================================
# STAFF DASHBOARD
# =========================================================

@app.route("/staff-dashboard")
@role_required("staff")
def staff_dashboard():

    return render_template(
        "staff_dashboard.html",
        username=session.get("username")
    )

# =========================================================
# PATIENT DASHBOARD
# =========================================================

@app.route("/patient-dashboard")
@role_required("patient")
def patient_dashboard():

    return render_template(
        "patient_dashboard.html",
        username=session.get("username")
    )

# =========================================================
# BOOKINGS PAGE
# =========================================================

@app.route("/bookings")
@role_required("patient")
def bookings():

    return render_template("bookings.html")

# =========================================================
# PAYMENT HISTORY
# =========================================================

@app.route("/payments")
@role_required("patient")
def payments_page():

    return render_template("payments.html")

# =========================================================
# LOGOUT
# =========================================================

@app.route("/logout", methods=["POST"])
def logout():

    session.clear()

    return redirect(url_for("home"))

# =========================================================
# RUN APP
# =========================================================

if __name__ == "__main__":

    app.run(debug=True)