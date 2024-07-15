# ActuON
#### Video Demo: https://youtu.be/nDm6d9EYtOg
#### Description:

## What is this

ActuON is a productivity web app built for people who struggle with traditional task managers. The name combines the Latin word *actus* (action) with ON, like switching something on. The whole point is getting from "I have things to do" to actually doing one of them, without getting stuck in between.

It was built as my CS50x final project using Python, Flask, SQLite, Jinja2, HTML, CSS, and JavaScript.

## Why I built it

Most task apps show you everything at once. You open them, see 15 things, and close them again. That is not a task manager, that is just a list. For neurodivergent people especially, seeing everything at once creates paralysis instead of focus.

ActuON works differently. It picks the most important task and shows you that one. You work on it, mark it done, and then it shows you the next one. That is it.

Every feature in the app was designed around one question: does this make it easier to start, or harder?

## Features

### Login and Register

Users create an account to use the app. Passwords are hashed with `werkzeug.security` before going into the database, so plain text is never stored. Sessions are handled by Flask. Every page except login and register is protected by a `login_required` decorator that redirects unauthenticated users.

### Dashboard

The first page after login. Shows a greeting based on the time of day, three stats at the top (tasks done today, tasks remaining, total flow time), and one task in a focus card. That single task is always the highest priority one. There is a flow timer right there on the dashboard so you do not have to go anywhere to start tracking your work time. The next two tasks are shown below as a small queue.

### Tasks

This is where you manage everything. You can add a task with a name, priority level (high, medium, or low), and an optional due date. Tasks are automatically sorted by priority so you never have to drag and reorder anything. Within the same priority level, older tasks come first.

If a task is past its due date it turns red with an overdue warning. You can edit any task by hovering over it and clicking edit, which opens a small modal with the current details pre-filled. You can close the modal with Escape or by clicking outside it.

There is also a keyboard shortcut: press N anywhere in the app and it opens the add task form immediately. If you are on a different page it takes you to tasks and opens the form automatically. This was important to me because when you think of something, you want to write it down before you forget it, not navigate through four pages first.

### Focus Mode

A full screen page with nothing on it except one task and a timer. No navigation clutter, no sidebar, just the task and a start button.

The timer counts up, not down. I did not want a Pomodoro style countdown because when you are finally in flow the last thing you need is a bell telling you to stop. The timer here just tracks how long you have been working. You stop when you are done.

One technical thing about the timer: it keeps running even if you switch to a different page. It saves the start time to localStorage, so when you come back or go to the dashboard, it picks up from where it was. This took some work to get right because the normal way of doing timers in JavaScript stops as soon as you navigate away.

### Brain Dump

A text area with no rules. You type whatever is in your head, click save, and it stores it with a timestamp. The point is to get things out of your head and into somewhere safe so your brain stops holding onto them. There is a live word count while you type. Saved snapshots show up below the editor. Submitting an empty form shows an error instead of saving a blank entry.

### History

All your completed tasks grouped by date with the time you finished each one. Useful to look back at the end of the day when it feels like nothing got done.

### Flash Messages

Every action gives you feedback. Adding a task, completing one, saving a dump, deleting something: all of these show a small toast in the bottom right corner. It disappears after 3 seconds. You can also click it to close it early.

## Design decisions

I removed the habit tracker that was in my original design. It was going to add a lot of complexity for something that is not really about task execution. Same with an AI priority ranker I had planned. I replaced it with a simple sort: high first, then medium, then low, then by age. It is predictable and never confusing.

The app uses server side rendering with Flask and Jinja2 instead of a JavaScript framework. This made more sense for a CS50 project because it shows how HTTP, forms, sessions, and databases actually work together rather than hiding it behind a framework.

The color scheme is dark purple on near black. Dark backgrounds are easier on the eyes for long sessions and the purple just looked good.

## Project structure

```
actuon/
├── app.py
├── schema.sql
├── requirements.txt
└── templates/
    ├── layout.html
    ├── login.html
    ├── register.html
    ├── dashboard.html
    ├── tasks.html
    ├── focus.html
    ├── dump.html
    └── history.html
```

## How to run

```bash
pip install -r requirements.txt
python app.py
```

Then open `http://127.0.0.1:5000` in a browser. The database is created automatically on first run.

## Stack

Python, Flask, SQLite, Werkzeug, Jinja2, JavaScript, CSS, Google Fonts (Syne + JetBrains Mono)
