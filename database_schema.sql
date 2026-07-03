-- Database aplikasi Mobile Programming
-- Target: MySQL 8.0+
-- Authentication tetap menggunakan Firebase; firebase_uid menjadi identitas
-- yang dikirim Flutter dan diverifikasi oleh Laravel.

CREATE DATABASE IF NOT EXISTS mobile_programming
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE mobile_programming;

CREATE TABLE IF NOT EXISTS users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    firebase_uid VARCHAR(128) NULL,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(191) NOT NULL,
    email_verified_at TIMESTAMP NULL,
    password VARCHAR(255) NULL,
    role ENUM('student', 'lecturer', 'admin') NOT NULL DEFAULT 'student',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_users_firebase_uid (firebase_uid),
    UNIQUE KEY uq_users_email (email),
    KEY idx_users_role_active (role, is_active)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS profiles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    location VARCHAR(150) NULL,
    position VARCHAR(100) NULL,
    profession VARCHAR(100) NULL,
    phone_number VARCHAR(30) NULL,
    about TEXT NULL,
    photo_url VARCHAR(2048) NULL,
    projects_count INT UNSIGNED NOT NULL DEFAULT 0,
    followers_count INT UNSIGNED NOT NULL DEFAULT 0,
    experience_years SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    linkedin_url VARCHAR(2048) NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_profiles_user_id (user_id),
    CONSTRAINT fk_profiles_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS courses (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(150) NOT NULL,
    study_program VARCHAR(150) NULL,
    faculty VARCHAR(150) NULL,
    lecturer_name VARCHAR(150) NULL,
    description TEXT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_courses_code (code),
    KEY idx_courses_active (is_active)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS meetings (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    course_id BIGINT UNSIGNED NOT NULL,
    meeting_number TINYINT UNSIGNED NOT NULL,
    slug VARCHAR(191) NOT NULL,
    title VARCHAR(191) NOT NULL,
    summary TEXT NULL,
    accent_color CHAR(7) NOT NULL DEFAULT '#0A66C2',
    background_color CHAR(7) NOT NULL DEFAULT '#EAF4FF',
    status ENUM('draft', 'published', 'archived') NOT NULL DEFAULT 'draft',
    available_at DATETIME NULL,
    interactive_demo_key VARCHAR(100) NULL,
    sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_meetings_course_number (course_id, meeting_number),
    UNIQUE KEY uq_meetings_course_slug (course_id, slug),
    KEY idx_meetings_listing (course_id, status, sort_order),
    CONSTRAINT chk_meetings_number CHECK (meeting_number BETWEEN 1 AND 99),
    CONSTRAINT chk_meetings_accent_color
        CHECK (accent_color REGEXP '^#[0-9A-Fa-f]{6}$'),
    CONSTRAINT chk_meetings_background_color
        CHECK (background_color REGEXP '^#[0-9A-Fa-f]{6}$'),
    CONSTRAINT fk_meetings_course
        FOREIGN KEY (course_id) REFERENCES courses(id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS meeting_keywords (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    meeting_id BIGINT UNSIGNED NOT NULL,
    keyword VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_meeting_keywords (meeting_id, keyword),
    KEY idx_meeting_keywords_keyword (keyword),
    CONSTRAINT fk_meeting_keywords_meeting
        FOREIGN KEY (meeting_id) REFERENCES meetings(id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- content_json menyimpan payload sesuai block_type, misalnya:
-- paragraph:   {"text": "..."}
-- bullet_list: {"items": ["...", "..."]}
-- code:        {"language": "dart", "code": "..."}
-- key_value:   {"items": [{"label": "...", "value": "..."}]}
-- demo:        {"demo_key": "radio_button_demo"}
CREATE TABLE IF NOT EXISTS meeting_content_blocks (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    meeting_id BIGINT UNSIGNED NOT NULL,
    block_key VARCHAR(100) NOT NULL,
    block_type ENUM(
        'heading',
        'paragraph',
        'bullet_list',
        'code',
        'key_value',
        'callout',
        'image',
        'demo'
    ) NOT NULL,
    title VARCHAR(191) NULL,
    content_json JSON NOT NULL,
    sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    is_visible BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_content_blocks_key (meeting_id, block_key),
    KEY idx_content_blocks_order (meeting_id, is_visible, sort_order),
    CONSTRAINT fk_content_blocks_meeting
        FOREIGN KEY (meeting_id) REFERENCES meetings(id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS user_meeting_progress (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    meeting_id BIGINT UNSIGNED NOT NULL,
    status ENUM('not_started', 'in_progress', 'completed')
        NOT NULL DEFAULT 'not_started',
    progress_percent TINYINT UNSIGNED NOT NULL DEFAULT 0,
    started_at DATETIME NULL,
    completed_at DATETIME NULL,
    last_opened_at DATETIME NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_user_meeting_progress (user_id, meeting_id),
    KEY idx_progress_user_status (user_id, status),
    CONSTRAINT chk_progress_percent CHECK (progress_percent BETWEEN 0 AND 100),
    CONSTRAINT fk_progress_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_progress_meeting
        FOREIGN KEY (meeting_id) REFERENCES meetings(id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS exams (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    course_id BIGINT UNSIGNED NOT NULL,
    exam_type ENUM('uts', 'uas', 'quiz') NOT NULL,
    title VARCHAR(191) NOT NULL,
    room VARCHAR(100) NULL,
    class_code VARCHAR(100) NULL,
    exam_date DATE NULL,
    start_time TIME NULL,
    duration_minutes SMALLINT UNSIGNED NULL,
    exam_kind VARCHAR(100) NULL,
    learning_outcome TEXT NULL,
    instructions TEXT NULL,
    status ENUM('draft', 'published', 'closed') NOT NULL DEFAULT 'draft',
    published_at DATETIME NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_exams_course_type (course_id, exam_type),
    KEY idx_exams_listing (course_id, status, exam_date),
    CONSTRAINT fk_exams_course
        FOREIGN KEY (course_id) REFERENCES courses(id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS exam_questions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    exam_id BIGINT UNSIGNED NOT NULL,
    question_number SMALLINT UNSIGNED NOT NULL,
    question_text TEXT NOT NULL,
    question_type ENUM('essay', 'multiple_choice', 'file_upload')
        NOT NULL DEFAULT 'essay',
    options_json JSON NULL,
    weight_percent DECIMAL(5,2) UNSIGNED NOT NULL DEFAULT 0,
    max_time_minutes SMALLINT UNSIGNED NULL,
    sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_exam_question_number (exam_id, question_number),
    KEY idx_exam_questions_order (exam_id, sort_order),
    CONSTRAINT chk_question_weight CHECK (weight_percent BETWEEN 0 AND 100),
    CONSTRAINT fk_exam_questions_exam
        FOREIGN KEY (exam_id) REFERENCES exams(id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS exam_attempts (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    exam_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    attempt_number TINYINT UNSIGNED NOT NULL DEFAULT 1,
    status ENUM('in_progress', 'submitted', 'graded')
        NOT NULL DEFAULT 'in_progress',
    score DECIMAL(5,2) UNSIGNED NULL,
    started_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    submitted_at DATETIME NULL,
    graded_at DATETIME NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_exam_attempt (exam_id, user_id, attempt_number),
    KEY idx_exam_attempts_user_status (user_id, status),
    CONSTRAINT chk_attempt_score CHECK (score IS NULL OR score BETWEEN 0 AND 100),
    CONSTRAINT fk_exam_attempts_exam
        FOREIGN KEY (exam_id) REFERENCES exams(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_exam_attempts_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS exam_answers (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    attempt_id BIGINT UNSIGNED NOT NULL,
    question_id BIGINT UNSIGNED NOT NULL,
    answer_text LONGTEXT NULL,
    selected_option VARCHAR(191) NULL,
    file_url VARCHAR(2048) NULL,
    score DECIMAL(5,2) UNSIGNED NULL,
    lecturer_feedback TEXT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_exam_answer (attempt_id, question_id),
    CONSTRAINT chk_answer_score CHECK (score IS NULL OR score BETWEEN 0 AND 100),
    CONSTRAINT fk_exam_answers_attempt
        FOREIGN KEY (attempt_id) REFERENCES exam_attempts(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_exam_answers_question
        FOREIGN KEY (question_id) REFERENCES exam_questions(id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- Seed mata kuliah saat ini.
INSERT INTO courses (
    code,
    name,
    study_program,
    faculty,
    lecturer_name,
    description,
    is_active
) VALUES (
    '04SIFE008',
    'Mobile Programming',
    'Sistem Informasi',
    'Ilmu Komputer',
    'Nafiah, S.Si., M.Kom',
    'Materi pembelajaran Mobile Programming menggunakan Flutter dan Dart.',
    TRUE
) ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    study_program = VALUES(study_program),
    faculty = VALUES(faculty),
    lecturer_name = VALUES(lecturer_name),
    description = VALUES(description),
    is_active = VALUES(is_active);

SET @course_id = (
    SELECT id FROM courses WHERE code = '04SIFE008' LIMIT 1
);

-- interactive_demo_key menghubungkan konten API dengan widget demo lokal Flutter.
INSERT INTO meetings (
    course_id,
    meeting_number,
    slug,
    title,
    accent_color,
    background_color,
    status,
    interactive_demo_key,
    sort_order
) VALUES
    (@course_id, 1,  'pertemuan-1',  'Pertemuan 1',  '#0A66C2', '#EAF4FF', 'published', 'flutter_introduction', 1),
    (@course_id, 2,  'pertemuan-2',  'Pertemuan 2',  '#7C3AED', '#F3E8FF', 'published', 'layout_basics', 2),
    (@course_id, 3,  'pertemuan-3',  'Pertemuan 3',  '#0891B2', '#E6F7FB', 'published', 'form_demo', 3),
    (@course_id, 4,  'pertemuan-4',  'Pertemuan 4',  '#DC2626', '#FEE2E2', 'published', 'notification_demo', 4),
    (@course_id, 5,  'pertemuan-5',  'Pertemuan 5',  '#1E88E5', '#EAF4FF', 'published', 'list_view_demo', 5),
    (@course_id, 6,  'pertemuan-6',  'Pertemuan 6',  '#34A853', '#EAF7ED', 'published', 'checkbox_demo', 6),
    (@course_id, 7,  'pertemuan-7',  'Pertemuan 7',  '#F59E0B', '#FFF5E5', 'published', 'radio_button_demo', 7),
    (@course_id, 8,  'pertemuan-8',  'Pertemuan 8',  '#8E24AA', '#F5EAF8', 'published', 'dropdown_demo', 8),
    (@course_id, 9,  'pertemuan-9',  'Pertemuan 9',  '#0F766E', '#E6FFFA', 'published', 'date_time_picker_demo', 9),
    (@course_id, 10, 'pertemuan-10', 'Pertemuan 10', '#4338CA', '#EDEBFE', 'published', 'navigation_demo', 10),
    (@course_id, 11, 'pertemuan-11', 'Pertemuan 11', '#BE123C', '#FFE4E6', 'draft', NULL, 11),
    (@course_id, 12, 'pertemuan-12', 'Pertemuan 12', '#B45309', '#FEF3C7', 'draft', NULL, 12),
    (@course_id, 13, 'pertemuan-13', 'Pertemuan 13', '#15803D', '#DCFCE7', 'draft', NULL, 13),
    (@course_id, 14, 'pertemuan-14', 'Pertemuan 14', '#475467', '#F2F4F7', 'draft', NULL, 14)
ON DUPLICATE KEY UPDATE
    slug = VALUES(slug),
    title = VALUES(title),
    accent_color = VALUES(accent_color),
    background_color = VALUES(background_color),
    status = VALUES(status),
    interactive_demo_key = VALUES(interactive_demo_key),
    sort_order = VALUES(sort_order);

INSERT INTO exams (
    course_id,
    exam_type,
    title,
    room,
    class_code,
    exam_date,
    duration_minutes,
    exam_kind,
    learning_outcome,
    instructions,
    status,
    published_at
) VALUES
    (
        @course_id,
        'uts',
        'Ujian Tengah Semester (UTS)',
        'V.925',
        '04SIFE008',
        '2026-04-09',
        100,
        'Utama',
        'Mahasiswa mampu menerapkan pemikiran logis dan inovatif dalam pengembangan teknologi, membangun perangkat lunak berdasarkan objek dan kelas, serta menerapkan fungsi dan bahasa pemrograman pada aplikasi Android.',
        'Jawablah pertanyaan dengan uraian yang jelas.',
        'published',
        CURRENT_TIMESTAMP
    ),
    (
        @course_id,
        'uas',
        'Ujian Akhir Semester (UAS)',
        NULL,
        '04SIFE008',
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        'draft',
        NULL
    )
ON DUPLICATE KEY UPDATE
    title = VALUES(title),
    room = VALUES(room),
    class_code = VALUES(class_code),
    exam_date = VALUES(exam_date),
    duration_minutes = VALUES(duration_minutes),
    exam_kind = VALUES(exam_kind),
    learning_outcome = VALUES(learning_outcome),
    instructions = VALUES(instructions),
    status = VALUES(status),
    published_at = VALUES(published_at);

SET @uts_id = (
    SELECT id
    FROM exams
    WHERE course_id = @course_id AND exam_type = 'uts'
    LIMIT 1
);

INSERT INTO exam_questions (
    exam_id,
    question_number,
    question_text,
    question_type,
    weight_percent,
    max_time_minutes,
    sort_order
) VALUES
    (@uts_id, 1, 'Buatlah aplikasi sederhana untuk menampilkan daftar pertemuan 1 sampai 7 menggunakan ListView.', 'essay', 25, 15, 1),
    (@uts_id, 2, 'Buatlah aplikasi sederhana untuk menampilkan bottom navigation bar dengan menu profil dan daftar menggunakan package Salomon Bottom Bar.', 'essay', 20, 10, 2),
    (@uts_id, 3, 'Buatlah aplikasi sederhana untuk menampilkan profil yang terdiri dari foto, nama, NIM, dan kelas.', 'essay', 25, 15, 3),
    (@uts_id, 4, 'Buatlah aplikasi sederhana yang menggabungkan kebutuhan pada soal nomor 1, 2, dan 3.', 'essay', 30, 20, 4)
ON DUPLICATE KEY UPDATE
    question_text = VALUES(question_text),
    question_type = VALUES(question_type),
    weight_percent = VALUES(weight_percent),
    max_time_minutes = VALUES(max_time_minutes),
    sort_order = VALUES(sort_order);

-- View ringkas untuk endpoint dashboard pengguna.
CREATE OR REPLACE VIEW user_course_progress_summary AS
SELECT
    u.id AS user_id,
    c.id AS course_id,
    COUNT(m.id) AS published_meetings,
    SUM(CASE WHEN ump.status = 'completed' THEN 1 ELSE 0 END) AS completed_meetings,
    ROUND(
        CASE
            WHEN COUNT(m.id) = 0 THEN 0
            ELSE SUM(CASE WHEN ump.status = 'completed' THEN 1 ELSE 0 END)
                / COUNT(m.id) * 100
        END,
        2
    ) AS progress_percent
FROM users u
CROSS JOIN courses c
LEFT JOIN meetings m
    ON m.course_id = c.id
    AND m.status = 'published'
LEFT JOIN user_meeting_progress ump
    ON ump.user_id = u.id
    AND ump.meeting_id = m.id
GROUP BY u.id, c.id;

