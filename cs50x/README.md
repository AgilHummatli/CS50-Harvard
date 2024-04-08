# CS50x — Introduction to Computer Science

**Harvard University / CS50x: Introduction to Computer Science**
10 problem sets · 1 final project · Certificate awarded 2026

> "This is CS50."

---

## What This Course Is

Harvard's flagship CS course, taken by millions worldwide. Started in 2023, completed in 2026. CS50x is not a gentle introduction — it starts in C, forces you to manage memory manually, and makes you understand what's happening at the hardware level before letting you use higher-level abstractions.

The course then moves to Python, SQL, and web development (HTML/CSS/JavaScript/Flask), ending with an open-ended final project where you build whatever you want.

The unofficial motto: "What ultimately matters in this course is not so much where you end up relative to your classmates but where you end up relative to yourself when you began."

---

## Course Structure

| Week | Language | Topic | Problem Set |
|------|----------|-------|------------|
| 0 | Scratch | Computational Thinking | Scratch project |
| 1 | C | Basics | Mario, Credit |
| 2 | C | Arrays, Cryptography | Caesar, Scrabble, Readability |
| 3 | C | Algorithms | Plurality, Runoff, Sort |
| 4 | C | Memory | Filter, Recover, Volume |
| 5 | C | Data Structures | Speller, Inheritance |
| 6 | Python | Python | Sentimental (reimplementations), DNA |
| 7 | SQL | SQL | Songs, Movies, Fiftyville |
| 8 | HTML/CSS/JS | Web Development | Homepage, Trivia |
| 9 | Python/Flask | Flask | Birthdays, Finance |
| — | — | Final Project | ActuON |

---

## Problem Sets

**Week 0 — Scratch**
Computational thinking without syntax. Build a program in Scratch that uses functions, conditions, loops, variables, and events. The goal is to understand how programs think before learning how to write them.

**Week 1 — C: Basics (Mario, Credit)**
First contact with a real language. Mario: print a pyramid of hashes to match the Nintendo game. Credit: validate credit card numbers using Luhn's algorithm — detect American Express, Visa, and Mastercard from the number alone. Learning: variables, types, conditionals, loops, functions, the difference between int and float.

**Week 2 — C: Arrays (Caesar, Scrabble, Readability)**
Caesar: implement the Caesar cipher, shifting letters by a key. Scrabble: score a word by summing letter values. Readability: calculate the Coleman-Liau readability index of text. Learning: strings as arrays of characters, array indexing, command-line arguments, ASCII arithmetic.

**Week 3 — C: Algorithms (Plurality, Runoff, Sort)**
Plurality and Runoff: implement voting algorithms — first-past-the-post and ranked-choice (instant runoff). Sort: given three mystery sorting programs, figure out which is bubble sort, selection sort, and merge sort by timing them on different inputs. Learning: recursion, structs, algorithmic complexity, O(n log n) vs O(n²).

**Week 4 — C: Memory (Filter, Recover, Volume)**
Filter: apply grayscale, sepia, reflect, and blur effects to BMP images by directly manipulating pixel arrays. Recover: recover 50 deleted JPEG photos from a raw memory card image by scanning for JPEG headers in binary. Volume: modify WAV audio volume by scaling sample values. Learning: pointers, pointer arithmetic, malloc/free, file I/O, hexadecimal, memory layout.

**Week 5 — C: Data Structures (Speller, Inheritance)**
Speller: implement a spell checker that loads a 143,000-word dictionary and checks a text file. Must use a hash table for O(1) average lookups. Performance matters — check50 tests correctness, style50 tests style, valgrind tests memory leaks. Inheritance: simulate blood type inheritance across generations using a linked list of person structs. Learning: hash tables, linked lists, tries, memory management, valgrind.

**Week 6 — Python (DNA, Sentimental)**
Sentimental: reimplement Mario, Credit, Readability, and Cash in Python — same logic, dramatically less code. DNA: given a database of DNA profiles and a DNA sequence, identify which person the sequence belongs to by counting Short Tandem Repeats (STRs). Learning: Python syntax, lists, dicts, file I/O with CSV, the difference in effort between C and Python.

**Week 7 — SQL (Songs, Movies, Fiftyville)**
Songs: query a Spotify database of top songs — find artists, average tempo, songs with danceability above a threshold. Movies: query IMDb data across actors, directors, movies, ratings — multi-table queries with complex JOINs. Fiftyville: a mystery. The CS50 duck has been stolen. Use SQL queries to solve the crime by tracing clues through a town's databases — phone records, ATM transactions, airport data, bakery logs.

**Week 8 — Web (Homepage, Trivia)**
Homepage: build a personal website with at least 4 pages using HTML, CSS, and JavaScript. Trivia: build an interactive trivia page where clicking answers reveals correct/incorrect feedback. Learning: HTML structure, CSS selectors and properties, JavaScript DOM manipulation, event listeners.

**Week 9 — Flask (Birthdays, Finance)**
Birthdays: build a birthday tracker web app with Flask and SQLite — add, store, and display birthdays through a web interface. Finance: full stock trading simulation. Users can register, log in, look up real stock prices via an API, buy and sell shares, and view portfolio history. Learning: Flask routing, Jinja2 templates, sessions, SQL from Python, REST patterns, password hashing.

---

## Final Project — ActuON

**[View Project →](final/)** · **[Video Demo](https://youtu.be/your-video-id)**

A neuro-friendly task management web app built for people with ADHD. The name comes from "act on" — the core challenge for ADHD brains isn't knowing what to do, it's starting.

**Stack:** Python, Flask, SQLite, Jinja2, JavaScript, CSS

**Features:**
- User registration and login with password hashing (Werkzeug)
- Dashboard with greeting, task stats, focus card, and Pomodoro-style timer
- Task manager with priorities, due dates, overdue detection, and inline editing
- Brain Dump: write anything, save it as a snapshot with word count, browse history
- Keyboard shortcut (N) to add tasks from any page
- Toast notification system (flash messages) for all actions
- Focus mode: distraction-free single-task view with timer

**Design decisions:**
- Dark purple aesthetic with high contrast — easier to parse for attention-heavy brains
- No habits tracker — removed it because maintaining streaks adds anxiety, not productivity
- No AI features — you don't need suggestions, you need friction reduction
- Brain dump as a dedicated feature — externalizing thoughts reduces cognitive load

---

## What I Learned

**C before Python was the right order.** Writing malloc and free manually made Python's automatic memory management feel like a gift rather than magic. Understanding what's happening underneath — the heap, the stack, pointer arithmetic — means you're never completely lost when things go wrong.

**Speller was the turning point.** A spell checker that loads 143,000 words and checks a text. Getting it to work takes an hour. Getting it to work fast, without memory leaks, with a good hash function, takes much longer. This is where performance stopped being abstract.

**Recover was the most satisfying.** Scanning raw binary data for JPEG file signatures and reconstructing 50 deleted photos. When the first image appeared in the output folder it felt like actual magic. Understanding that "deleted" files are just pointers removed, not data erased, changes how you think about storage and security.

**Fiftyville was the most fun.** A SQL mystery. Reading phone logs, correlating ATM withdrawals with suspects, checking flight manifests to find the escape route. This is what databases are for — answering questions that no single row can answer.

**Finance was the most complete.** A real multi-feature web app. Login, sessions, database, API calls, portfolio math, transaction history. The first time all those pieces worked together end to end was the moment this stopped feeling like homework.

---

## Certificate

[View Certificate](https://cs50.harvard.edu/certificates/8b3721e3-48ac-41c7-ad9f-c8d2318a8b5d)

Awarded 2026 · Harvard University · David J. Malan

---

## Stats

| | |
|---|---|
| Problem Sets | 10 |
| Final Project | ActuON (Flask web app) |
| Languages | C, Python, SQL, HTML, CSS, JavaScript |
| Weeks | 10 + final |
| Started | 2023 |
| Completed | 2026 |
| Platform | edX / cs50.harvard.edu |
