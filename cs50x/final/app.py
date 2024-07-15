import os
from flask import Flask, render_template, request, redirect, session, url_for, jsonify, flash
from werkzeug.security import generate_password_hash, check_password_hash
import sqlite3
from datetime import datetime
from functools import wraps

app = Flask(__name__)
app.secret_key = os.environ.get("SECRET_KEY", "actuon-dev-secret-change-in-production")

DB = "actuon.db"


# ──────────────────────────────────────────────
# DB HELPERS
# ──────────────────────────────────────────────

def get_db():
    db = sqlite3.connect(DB)
    db.row_factory = sqlite3.Row
    return db


def init_db():
    with get_db() as db:
        with open("schema.sql") as f:
            db.executescript(f.read())
        # Safe migration: add due_date column if it doesn't exist yet
        try:
            db.execute("ALTER TABLE tasks ADD COLUMN due_date TEXT DEFAULT NULL")
            db.commit()
        except Exception:
            pass  # Column already exists, that's fine


def login_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if "user_id" not in session:
            return redirect(url_for("login"))
        return f(*args, **kwargs)
    return decorated


# ──────────────────────────────────────────────
# AUTH ROUTES
# ──────────────────────────────────────────────

@app.route("/")
def index():
    if "user_id" not in session:
        return redirect(url_for("login"))
    return redirect(url_for("dashboard"))


@app.route("/login", methods=["GET", "POST"])
def login():
    error = None

    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")

        if not username or not password:
            error = "Fill in all fields."
        else:
            db = get_db()
            user = db.execute(
                "SELECT * FROM users WHERE username = ?", (username,)
            ).fetchone()
            db.close()

            if not user or not check_password_hash(user["password_hash"], password):
                error = "Invalid username or password."
            else:
                session.clear()
                session["user_id"] = user["id"]
                session["username"] = user["username"]
                return redirect(url_for("dashboard"))

    return render_template("login.html", error=error)


@app.route("/register", methods=["GET", "POST"])
def register():
    error = None

    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")
        confirm = request.form.get("confirm", "")

        if not username or not password or not confirm:
            error = "Fill in all fields."
        elif len(username) < 3:
            error = "Username must be at least 3 characters."
        elif len(password) < 6:
            error = "Password must be at least 6 characters."
        elif password != confirm:
            error = "Passwords do not match."
        else:
            db = get_db()
            existing = db.execute(
                "SELECT id FROM users WHERE username = ?", (username,)
            ).fetchone()

            if existing:
                error = "Username already taken."
                db.close()
            else:
                db.execute(
                    "INSERT INTO users (username, password_hash) VALUES (?, ?)",
                    (username, generate_password_hash(password))
                )
                db.commit()
                user = db.execute(
                    "SELECT * FROM users WHERE username = ?", (username,)
                ).fetchone()
                db.close()
                session.clear()
                session["user_id"] = user["id"]
                session["username"] = user["username"]
                return redirect(url_for("dashboard"))

    return render_template("register.html", error=error)


@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


# ──────────────────────────────────────────────
# DASHBOARD
# ──────────────────────────────────────────────

@app.route("/dashboard")
@login_required
def dashboard():
    db = get_db()
    user_id = session["user_id"]

    # Get tasks sorted by priority: high first, then med, then low
    priority_order = "CASE priority WHEN 'high' THEN 0 WHEN 'med' THEN 1 WHEN 'low' THEN 2 END"
    tasks = db.execute(
        f"SELECT * FROM tasks WHERE user_id = ? AND done = 0 ORDER BY {priority_order}, created_at ASC",
        (user_id,)
    ).fetchall()

    # Done today count
    done_today = db.execute(
        "SELECT COUNT(*) as count FROM history WHERE user_id = ? AND DATE(completed_at) = DATE('now')",
        (user_id,)
    ).fetchone()["count"]

    db.close()

    # Time greeting
    hour = datetime.now().hour
    if hour < 12:
        greeting = "morning"
    elif hour < 17:
        greeting = "afternoon"
    else:
        greeting = "evening"

    return render_template(
        "dashboard.html",
        tasks=tasks,
        done_today=done_today,
        greeting=greeting,
        username=session["username"]
    )


# ──────────────────────────────────────────────
# TASKS
# ──────────────────────────────────────────────

@app.route("/tasks", methods=["GET", "POST"])
@login_required
def tasks():
    db = get_db()
    user_id = session["user_id"]
    error = None

    if request.method == "POST":
        text = request.form.get("text", "").strip()
        priority = request.form.get("priority", "med")
        due_date = request.form.get("due_date", "").strip() or None

        if not text:
            error = "Task cannot be empty."
        elif priority not in ("high", "med", "low"):
            error = "Invalid priority."
        else:
            db.execute(
                "INSERT INTO tasks (user_id, text, priority, due_date) VALUES (?, ?, ?, ?)",
                (user_id, text, priority, due_date)
            )
            db.commit()
            flash("Task added ✓", "success")
            return redirect(url_for("tasks"))

    priority_order = "CASE priority WHEN 'high' THEN 0 WHEN 'med' THEN 1 WHEN 'low' THEN 2 END"
    all_tasks = db.execute(
        f"SELECT * FROM tasks WHERE user_id = ? AND done = 0 ORDER BY {priority_order}, created_at ASC",
        (user_id,)
    ).fetchall()
    db.close()

    return render_template("tasks.html", tasks=all_tasks, error=error, today=datetime.now().strftime("%Y-%m-%d"))


@app.route("/tasks/complete/<int:task_id>", methods=["POST"])
@login_required
def complete_task(task_id):
    db = get_db()
    user_id = session["user_id"]

    task = db.execute(
        "SELECT * FROM tasks WHERE id = ? AND user_id = ?", (task_id, user_id)
    ).fetchone()

    if task:
        db.execute("UPDATE tasks SET done = 1 WHERE id = ?", (task_id,))
        db.execute(
            "INSERT INTO history (user_id, task_text) VALUES (?, ?)",
            (user_id, task["text"])
        )
        db.commit()
        flash(f"✓ '{task['text'][:40]}' completed!", "success")

    db.close()
    return redirect(request.referrer or url_for("tasks"))


@app.route("/tasks/delete/<int:task_id>", methods=["POST"])
@login_required
def delete_task(task_id):
    db = get_db()
    db.execute(
        "DELETE FROM tasks WHERE id = ? AND user_id = ?",
        (task_id, session["user_id"])
    )
    db.commit()
    db.close()
    flash("Task deleted.", "info")
    return redirect(url_for("tasks"))


@app.route("/tasks/edit/<int:task_id>", methods=["POST"])
@login_required
def edit_task(task_id):
    db = get_db()
    text = request.form.get("text", "").strip()
    priority = request.form.get("priority", "med")
    due_date = request.form.get("due_date", "").strip() or None

    if text and priority in ("high", "med", "low"):
        db.execute(
            "UPDATE tasks SET text = ?, priority = ?, due_date = ? WHERE id = ? AND user_id = ?",
            (text, priority, due_date, task_id, session["user_id"])
        )
        db.commit()
        flash("Task updated ✓", "success")

    db.close()
    return redirect(url_for("tasks"))


# ──────────────────────────────────────────────
# FOCUS
# ──────────────────────────────────────────────

@app.route("/focus")
@login_required
def focus():
    db = get_db()
    user_id = session["user_id"]

    priority_order = "CASE priority WHEN 'high' THEN 0 WHEN 'med' THEN 1 WHEN 'low' THEN 2 END"
    tasks = db.execute(
        f"SELECT * FROM tasks WHERE user_id = ? AND done = 0 ORDER BY {priority_order}, created_at ASC",
        (user_id,)
    ).fetchall()
    db.close()

    current_task = tasks[0] if tasks else None
    return render_template("focus.html", current_task=current_task, tasks=tasks)


# ──────────────────────────────────────────────
# BRAIN DUMP
# ──────────────────────────────────────────────

@app.route("/dump", methods=["GET", "POST"])
@login_required
def dump():
    db = get_db()
    user_id = session["user_id"]

    if request.method == "POST":
        content = request.form.get("content", "").strip()
        if not content:
            flash("Can't save an empty dump.", "error")
        else:
            db.execute(
                "INSERT INTO dumps (user_id, content) VALUES (?, ?)",
                (user_id, content)
            )
            db.commit()
            flash("Snapshot saved ✓", "success")
        return redirect(url_for("dump"))

    dumps = db.execute(
        "SELECT * FROM dumps WHERE user_id = ? ORDER BY created_at DESC LIMIT 10",
        (user_id,)
    ).fetchall()
    db.close()

    return render_template("dump.html", dumps=dumps)


@app.route("/dump/delete/<int:dump_id>", methods=["POST"])
@login_required
def delete_dump(dump_id):
    db = get_db()
    db.execute(
        "DELETE FROM dumps WHERE id = ? AND user_id = ?",
        (dump_id, session["user_id"])
    )
    db.commit()
    db.close()
    return redirect(url_for("dump"))


# ──────────────────────────────────────────────
# HISTORY
# ──────────────────────────────────────────────

@app.route("/history")
@login_required
def history():
    db = get_db()
    user_id = session["user_id"]

    records = db.execute(
        """
        SELECT task_text,
               strftime('%H:%M', completed_at) as time,
               strftime('%Y-%m-%d', completed_at) as date,
               CASE
                   WHEN DATE(completed_at) = DATE('now') THEN 'Today'
                   WHEN DATE(completed_at) = DATE('now', '-1 day') THEN 'Yesterday'
                   ELSE strftime('%d %b %Y', completed_at)
               END as label
        FROM history
        WHERE user_id = ?
        ORDER BY completed_at DESC
        """,
        (user_id,)
    ).fetchall()
    db.close()

    # Group by label
    grouped = {}
    for r in records:
        if r["label"] not in grouped:
            grouped[r["label"]] = []
        grouped[r["label"]].append(r)

    return render_template("history.html", grouped=grouped)


# ──────────────────────────────────────────────
# RUN
# ──────────────────────────────────────────────

if __name__ == "__main__":
    init_db()
    app.run(debug=True)
