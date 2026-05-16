-- =============================================================================
-- EventNow — Demo Dataset
-- SQLite-compatible INSERT statements covering every model.
--
-- USAGE
--   1. Make sure the database is migrated:
--        python manage.py migrate
--   2. Load this file:
--        sqlite3 db.sqlite3 < demo_dataset.sql
--   3. Set all demo-user passwords to  demo1234  with one command:
--        python manage.py shell -c "
--        from apps.accounts.models import User
--        for u in User.objects.all():
--            u.set_password('demo1234')
--            u.save()
--        print('Done —', User.objects.count(), 'users updated')
--        "
--
-- After step 3 every account below can log in with password:  demo1234
-- =============================================================================

PRAGMA foreign_keys = ON;

-- -----------------------------------------------------------------------------
-- 0. Clean slate (safe order — children before parents)
-- -----------------------------------------------------------------------------
DELETE FROM apps_sessionregistration;
DELETE FROM apps_eventregistration;
DELETE FROM apps_session;
DELETE FROM apps_track;
DELETE FROM apps_event;
DELETE FROM apps_venue;
DELETE FROM apps_subscription;
DELETE FROM apps_subscriptionplan;
DELETE FROM apps_password;
DELETE FROM apps_identity;
DELETE FROM apps_user_groups;
DELETE FROM apps_user_user_permissions;
DELETE FROM apps_user;

-- Reset auto-increment counters
DELETE FROM sqlite_sequence WHERE name IN (
    'apps_sessionregistration','apps_eventregistration',
    'apps_session','apps_track','apps_event','apps_venue',
    'apps_subscription','apps_subscriptionplan',
    'apps_password','apps_identity','apps_user'
);

-- =============================================================================
-- 1. SUBSCRIPTION PLANS
-- =============================================================================
INSERT INTO apps_subscriptionplan (id, name, price, max_events, max_attendees_per_event, is_active, created_at, updated_at) VALUES
(1, 'Free',       0.00,   2,   50,  1, '2026-01-01 00:00:00', '2026-01-01 00:00:00'),
(2, 'Pro',        29.00, 10,  500,  1, '2026-01-01 00:00:00', '2026-01-01 00:00:00'),
(3, 'Enterprise', 99.00, -1, -1,    1, '2026-01-01 00:00:00', '2026-01-01 00:00:00');

-- =============================================================================
-- 2. USERS
--    Passwords are set to '!' (unusable). Run the shell command above to fix.
--    Roles: admin | organiser | attendee
-- =============================================================================

-- ── Admin ──────────────────────────────────────────────────────────────────
INSERT INTO apps_user (id, password, last_login, is_superuser, email, username, first_name, last_name, avatar_url, role, is_active, is_staff, created_at, updated_at) VALUES
(1, '!', NULL, 1, 'admin@eventnow.io', 'admin', 'Eve', 'Admin', '', 'admin', 1, 1, '2026-01-10 08:00:00', '2026-01-10 08:00:00');

-- ── Organisers ─────────────────────────────────────────────────────────────
INSERT INTO apps_user (id, password, last_login, is_superuser, email, username, first_name, last_name, avatar_url, role, is_active, is_staff, created_at, updated_at) VALUES
(2,  '!', NULL, 0, 'alice.morgan@techconf.com',  'alicemorgan',  'Alice',   'Morgan',    '', 'organiser', 1, 0, '2026-01-15 09:00:00', '2026-01-15 09:00:00'),
(3,  '!', NULL, 0, 'bob.chen@devworld.io',       'bobchen',      'Bob',     'Chen',      '', 'organiser', 1, 0, '2026-01-18 10:00:00', '2026-01-18 10:00:00'),
(4,  '!', NULL, 0, 'carla.reyes@designsummit.co','carlareyes',   'Carla',   'Reyes',     '', 'organiser', 1, 0, '2026-02-01 11:00:00', '2026-02-01 11:00:00'),
(5,  '!', NULL, 0, 'dan.okafor@datahub.org',     'danokafor',    'Dan',     'Okafor',    '', 'organiser', 1, 0, '2026-02-05 12:00:00', '2026-02-05 12:00:00');

-- ── Attendees ──────────────────────────────────────────────────────────────
INSERT INTO apps_user (id, password, last_login, is_superuser, email, username, first_name, last_name, avatar_url, role, is_active, is_staff, created_at, updated_at) VALUES
(6,  '!', NULL, 0, 'jasmine.wu@gmail.com',       'jasminewu',    'Jasmine', 'Wu',        '', 'attendee', 1, 0, '2026-02-10 08:00:00', '2026-02-10 08:00:00'),
(7,  '!', NULL, 0, 'liam.torres@outlook.com',    'liamtorres',   'Liam',    'Torres',    '', 'attendee', 1, 0, '2026-02-11 08:30:00', '2026-02-11 08:30:00'),
(8,  '!', NULL, 0, 'priya.nair@hotmail.com',     'priyanair',    'Priya',   'Nair',      '', 'attendee', 1, 0, '2026-02-12 09:00:00', '2026-02-12 09:00:00'),
(9,  '!', NULL, 0, 'marco.rossi@studio.it',      'marcorossi',   'Marco',   'Rossi',     '', 'attendee', 1, 0, '2026-02-13 09:15:00', '2026-02-13 09:15:00'),
(10, '!', NULL, 0, 'sophie.hall@gmail.com',      'sophiehall',   'Sophie',  'Hall',      '', 'attendee', 1, 0, '2026-02-14 10:00:00', '2026-02-14 10:00:00'),
(11, '!', NULL, 0, 'kieran.smith@yahoo.com',     'kieransmith',  'Kieran',  'Smith',     '', 'attendee', 1, 0, '2026-02-15 10:30:00', '2026-02-15 10:30:00'),
(12, '!', NULL, 0, 'mei.zhang@uq.edu.au',        'meizhang',     'Mei',     'Zhang',     '', 'attendee', 1, 0, '2026-02-16 11:00:00', '2026-02-16 11:00:00'),
(13, '!', NULL, 0, 'oliver.brown@gmail.com',     'oliverbrown',  'Oliver',  'Brown',     '', 'attendee', 1, 0, '2026-02-17 11:15:00', '2026-02-17 11:15:00'),
(14, '!', NULL, 0, 'fatima.ali@gmail.com',       'fatimaali',    'Fatima',  'Ali',       '', 'attendee', 1, 0, '2026-02-18 12:00:00', '2026-02-18 12:00:00'),
(15, '!', NULL, 0, 'noah.patel@gmail.com',       'noahpatel',    'Noah',    'Patel',     '', 'attendee', 1, 0, '2026-02-19 12:30:00', '2026-02-19 12:30:00'),
(16, '!', NULL, 0, 'aisha.diallo@gmail.com',     'aishadiallo',  'Aisha',   'Diallo',    '', 'attendee', 1, 0, '2026-02-20 13:00:00', '2026-02-20 13:00:00'),
(17, '!', NULL, 0, 'james.kim@samsung.com',      'jameskim',     'James',   'Kim',       '', 'attendee', 1, 0, '2026-02-21 13:30:00', '2026-02-21 13:30:00');

-- =============================================================================
-- 3. PASSWORDS (apps_password — one record per user, mirrors the hash)
-- =============================================================================
INSERT INTO apps_password (id, user_id, password_hash, created_at, updated_at) VALUES
( 1,  1, '!', '2026-01-10 08:00:00', '2026-01-10 08:00:00'),
( 2,  2, '!', '2026-01-15 09:00:00', '2026-01-15 09:00:00'),
( 3,  3, '!', '2026-01-18 10:00:00', '2026-01-18 10:00:00'),
( 4,  4, '!', '2026-02-01 11:00:00', '2026-02-01 11:00:00'),
( 5,  5, '!', '2026-02-05 12:00:00', '2026-02-05 12:00:00'),
( 6,  6, '!', '2026-02-10 08:00:00', '2026-02-10 08:00:00'),
( 7,  7, '!', '2026-02-11 08:30:00', '2026-02-11 08:30:00'),
( 8,  8, '!', '2026-02-12 09:00:00', '2026-02-12 09:00:00'),
( 9,  9, '!', '2026-02-13 09:15:00', '2026-02-13 09:15:00'),
(10, 10, '!', '2026-02-14 10:00:00', '2026-02-14 10:00:00'),
(11, 11, '!', '2026-02-15 10:30:00', '2026-02-15 10:30:00'),
(12, 12, '!', '2026-02-16 11:00:00', '2026-02-16 11:00:00'),
(13, 13, '!', '2026-02-17 11:15:00', '2026-02-17 11:15:00'),
(14, 14, '!', '2026-02-18 12:00:00', '2026-02-18 12:00:00'),
(15, 15, '!', '2026-02-19 12:30:00', '2026-02-19 12:30:00'),
(16, 16, '!', '2026-02-20 13:00:00', '2026-02-20 13:00:00'),
(17, 17, '!', '2026-02-21 13:30:00', '2026-02-21 13:30:00');

-- =============================================================================
-- 4. SUBSCRIPTIONS (organisers only)
-- =============================================================================
INSERT INTO apps_subscription (id, organiser_id, plan_id, status, starts_at, ends_at, created_at, updated_at) VALUES
(1, 2, 3, 'active', '2026-01-15 00:00:00', '2027-01-15 00:00:00', '2026-01-15 09:05:00', '2026-01-15 09:05:00'), -- Alice → Enterprise
(2, 3, 2, 'active', '2026-01-18 00:00:00', '2027-01-18 00:00:00', '2026-01-18 10:05:00', '2026-01-18 10:05:00'), -- Bob   → Pro
(3, 4, 2, 'active', '2026-02-01 00:00:00', '2027-02-01 00:00:00', '2026-02-01 11:05:00', '2026-02-01 11:05:00'), -- Carla → Pro
(4, 5, 1, 'active', '2026-02-05 00:00:00', '2027-02-05 00:00:00', '2026-02-05 12:05:00', '2026-02-05 12:05:00'); -- Dan   → Free

-- =============================================================================
-- 5. VENUES
-- =============================================================================
INSERT INTO apps_venue (id, name, address, city, country, created_at, updated_at) VALUES
(1, 'Brisbane Convention & Exhibition Centre', 'Merivale St & Glenelg St',       'Brisbane',  'Australia', '2026-01-20 08:00:00', '2026-01-20 08:00:00'),
(2, 'Sydney International Convention Centre',  '14 Darling Dr',                  'Sydney',    'Australia', '2026-01-20 08:05:00', '2026-01-20 08:05:00'),
(3, 'Melbourne Town Hall',                     '90-130 Swanston St',             'Melbourne', 'Australia', '2026-01-20 08:10:00', '2026-01-20 08:10:00'),
(4, 'UQ Advanced Engineering Building',        'St Lucia Campus',                'Brisbane',  'Australia', '2026-01-20 08:15:00', '2026-01-20 08:15:00'),
(5, 'Optus Stadium — Function Rooms',          '333 Victoria Park Drive',        'Perth',     'Australia', '2026-01-20 08:20:00', '2026-01-20 08:20:00'),
(6, 'Adelaide Convention Centre',              'North Terrace',                  'Adelaide',  'Australia', '2026-01-20 08:25:00', '2026-01-20 08:25:00');

-- =============================================================================
-- 6. EVENTS
--    organiser_id 2 = Alice, 3 = Bob, 4 = Carla, 5 = Dan
--    statuses: published | draft | cancelled | completed
-- =============================================================================
INSERT INTO apps_event (id, title, slug, description, cover_image_url, starts_at, ends_at, status, max_capacity, organiser_id, venue_id, created_at, updated_at) VALUES

-- ── Completed (past) ───────────────────────────────────────────────────────
(1,
 'PyCon Australia 2025',
 'pycon-australia-2025',
 'Australia''s premier Python conference. Two days of talks, workshops and sprints covering web, data science, DevOps and more.',
 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=1200',
 '2025-08-22 09:00:00', '2025-08-23 18:00:00',
 'completed', 600, 2, 1, '2025-06-01 09:00:00', '2025-08-24 09:00:00'),

(2,
 'UX & Design Thinking Masterclass',
 'ux-design-thinking-masterclass-2025',
 'A full-day hands-on workshop led by senior UX practitioners from Canva and Atlassian. Bring your laptop and leave with a redesigned product flow.',
 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?w=1200',
 '2025-10-14 09:00:00', '2025-10-14 17:30:00',
 'completed', 80, 4, 3, '2025-08-01 10:00:00', '2025-10-15 09:00:00'),

-- ── Published (upcoming) ───────────────────────────────────────────────────
(3,
 'DownUnder DevOps Summit 2026',
 'downunder-devops-summit-2026',
 'Three days of talks, panels and workshops covering Kubernetes, CI/CD, platform engineering and SRE practices. The largest DevOps gathering in the Asia-Pacific.',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=1200',
 '2026-06-10 08:30:00', '2026-06-12 17:00:00',
 'published', 400, 2, 1, '2026-02-01 09:00:00', '2026-02-01 09:00:00'),

(4,
 'Data & AI Forum 2026',
 'data-ai-forum-2026',
 'One-day conference exploring the latest in machine learning, LLMs, responsible AI and data engineering. Keynotes from industry leaders and interactive sessions.',
 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?w=1200',
 '2026-07-18 09:00:00', '2026-07-18 18:00:00',
 'published', 300, 5, 4, '2026-02-20 10:00:00', '2026-02-20 10:00:00'),

(5,
 'Frontend Foundations Workshop',
 'frontend-foundations-workshop-2026',
 'A beginner-to-intermediate full-day workshop covering React 19, Tailwind CSS, accessibility and modern build tooling. Limited to 40 seats for maximum hands-on time.',
 'https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=1200',
 '2026-08-05 09:00:00', '2026-08-05 17:00:00',
 'published', 40, 3, 4, '2026-03-10 11:00:00', '2026-03-10 11:00:00'),

(6,
 'Product Leaders Summit',
 'product-leaders-summit-2026',
 'Two days for CPOs, PMs and founders to share strategy, roadmapping and go-to-market learnings. Curated networking, round-table discussions and keynote talks.',
 'https://images.unsplash.com/photo-1551818255-e6e10975bc17?w=1200',
 '2026-09-03 08:00:00', '2026-09-04 17:30:00',
 'published', 200, 4, 2, '2026-03-15 12:00:00', '2026-03-15 12:00:00'),

(7,
 'Cybersecurity & Cloud Security Symposium',
 'cybersecurity-cloud-symposium-2026',
 'A technical symposium for security engineers, architects and compliance officers. Topics include zero-trust, supply-chain security, cloud IAM and incident response.',
 'https://images.unsplash.com/photo-1563206767-5b18f218e8de?w=1200',
 '2026-10-22 09:00:00', '2026-10-23 17:00:00',
 'published', 250, 3, 6, '2026-04-01 09:00:00', '2026-04-01 09:00:00'),

-- ── Draft ──────────────────────────────────────────────────────────────────
(8,
 'Brisbane Startup Weekend 2026',
 'brisbane-startup-weekend-2026',
 '54 hours to turn your idea into a startup. Pitch, build, validate and present — mentors from the local startup ecosystem on hand all weekend.',
 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=1200',
 '2026-11-06 17:00:00', '2026-11-08 21:00:00',
 'draft', 120, 2, 1, '2026-04-10 10:00:00', '2026-04-10 10:00:00'),

-- ── Cancelled ──────────────────────────────────────────────────────────────
(9,
 'AR/VR Innovation Expo (Cancelled)',
 'ar-vr-innovation-expo-2026',
 'This event has been cancelled due to venue unavailability. Registered attendees will receive a full refund.',
 'https://images.unsplash.com/photo-1617802690992-15d93263d3a9?w=1200',
 '2026-05-30 10:00:00', '2026-05-31 17:00:00',
 'cancelled', 180, 5, 5, '2026-03-01 08:00:00', '2026-04-20 14:00:00');

-- =============================================================================
-- 7. TRACKS
--    Each published / completed event gets 2–3 tracks.
-- =============================================================================
INSERT INTO apps_track (id, name, description, event_id, created_at, updated_at) VALUES

-- Event 1 — PyCon Australia 2025 (completed)
(1,  'Web Development',      'Django, FastAPI, async Python and API design.',                            1, '2025-06-05 09:00:00', '2025-06-05 09:00:00'),
(2,  'Data Science & ML',    'NumPy, pandas, scikit-learn, PyTorch and real-world ML pipelines.',       1, '2025-06-05 09:01:00', '2025-06-05 09:01:00'),
(3,  'DevOps & Tooling',     'CI/CD, containers, packaging and deployment automation.',                 1, '2025-06-05 09:02:00', '2025-06-05 09:02:00'),

-- Event 2 — UX Masterclass (completed)
(4,  'Research & Discovery', 'User interviews, Jobs-to-be-Done and synthesis techniques.',              2, '2025-08-05 10:00:00', '2025-08-05 10:00:00'),
(5,  'Prototyping',          'Figma, rapid prototyping and usability testing.',                         2, '2025-08-05 10:01:00', '2025-08-05 10:01:00'),

-- Event 3 — DevOps Summit 2026 (published)
(6,  'Kubernetes & Cloud',   'K8s internals, Helm, GitOps and multi-cloud strategies.',                3, '2026-02-10 09:00:00', '2026-02-10 09:00:00'),
(7,  'CI/CD & Automation',   'GitHub Actions, ArgoCD, Tekton and release pipelines.',                  3, '2026-02-10 09:01:00', '2026-02-10 09:01:00'),
(8,  'Platform Engineering', 'Internal developer platforms, backstage and golden paths.',               3, '2026-02-10 09:02:00', '2026-02-10 09:02:00'),

-- Event 4 — Data & AI Forum 2026 (published)
(9,  'Machine Learning',     'Model training, evaluation, MLOps and model serving.',                    4, '2026-02-22 10:00:00', '2026-02-22 10:00:00'),
(10, 'Large Language Models','Prompt engineering, RAG, fine-tuning and agent frameworks.',              4, '2026-02-22 10:01:00', '2026-02-22 10:01:00'),
(11, 'Responsible AI',       'Fairness, explainability, governance and regulatory compliance.',         4, '2026-02-22 10:02:00', '2026-02-22 10:02:00'),

-- Event 5 — Frontend Foundations (published)
(12, 'React & State',        'Hooks, context, Zustand and React Query.',                               5, '2026-03-12 11:00:00', '2026-03-12 11:00:00'),
(13, 'CSS & Styling',        'Tailwind CSS, CSS Modules and component design systems.',                5, '2026-03-12 11:01:00', '2026-03-12 11:01:00'),

-- Event 6 — Product Leaders Summit (published)
(14, 'Strategy & Vision',    'OKRs, roadmapping and long-range product bets.',                        6, '2026-03-18 12:00:00', '2026-03-18 12:00:00'),
(15, 'Stakeholder & Growth', 'Executive alignment, pricing experiments and growth loops.',             6, '2026-03-18 12:01:00', '2026-03-18 12:01:00'),

-- Event 7 — Cybersecurity Symposium (published)
(16, 'Cloud Security',       'AWS IAM, GCP security posture, secrets management.',                    7, '2026-04-05 09:00:00', '2026-04-05 09:00:00'),
(17, 'Zero Trust & Identity','ZTNA, SASE, identity federation and mTLS.',                             7, '2026-04-05 09:01:00', '2026-04-05 09:01:00'),
(18, 'Incident Response',    'Detection, containment, forensics and post-mortems.',                   7, '2026-04-05 09:02:00', '2026-04-05 09:02:00');

-- =============================================================================
-- 8. SESSIONS
-- =============================================================================
INSERT INTO apps_session (id, title, description, speaker_name, room, starts_at, ends_at, max_capacity, event_id, track_id, created_at, updated_at) VALUES

-- ── Track 1 — Web Dev (Event 1 — PyCon 2025) ──────────────────────────────
(1,  'Building REST APIs with Django Ninja',
     'Dive into Django Ninja''s type-safe API layer and benchmark it against DRF.',
     'Tomás Herrera',       'Room A', '2025-08-22 10:00:00', '2025-08-22 11:00:00', 200, 1, 1, '2025-06-10 09:00:00', '2025-06-10 09:00:00'),
(2,  'Async Django in Production',
     'Real-world lessons from migrating a high-traffic Django app to async views and channels.',
     'Linda Park',          'Room A', '2025-08-22 11:15:00', '2025-08-22 12:15:00', 200, 1, 1, '2025-06-10 09:01:00', '2025-06-10 09:01:00'),
(3,  'HTMX + Django: Frontend Without JS',
     'Server-side rendering meets interactivity — no JavaScript framework required.',
     'Ben Walsh',           'Room A', '2025-08-22 13:30:00', '2025-08-22 14:30:00', 200, 1, 1, '2025-06-10 09:02:00', '2025-06-10 09:02:00'),
(4,  'Scaling Django with Read Replicas',
     'Database routing, connection pooling and query optimisation at scale.',
     'Mei Tanaka',          'Room A', '2025-08-22 14:45:00', '2025-08-22 15:45:00', 200, 1, 1, '2025-06-10 09:03:00', '2025-06-10 09:03:00'),

-- ── Track 2 — Data Science (Event 1) ──────────────────────────────────────
(5,  'Practical Feature Engineering',
     'From raw tabular data to model-ready features — a practitioner''s handbook.',
     'Ravi Kumar',          'Room B', '2025-08-22 10:00:00', '2025-08-22 11:00:00', 180, 1, 2, '2025-06-10 09:10:00', '2025-06-10 09:10:00'),
(6,  'PyTorch Lightning for Beginners',
     'Strip away boilerplate and focus on research with Lightning''s trainer abstraction.',
     'Sarah Osei',          'Room B', '2025-08-22 11:15:00', '2025-08-22 12:15:00', 180, 1, 2, '2025-06-10 09:11:00', '2025-06-10 09:11:00'),
(7,  'Building ML Pipelines with Prefect',
     'Orchestrating data ingestion, training and evaluation workflows.',
     'Carlos Mendez',       'Room B', '2025-08-22 13:30:00', '2025-08-22 14:30:00', 180, 1, 2, '2025-06-10 09:12:00', '2025-06-10 09:12:00'),

-- ── Track 3 — DevOps (Event 1) ─────────────────────────────────────────────
(8,  'Packaging Python Apps with Nix',
     'Reproducible builds and hermetic environments using the Nix ecosystem.',
     'Freya Andersen',      'Room C', '2025-08-22 10:00:00', '2025-08-22 11:00:00', 150, 1, 3, '2025-06-10 09:20:00', '2025-06-10 09:20:00'),
(9,  'GitHub Actions Deep Dive',
     'Reusable workflows, composite actions and optimising runner minutes.',
     'Jack Liu',            'Room C', '2025-08-22 11:15:00', '2025-08-22 12:15:00', 150, 1, 3, '2025-06-10 09:21:00', '2025-06-10 09:21:00'),

-- ── Track 4 — Research (Event 2 — UX Masterclass) ─────────────────────────
(10, 'Jobs-to-be-Done Interviewing',
     'How to uncover the real reason customers hire your product.',
     'Amara Obi',           'Studio 1', '2025-10-14 09:30:00', '2025-10-14 11:00:00', 40, 2, 4, '2025-08-10 10:00:00', '2025-08-10 10:00:00'),
(11, 'Affinity Mapping & Synthesis',
     'Turning hundreds of stickies into actionable insight clusters.',
     'James Morley',        'Studio 1', '2025-10-14 11:15:00', '2025-10-14 12:30:00', 40, 2, 4, '2025-08-10 10:01:00', '2025-08-10 10:01:00'),

-- ── Track 5 — Prototyping (Event 2) ───────────────────────────────────────
(12, 'Figma Variables & Design Tokens',
     'Using Figma''s variables system for theme-aware, scalable design systems.',
     'Nadia Volkov',        'Studio 2', '2025-10-14 09:30:00', '2025-10-14 11:00:00', 40, 2, 5, '2025-08-10 10:10:00', '2025-08-10 10:10:00'),
(13, 'Rapid Prototype to Usability Test in 90 min',
     'A live exercise: sketch → prototype → test with a real participant.',
     'Daniel Yip',          'Studio 2', '2025-10-14 14:00:00', '2025-10-14 15:30:00', 40, 2, 5, '2025-08-10 10:11:00', '2025-08-10 10:11:00'),

-- ── Track 6 — Kubernetes (Event 3 — DevOps Summit 2026) ───────────────────
(14, 'Kubernetes Networking Demystified',
     'CNI plugins, eBPF, service meshes and east-west traffic management.',
     'Hugo Lindqvist',      'Hall A', '2026-06-10 09:30:00', '2026-06-10 10:30:00', 150, 3, 6, '2026-02-15 09:00:00', '2026-02-15 09:00:00'),
(15, 'Helm 4 & GitOps Patterns',
     'Managing complex releases with Helm 4 and ArgoCD.',
     'Yuki Sato',           'Hall A', '2026-06-10 10:45:00', '2026-06-10 11:45:00', 150, 3, 6, '2026-02-15 09:01:00', '2026-02-15 09:01:00'),
(16, 'Multi-Cloud K8s with Crossplane',
     'Provisioning cloud resources from inside Kubernetes using Crossplane.',
     'Anita Sharma',        'Hall A', '2026-06-10 13:00:00', '2026-06-10 14:00:00', 150, 3, 6, '2026-02-15 09:02:00', '2026-02-15 09:02:00'),
(17, 'K8s Security Hardening',
     'PSS, admission controllers, runtime security and supply-chain integrity.',
     'Leon Fischer',        'Hall A', '2026-06-10 14:15:00', '2026-06-10 15:15:00', 150, 3, 6, '2026-02-15 09:03:00', '2026-02-15 09:03:00'),

-- ── Track 7 — CI/CD (Event 3) ──────────────────────────────────────────────
(18, 'GitHub Actions at Enterprise Scale',
     'Self-hosted runners, OIDC federation and workflow governance.',
     'Claire Dupont',       'Hall B', '2026-06-10 09:30:00', '2026-06-10 10:30:00', 120, 3, 7, '2026-02-15 09:10:00', '2026-02-15 09:10:00'),
(19, 'Progressive Delivery with Argo Rollouts',
     'Blue-green, canary and traffic splitting strategies in production.',
     'Sam Okafor',          'Hall B', '2026-06-10 10:45:00', '2026-06-10 11:45:00', 120, 3, 7, '2026-02-15 09:11:00', '2026-02-15 09:11:00'),
(20, 'Testing Infrastructure with Terratest',
     'Writing Go-based integration tests for Terraform modules.',
     'Zara Ahmed',          'Hall B', '2026-06-10 13:00:00', '2026-06-10 14:00:00', 120, 3, 7, '2026-02-15 09:12:00', '2026-02-15 09:12:00'),

-- ── Track 8 — Platform Engineering (Event 3) ──────────────────────────────
(21, 'Build Your Internal Developer Portal',
     'Backstage from zero to production — plugins, scorecards and TechDocs.',
     'Elena Novak',         'Hall C', '2026-06-10 09:30:00', '2026-06-10 10:30:00', 100, 3, 8, '2026-02-15 09:20:00', '2026-02-15 09:20:00'),
(22, 'Golden Paths That Developers Love',
     'Designing opinionated templates that teams actually adopt.',
     'Chris Baxter',        'Hall C', '2026-06-10 10:45:00', '2026-06-10 11:45:00', 100, 3, 8, '2026-02-15 09:21:00', '2026-02-15 09:21:00'),

-- ── Track 9 — ML (Event 4 — Data & AI Forum 2026) ─────────────────────────
(23, 'MLflow for Experiment Tracking',
     'Tracking runs, registering models and deploying with MLflow.',
     'Kenji Nakamura',      'Auditorium', '2026-07-18 09:30:00', '2026-07-18 10:30:00', 300, 4, 9, '2026-03-01 10:00:00', '2026-03-01 10:00:00'),
(24, 'Feature Stores in Practice',
     'Online and offline feature stores with Feast and Hopsworks.',
     'Ayasha Redcloud',     'Auditorium', '2026-07-18 10:45:00', '2026-07-18 11:45:00', 300, 4, 9, '2026-03-01 10:01:00', '2026-03-01 10:01:00'),
(25, 'Deploying Models with BentoML',
     'From training notebook to production API in 30 minutes.',
     'Oliver Grant',        'Auditorium', '2026-07-18 13:00:00', '2026-07-18 14:00:00', 300, 4, 9, '2026-03-01 10:02:00', '2026-03-01 10:02:00'),

-- ── Track 10 — LLMs (Event 4) ──────────────────────────────────────────────
(26, 'RAG Architectures Deep Dive',
     'Chunking strategies, embedding models, re-ranking and query rewriting.',
     'Priya Sharma',        'Room 1', '2026-07-18 09:30:00', '2026-07-18 10:30:00', 200, 4, 10, '2026-03-01 10:10:00', '2026-03-01 10:10:00'),
(27, 'Building Agents with LangGraph',
     'Stateful multi-step agents using LangGraph''s graph abstraction.',
     'Tom Eriksson',        'Room 1', '2026-07-18 10:45:00', '2026-07-18 11:45:00', 200, 4, 10, '2026-03-01 10:11:00', '2026-03-01 10:11:00'),
(28, 'Fine-Tuning LLMs on a Budget',
     'LoRA, QLoRA and efficient fine-tuning on consumer hardware.',
     'Amina Hassan',        'Room 1', '2026-07-18 13:00:00', '2026-07-18 14:00:00', 200, 4, 10, '2026-03-01 10:12:00', '2026-03-01 10:12:00'),

-- ── Track 11 — Responsible AI (Event 4) ───────────────────────────────────
(29, 'AI Act Compliance for Australian Orgs',
     'Mapping the EU AI Act obligations to your Australian AI products.',
     'Rebecca Tang',        'Room 2', '2026-07-18 09:30:00', '2026-07-18 10:30:00', 150, 4, 11, '2026-03-01 10:20:00', '2026-03-01 10:20:00'),
(30, 'Bias Detection in Production',
     'Tooling and processes for ongoing fairness monitoring post-deployment.',
     'Samuel Eze',          'Room 2', '2026-07-18 10:45:00', '2026-07-18 11:45:00', 150, 4, 11, '2026-03-01 10:21:00', '2026-03-01 10:21:00'),

-- ── Track 12 — React & State (Event 5 — Frontend Workshop) ───────────────
(31, 'React 19 New Features Walkthrough',
     'Server components, Actions and the new use() hook explained with demos.',
     'Lena Kovacs',         'Lab 1', '2026-08-05 09:30:00', '2026-08-05 11:00:00', 40, 5, 12, '2026-03-20 11:00:00', '2026-03-20 11:00:00'),
(32, 'State Management in 2026',
     'When to use useState, Zustand, Jotai or React Query — a decision framework.',
     'Lena Kovacs',         'Lab 1', '2026-08-05 13:00:00', '2026-08-05 14:30:00', 40, 5, 12, '2026-03-20 11:01:00', '2026-03-20 11:01:00'),

-- ── Track 13 — CSS & Styling (Event 5) ────────────────────────────────────
(33, 'Tailwind CSS Component Workshop',
     'Build a full UI kit from scratch using Tailwind utility classes.',
     'Ivan Petrov',         'Lab 2', '2026-08-05 11:15:00', '2026-08-05 12:30:00', 40, 5, 13, '2026-03-20 11:10:00', '2026-03-20 11:10:00'),
(34, 'Accessibility-First CSS',
     'Focus management, colour contrast, motion-safe utilities and ARIA patterns.',
     'Ivan Petrov',         'Lab 2', '2026-08-05 14:45:00', '2026-08-05 16:00:00', 40, 5, 13, '2026-03-20 11:11:00', '2026-03-20 11:11:00'),

-- ── Track 14 — Strategy (Event 6 — Product Leaders Summit) ────────────────
(35, 'Writing Strategies People Read',
     'How to craft a one-pager that aligns engineering, design and exec.',
     'Catherine Lee',       'Ballroom A', '2026-09-03 09:00:00', '2026-09-03 10:00:00', 200, 6, 14, '2026-03-20 12:00:00', '2026-03-20 12:00:00'),
(36, 'OKRs That Actually Work',
     'Common OKR failure modes and the measurement practices that fix them.',
     'David Stone',         'Ballroom A', '2026-09-03 10:15:00', '2026-09-03 11:15:00', 200, 6, 14, '2026-03-20 12:01:00', '2026-03-20 12:01:00'),
(37, 'Long-Range Roadmapping Under Uncertainty',
     'Horizon planning, bets vs commitments and communicating uncertainty.',
     'Catherine Lee',       'Ballroom A', '2026-09-03 13:00:00', '2026-09-03 14:00:00', 200, 6, 14, '2026-03-20 12:02:00', '2026-03-20 12:02:00'),

-- ── Track 15 — Stakeholder & Growth (Event 6) ─────────────────────────────
(38, 'Pricing as Product Strategy',
     'Usage-based vs seat-based vs hybrid — how to choose and iterate.',
     'James Wu',            'Ballroom B', '2026-09-03 09:00:00', '2026-09-03 10:00:00', 150, 6, 15, '2026-03-20 12:10:00', '2026-03-20 12:10:00'),
(39, 'Executive Storytelling for PMs',
     'Getting buy-in from the C-suite with data-backed narratives.',
     'Maria Santos',        'Ballroom B', '2026-09-03 10:15:00', '2026-09-03 11:15:00', 150, 6, 15, '2026-03-20 12:11:00', '2026-03-20 12:11:00'),

-- ── Track 16 — Cloud Security (Event 7 — Cyber Symposium) ────────────────
(40, 'AWS IAM Least-Privilege Patterns',
     'Resource-based policies, SCPs and permission boundaries in practice.',
     'Nour Khaled',         'Theatre 1', '2026-10-22 09:30:00', '2026-10-22 10:30:00', 120, 7, 16, '2026-04-10 09:00:00', '2026-04-10 09:00:00'),
(41, 'Secrets Management at Scale',
     'Vault, AWS Secrets Manager and rotating credentials without downtime.',
     'Tariq Ismail',        'Theatre 1', '2026-10-22 10:45:00', '2026-10-22 11:45:00', 120, 7, 16, '2026-04-10 09:01:00', '2026-04-10 09:01:00'),
(42, 'Cloud Security Posture Management',
     'CSPM tooling, drift detection and automated remediation workflows.',
     'Yolanda Ferreira',    'Theatre 1', '2026-10-22 13:00:00', '2026-10-22 14:00:00', 120, 7, 16, '2026-04-10 09:02:00', '2026-04-10 09:02:00'),

-- ── Track 17 — Zero Trust (Event 7) ──────────────────────────────────────
(43, 'Zero Trust Architecture in Practice',
     'From perimeter-based to identity-centric security — a migration blueprint.',
     'Petra Horak',         'Theatre 2', '2026-10-22 09:30:00', '2026-10-22 10:30:00', 100, 7, 17, '2026-04-10 09:10:00', '2026-04-10 09:10:00'),
(44, 'mTLS Everywhere',
     'Mutual TLS in microservices, service meshes and developer workflows.',
     'Vikram Singh',        'Theatre 2', '2026-10-22 10:45:00', '2026-10-22 11:45:00', 100, 7, 17, '2026-04-10 09:11:00', '2026-04-10 09:11:00'),

-- ── Track 18 — Incident Response (Event 7) ────────────────────────────────
(45, 'Building a Detection Engineering Practice',
     'SIEM, detection-as-code and reducing false positive noise.',
     'Amir Khalil',         'Theatre 3', '2026-10-22 09:30:00', '2026-10-22 10:30:00', 80, 7, 18, '2026-04-10 09:20:00', '2026-04-10 09:20:00'),
(46, 'IR Tabletop: Live Ransomware Scenario',
     'Interactive tabletop exercise — attendees play blue team roles.',
     'Jessica Morin',       'Theatre 3', '2026-10-22 13:00:00', '2026-10-22 15:00:00', 80, 7, 18, '2026-04-10 09:21:00', '2026-04-10 09:21:00');

-- =============================================================================
-- 9. EVENT REGISTRATIONS
--    attendee IDs: 6–17
--    event IDs:  1 (completed), 2 (completed), 3–7 (published/upcoming)
-- =============================================================================
INSERT INTO apps_eventregistration (id, guest_first_name, guest_last_name, guest_email, status, registered_at, updated_at, event_id, user_id) VALUES

-- ── Event 1 — PyCon 2025 (completed) ──────────────────────────────────────
( 1, 'Jasmine', 'Wu',      'jasmine.wu@gmail.com',       'confirmed', '2025-07-10 09:00:00', '2025-07-10 09:00:00', 1,  6),
( 2, 'Liam',    'Torres',  'liam.torres@outlook.com',    'confirmed', '2025-07-11 10:00:00', '2025-07-11 10:00:00', 1,  7),
( 3, 'Priya',   'Nair',    'priya.nair@hotmail.com',     'confirmed', '2025-07-12 11:00:00', '2025-07-12 11:00:00', 1,  8),
( 4, 'Marco',   'Rossi',   'marco.rossi@studio.it',      'confirmed', '2025-07-13 08:30:00', '2025-07-13 08:30:00', 1,  9),
( 5, 'Sophie',  'Hall',    'sophie.hall@gmail.com',      'confirmed', '2025-07-14 09:15:00', '2025-07-14 09:15:00', 1, 10),
( 6, 'Kieran',  'Smith',   'kieran.smith@yahoo.com',     'confirmed', '2025-07-15 10:30:00', '2025-07-15 10:30:00', 1, 11),
( 7, 'Mei',     'Zhang',   'mei.zhang@uq.edu.au',        'confirmed', '2025-07-16 11:00:00', '2025-07-16 11:00:00', 1, 12),
( 8, 'Oliver',  'Brown',   'oliver.brown@gmail.com',     'confirmed', '2025-07-17 11:15:00', '2025-07-17 11:15:00', 1, 13),
( 9, 'Fatima',  'Ali',     'fatima.ali@gmail.com',       'confirmed', '2025-07-18 12:00:00', '2025-07-18 12:00:00', 1, 14),
(10, 'Noah',    'Patel',   'noah.patel@gmail.com',       'cancelled', '2025-07-19 12:30:00', '2025-07-25 10:00:00', 1, 15),

-- ── Event 2 — UX Masterclass (completed) ──────────────────────────────────
(11, 'Sophie',  'Hall',    'sophie.hall@gmail.com',      'confirmed', '2025-09-01 09:00:00', '2025-09-01 09:00:00', 2, 10),
(12, 'Aisha',   'Diallo',  'aisha.diallo@gmail.com',     'confirmed', '2025-09-02 10:00:00', '2025-09-02 10:00:00', 2, 16),
(13, 'James',   'Kim',     'james.kim@samsung.com',      'confirmed', '2025-09-03 11:00:00', '2025-09-03 11:00:00', 2, 17),
(14, 'Priya',   'Nair',    'priya.nair@hotmail.com',     'confirmed', '2025-09-04 09:30:00', '2025-09-04 09:30:00', 2,  8),

-- ── Event 3 — DevOps Summit 2026 (upcoming) ───────────────────────────────
(15, 'Jasmine', 'Wu',      'jasmine.wu@gmail.com',       'confirmed', '2026-03-01 09:00:00', '2026-03-01 09:00:00', 3,  6),
(16, 'Liam',    'Torres',  'liam.torres@outlook.com',    'confirmed', '2026-03-02 10:00:00', '2026-03-02 10:00:00', 3,  7),
(17, 'Marco',   'Rossi',   'marco.rossi@studio.it',      'confirmed', '2026-03-03 08:30:00', '2026-03-03 08:30:00', 3,  9),
(18, 'Kieran',  'Smith',   'kieran.smith@yahoo.com',     'confirmed', '2026-03-04 10:30:00', '2026-03-04 10:30:00', 3, 11),
(19, 'Oliver',  'Brown',   'oliver.brown@gmail.com',     'confirmed', '2026-03-05 11:15:00', '2026-03-05 11:15:00', 3, 13),
(20, 'Noah',    'Patel',   'noah.patel@gmail.com',       'confirmed', '2026-03-06 12:30:00', '2026-03-06 12:30:00', 3, 15),
(21, 'James',   'Kim',     'james.kim@samsung.com',      'confirmed', '2026-03-07 13:00:00', '2026-03-07 13:00:00', 3, 17),

-- ── Event 4 — Data & AI Forum 2026 (upcoming) ─────────────────────────────
(22, 'Jasmine', 'Wu',      'jasmine.wu@gmail.com',       'confirmed', '2026-03-10 09:00:00', '2026-03-10 09:00:00', 4,  6),
(23, 'Priya',   'Nair',    'priya.nair@hotmail.com',     'confirmed', '2026-03-11 11:00:00', '2026-03-11 11:00:00', 4,  8),
(24, 'Mei',     'Zhang',   'mei.zhang@uq.edu.au',        'confirmed', '2026-03-12 11:00:00', '2026-03-12 11:00:00', 4, 12),
(25, 'Fatima',  'Ali',     'fatima.ali@gmail.com',       'confirmed', '2026-03-13 12:00:00', '2026-03-13 12:00:00', 4, 14),
(26, 'Aisha',   'Diallo',  'aisha.diallo@gmail.com',     'confirmed', '2026-03-14 13:00:00', '2026-03-14 13:00:00', 4, 16),

-- ── Event 5 — Frontend Workshop (upcoming) ────────────────────────────────
(27, 'Sophie',  'Hall',    'sophie.hall@gmail.com',      'confirmed', '2026-04-01 09:00:00', '2026-04-01 09:00:00', 5, 10),
(28, 'Aisha',   'Diallo',  'aisha.diallo@gmail.com',     'confirmed', '2026-04-02 10:00:00', '2026-04-02 10:00:00', 5, 16),
(29, 'Noah',    'Patel',   'noah.patel@gmail.com',       'confirmed', '2026-04-03 12:30:00', '2026-04-03 12:30:00', 5, 15),

-- ── Event 6 — Product Leaders Summit (upcoming) ───────────────────────────
(30, 'Liam',    'Torres',  'liam.torres@outlook.com',    'confirmed', '2026-04-05 10:00:00', '2026-04-05 10:00:00', 6,  7),
(31, 'Sophie',  'Hall',    'sophie.hall@gmail.com',      'confirmed', '2026-04-06 09:15:00', '2026-04-06 09:15:00', 6, 10),
(32, 'James',   'Kim',     'james.kim@samsung.com',      'confirmed', '2026-04-07 13:00:00', '2026-04-07 13:00:00', 6, 17),
(33, 'Fatima',  'Ali',     'fatima.ali@gmail.com',       'cancelled', '2026-04-08 12:00:00', '2026-04-20 08:00:00', 6, 14),

-- ── Event 7 — Cybersecurity Symposium (upcoming) ──────────────────────────
(34, 'Marco',   'Rossi',   'marco.rossi@studio.it',      'confirmed', '2026-04-15 08:30:00', '2026-04-15 08:30:00', 7,  9),
(35, 'Kieran',  'Smith',   'kieran.smith@yahoo.com',     'confirmed', '2026-04-16 10:30:00', '2026-04-16 10:30:00', 7, 11),
(36, 'Oliver',  'Brown',   'oliver.brown@gmail.com',     'confirmed', '2026-04-17 11:15:00', '2026-04-17 11:15:00', 7, 13),
(37, 'Mei',     'Zhang',   'mei.zhang@uq.edu.au',        'confirmed', '2026-04-18 11:00:00', '2026-04-18 11:00:00', 7, 12),
(38, 'James',   'Kim',     'james.kim@samsung.com',      'confirmed', '2026-04-19 13:00:00', '2026-04-19 13:00:00', 7, 17);

-- =============================================================================
-- 10. SESSION REGISTRATIONS
--     Links EventRegistration → Session
-- =============================================================================
INSERT INTO apps_sessionregistration (id, registration_id, session_id, created_at) VALUES

-- ── Reg 1  Jasmine @ PyCon 2025 ─────────────────────────────────────────
( 1,  1,  1, '2025-07-10 09:05:00'),  -- REST APIs with Django Ninja
( 2,  1,  5, '2025-07-10 09:05:00'),  -- Practical Feature Engineering
( 3,  1,  7, '2025-07-10 09:05:00'),  -- ML Pipelines with Prefect

-- ── Reg 2  Liam @ PyCon 2025 ────────────────────────────────────────────
( 4,  2,  1, '2025-07-11 10:05:00'),  -- REST APIs with Django Ninja
( 5,  2,  2, '2025-07-11 10:05:00'),  -- Async Django in Production
( 6,  2,  8, '2025-07-11 10:05:00'),  -- Packaging with Nix
( 7,  2,  9, '2025-07-11 10:05:00'),  -- GitHub Actions Deep Dive

-- ── Reg 3  Priya @ PyCon 2025 ───────────────────────────────────────────
( 8,  3,  5, '2025-07-12 11:05:00'),  -- Feature Engineering
( 9,  3,  6, '2025-07-12 11:05:00'),  -- PyTorch Lightning
(10,  3,  7, '2025-07-12 11:05:00'),  -- ML Pipelines

-- ── Reg 4  Marco @ PyCon 2025 ───────────────────────────────────────────
(11,  4,  3, '2025-07-13 08:35:00'),  -- HTMX + Django
(12,  4,  4, '2025-07-13 08:35:00'),  -- Scaling with Read Replicas
(13,  4,  8, '2025-07-13 08:35:00'),  -- Packaging with Nix

-- ── Reg 5  Sophie @ PyCon 2025 ──────────────────────────────────────────
(14,  5,  1, '2025-07-14 09:20:00'),  -- REST APIs
(15,  5,  2, '2025-07-14 09:20:00'),  -- Async Django

-- ── Reg 6  Kieran @ PyCon 2025 ──────────────────────────────────────────
(16,  6,  8, '2025-07-15 10:35:00'),  -- Packaging with Nix
(17,  6,  9, '2025-07-15 10:35:00'),  -- GitHub Actions

-- ── Reg 7  Mei @ PyCon 2025 ─────────────────────────────────────────────
(18,  7,  5, '2025-07-16 11:05:00'),  -- Feature Engineering
(19,  7,  6, '2025-07-16 11:05:00'),  -- PyTorch Lightning

-- ── Reg 8  Oliver @ PyCon 2025 ──────────────────────────────────────────
(20,  8,  1, '2025-07-17 11:20:00'),  -- REST APIs
(21,  8,  3, '2025-07-17 11:20:00'),  -- HTMX + Django
(22,  8,  9, '2025-07-17 11:20:00'),  -- GitHub Actions

-- ── Reg 9  Fatima @ PyCon 2025 ──────────────────────────────────────────
(23,  9,  2, '2025-07-18 12:05:00'),  -- Async Django
(24,  9,  4, '2025-07-18 12:05:00'),  -- Read Replicas

-- ── Reg 11 Sophie @ UX Masterclass ──────────────────────────────────────
(25, 11, 10, '2025-09-01 09:05:00'),  -- JTBD Interviewing
(26, 11, 11, '2025-09-01 09:05:00'),  -- Affinity Mapping
(27, 11, 12, '2025-09-01 09:05:00'),  -- Figma Variables
(28, 11, 13, '2025-09-01 09:05:00'),  -- Rapid Prototype

-- ── Reg 12 Aisha @ UX Masterclass ────────────────────────────────────────
(29, 12, 10, '2025-09-02 10:05:00'),  -- JTBD Interviewing
(30, 12, 12, '2025-09-02 10:05:00'),  -- Figma Variables

-- ── Reg 13 James @ UX Masterclass ────────────────────────────────────────
(31, 13, 11, '2025-09-03 11:05:00'),  -- Affinity Mapping
(32, 13, 13, '2025-09-03 11:05:00'),  -- Rapid Prototype

-- ── Reg 14 Priya @ UX Masterclass ────────────────────────────────────────
(33, 14, 10, '2025-09-04 09:35:00'),  -- JTBD Interviewing
(34, 14, 11, '2025-09-04 09:35:00'),  -- Affinity Mapping
(35, 14, 12, '2025-09-04 09:35:00'),  -- Figma Variables
(36, 14, 13, '2025-09-04 09:35:00'),  -- Rapid Prototype

-- ── Reg 15 Jasmine @ DevOps Summit ───────────────────────────────────────
(37, 15, 14, '2026-03-01 09:05:00'),  -- K8s Networking
(38, 15, 15, '2026-03-01 09:05:00'),  -- Helm 4 & GitOps
(39, 15, 18, '2026-03-01 09:05:00'),  -- GH Actions Enterprise
(40, 15, 21, '2026-03-01 09:05:00'),  -- Internal Dev Portal

-- ── Reg 16 Liam @ DevOps Summit ──────────────────────────────────────────
(41, 16, 14, '2026-03-02 10:05:00'),  -- K8s Networking
(42, 16, 16, '2026-03-02 10:05:00'),  -- Multi-Cloud K8s
(43, 16, 19, '2026-03-02 10:05:00'),  -- Progressive Delivery
(44, 16, 22, '2026-03-02 10:05:00'),  -- Golden Paths

-- ── Reg 17 Marco @ DevOps Summit ─────────────────────────────────────────
(45, 17, 17, '2026-03-03 08:35:00'),  -- K8s Security
(46, 17, 20, '2026-03-03 08:35:00'),  -- Terratest
(47, 17, 21, '2026-03-03 08:35:00'),  -- Dev Portal

-- ── Reg 18 Kieran @ DevOps Summit ────────────────────────────────────────
(48, 18, 15, '2026-03-04 10:35:00'),  -- Helm 4
(49, 18, 18, '2026-03-04 10:35:00'),  -- GH Actions
(50, 18, 19, '2026-03-04 10:35:00'),  -- Progressive Delivery

-- ── Reg 19 Oliver @ DevOps Summit ────────────────────────────────────────
(51, 19, 21, '2026-03-05 11:20:00'),  -- Dev Portal
(52, 19, 22, '2026-03-05 11:20:00'),  -- Golden Paths

-- ── Reg 20 Noah @ DevOps Summit ──────────────────────────────────────────
(53, 20, 14, '2026-03-06 12:35:00'),  -- K8s Networking
(54, 20, 17, '2026-03-06 12:35:00'),  -- K8s Security
(55, 20, 20, '2026-03-06 12:35:00'),  -- Terratest

-- ── Reg 22 Jasmine @ Data & AI Forum ─────────────────────────────────────
(56, 22, 23, '2026-03-10 09:05:00'),  -- MLflow
(57, 22, 24, '2026-03-10 09:05:00'),  -- Feature Stores
(58, 22, 26, '2026-03-10 09:05:00'),  -- RAG Deep Dive
(59, 22, 27, '2026-03-10 09:05:00'),  -- LangGraph Agents

-- ── Reg 23 Priya @ Data & AI Forum ───────────────────────────────────────
(60, 23, 23, '2026-03-11 11:05:00'),  -- MLflow
(61, 23, 25, '2026-03-11 11:05:00'),  -- BentoML Deployment
(62, 23, 29, '2026-03-11 11:05:00'),  -- AI Act Compliance
(63, 23, 30, '2026-03-11 11:05:00'),  -- Bias Detection

-- ── Reg 24 Mei @ Data & AI Forum ─────────────────────────────────────────
(64, 24, 26, '2026-03-12 11:05:00'),  -- RAG Deep Dive
(65, 24, 27, '2026-03-12 11:05:00'),  -- LangGraph
(66, 24, 28, '2026-03-12 11:05:00'),  -- Fine-Tuning LLMs

-- ── Reg 25 Fatima @ Data & AI Forum ──────────────────────────────────────
(67, 25, 29, '2026-03-13 12:05:00'),  -- AI Act Compliance
(68, 25, 30, '2026-03-13 12:05:00'),  -- Bias Detection

-- ── Reg 26 Aisha @ Data & AI Forum ───────────────────────────────────────
(69, 26, 23, '2026-03-14 13:05:00'),  -- MLflow
(70, 26, 24, '2026-03-14 13:05:00'),  -- Feature Stores
(71, 26, 28, '2026-03-14 13:05:00'),  -- Fine-Tuning LLMs

-- ── Reg 27 Sophie @ Frontend Workshop ────────────────────────────────────
(72, 27, 31, '2026-04-01 09:05:00'),  -- React 19 Features
(73, 27, 32, '2026-04-01 09:05:00'),  -- State Management
(74, 27, 33, '2026-04-01 09:05:00'),  -- Tailwind Workshop
(75, 27, 34, '2026-04-01 09:05:00'),  -- Accessibility CSS

-- ── Reg 28 Aisha @ Frontend Workshop ─────────────────────────────────────
(76, 28, 31, '2026-04-02 10:05:00'),  -- React 19 Features
(77, 28, 33, '2026-04-02 10:05:00'),  -- Tailwind Workshop

-- ── Reg 29 Noah @ Frontend Workshop ──────────────────────────────────────
(78, 29, 32, '2026-04-03 12:35:00'),  -- State Management
(79, 29, 34, '2026-04-03 12:35:00'),  -- Accessibility CSS

-- ── Reg 30 Liam @ Product Leaders Summit ─────────────────────────────────
(80, 30, 35, '2026-04-05 10:05:00'),  -- Writing Strategies
(81, 30, 36, '2026-04-05 10:05:00'),  -- OKRs That Work
(82, 30, 38, '2026-04-05 10:05:00'),  -- Pricing as Product Strategy

-- ── Reg 31 Sophie @ Product Leaders Summit ───────────────────────────────
(83, 31, 36, '2026-04-06 09:20:00'),  -- OKRs
(84, 31, 37, '2026-04-06 09:20:00'),  -- Long-Range Roadmapping
(85, 31, 39, '2026-04-06 09:20:00'),  -- Executive Storytelling

-- ── Reg 32 James @ Product Leaders Summit ────────────────────────────────
(86, 32, 35, '2026-04-07 13:05:00'),  -- Writing Strategies
(87, 32, 38, '2026-04-07 13:05:00'),  -- Pricing as Product Strategy
(88, 32, 39, '2026-04-07 13:05:00'),  -- Executive Storytelling

-- ── Reg 34 Marco @ Cybersecurity Symposium ───────────────────────────────
(89, 34, 40, '2026-04-15 08:35:00'),  -- AWS IAM
(90, 34, 41, '2026-04-15 08:35:00'),  -- Secrets Management
(91, 34, 43, '2026-04-15 08:35:00'),  -- Zero Trust Architecture
(92, 34, 45, '2026-04-15 08:35:00'),  -- Detection Engineering

-- ── Reg 35 Kieran @ Cybersecurity Symposium ──────────────────────────────
(93, 35, 40, '2026-04-16 10:35:00'),  -- AWS IAM
(94, 35, 42, '2026-04-16 10:35:00'),  -- CSPM
(95, 35, 44, '2026-04-16 10:35:00'),  -- mTLS Everywhere
(96, 35, 46, '2026-04-16 10:35:00'),  -- IR Tabletop

-- ── Reg 36 Oliver @ Cybersecurity Symposium ──────────────────────────────
(97, 36, 43, '2026-04-17 11:20:00'),  -- Zero Trust
(98, 36, 45, '2026-04-17 11:20:00'),  -- Detection Engineering
(99, 36, 46, '2026-04-17 11:20:00'),  -- IR Tabletop

-- ── Reg 37 Mei @ Cybersecurity Symposium ─────────────────────────────────
(100, 37, 41, '2026-04-18 11:05:00'), -- Secrets Management
(101, 37, 42, '2026-04-18 11:05:00'), -- CSPM
(102, 37, 44, '2026-04-18 11:05:00'), -- mTLS Everywhere

-- ── Reg 38 James @ Cybersecurity Symposium ───────────────────────────────
(103, 38, 40, '2026-04-19 13:05:00'), -- AWS IAM
(104, 38, 43, '2026-04-19 13:05:00'), -- Zero Trust
(105, 38, 46, '2026-04-19 13:05:00'); -- IR Tabletop

-- =============================================================================
-- Done! Summary:
--   Users          : 17 (1 admin, 4 organisers, 12 attendees)
--   Subscription Plans: 3
--   Subscriptions  : 4
--   Venues         : 6
--   Events         : 9 (2 completed, 5 published, 1 draft, 1 cancelled)
--   Tracks         : 18
--   Sessions       : 46
--   Registrations  : 38 (35 confirmed, 3 cancelled)
--   Sess. Regs     : 105
-- =============================================================================
