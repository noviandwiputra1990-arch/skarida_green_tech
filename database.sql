-- ========================================================
-- SISTEM SKARIDA GREEN TECH - SMK NEGERI 2 TEGALSARI
-- Skema Database Relasional (SQL) Katalog TOGA
-- ========================================================

-- 1. Tabel Peran Pengguna (Roles)
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO roles (id, role_name) VALUES 
(1, 'Admin'), 
(2, 'Siswa');

-- 2. Tabel Pengguna (Users)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT
);

INSERT INTO users (role_id, full_name, username, password_hash) VALUES 
(1, 'Admin Kebun Skarida', 'admin', 'admin123'),
(2, 'Ahmad Fauzi (Siswa)', 'siswa1', 'siswa123');

-- 3. Tabel Master Lokasi Penanaman (Dikelola oleh Admin)
CREATE TABLE planting_locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO planting_locations (location_name) VALUES 
('Kebun Depan RPS'),
('Kebun TOGA Barat'),
('Greenhouse Skarida'),
('Taman Belakang Sekolah');

-- 4. Tabel Master Fase Pertumbuhan
CREATE TABLE growth_phases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    phase_name VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO growth_phases (phase_name) VALUES 
('Pembibitan/Semai'),
('Fase Vegetatif'),
('Fase Berbunga'),
('Fase Siap Panen');

-- 5. Tabel Entitas Tanaman Pokok
CREATE TABLE plants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    latin_name VARCHAR(150) NOT NULL,
    other_names VARCHAR(200),
    main_photo LONGTEXT NOT NULL,
    characteristics TEXT NOT NULL,
    benefits TEXT NOT NULL,
    care_instructions TEXT NOT NULL,
    phase_id INT NOT NULL,
    location_id INT NOT NULL,
    planted_at DATE NOT NULL,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (phase_id) REFERENCES growth_phases(id),
    FOREIGN KEY (location_id) REFERENCES planting_locations(id) ON DELETE RESTRICT,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 6. Tabel Jurnal Perkembangan Fase & Foto Siswa
CREATE TABLE plant_growth_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plant_id INT NOT NULL,
    phase_id INT NOT NULL,
    photo_url LONGTEXT NOT NULL,
    photo_caption TEXT NOT NULL,
    logged_date DATE NOT NULL,
    recorded_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (plant_id) REFERENCES plants(id) ON DELETE CASCADE,
    FOREIGN KEY (phase_id) REFERENCES growth_phases(id) ON DELETE RESTRICT
);

-- Data Awal Tanaman (Seed Data)
INSERT INTO plants (id, name, latin_name, other_names, main_photo, characteristics, benefits, care_instructions, phase_id, location_id, planted_at, created_by) VALUES 
(1, 'Jahe Merah', 'Zingiber officinale var. rubrum', 'Jahe Sunti, Halia Bara', 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?auto=format&fit=crop&w=600&q=80', 'Batang semu bulat tegak, rimpang berwarna merah jingga dengan serat tegas dan aroma pedas menyengat. Helai daun berseling lancip dengan warna hijau gelap.', 'Meningkatkan daya tahan tubuh, menghangatkan pencernaan, membantu meredakan radang sendi, batuk berdahak, serta melancarkan sirkulasi peredaran darah.', 'Lakukan penyiraman secara berkala satu kali setiap pagi. Bersihkan tanaman dari gulma liar di sekitar pangkal rimpang, dan berikan pupuk kompos terfermentasi setiap 3 minggu sekali.', 2, 1, '2026-01-15', 1),
(2, 'Kunyit', 'Curcuma longa', 'Kunir, Turmeric', 'https://images.unsplash.com/photo-1615485290158-b64ecf3d9b4b?auto=format&fit=crop&w=600&q=80', 'Berdaun lonjong lebar dengan tangkai daun panjang. Rimpang induk berbentuk bulat silindris dengan rimpang cabang bercabang jingga tua terang kaya kurkuminoid.', 'Mengatasi masalah dispepsia/asam lambung, antimikroba alami, penurun peradangan, serta bahan baku minuman jamu kunyit asam penambah imunitas tubuh.', 'Ditempatkan pada area dengan naungan sedang dan intensitas sinar matahari 70%. Siram tanah secukupnya tanpa membuat air tergenang di sekitar perakaran.', 4, 2, '2025-11-10', 1),
(3, 'Lidah Buaya', 'Aloe vera', 'Aloe, Jadam', 'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921?auto=format&fit=crop&w=600&q=80', 'Daun tebal berdaging sukulen tanpa batang jelas, tepi daun berpelepah dengan duri-duri tumpul lunak, bagian dalam pelepah berisikan getah dan gel bening berlendir.', 'Mempercepat regenerasi jaringan luka bakar ringan, meredakan iritasi kulit, menutrisi serta melembapkan folikel rambut, dan anti-inflamasi topikal.', 'Tumbuh optimal pada media porous berpasir dengan drainase lancar. Cukup disiram 2-3 hari sekali untuk mencegah busuk pangkal daun.', 2, 3, '2026-02-01', 1);

-- Data Awal Jurnal Pertumbuhan Siswa
INSERT INTO plant_growth_logs (plant_id, phase_id, photo_url, photo_caption, logged_date, recorded_by) VALUES 
(1, 1, 'https://images.unsplash.com/photo-1592417817098-8f3d6910985b?auto=format&fit=crop&w=400&q=80', 'Penyemaian rimpang jahe merah pada polybag media tanah kompos. Tunas perdana muncul sepanjang 3 cm.', '2026-01-15', 'Ahmad Fauzi (Siswa)'),
(1, 2, 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?auto=format&fit=crop&w=400&q=80', 'Tunas berkembang pesat mencapai tinggi 25 cm dengan 6 helai daun hijau lebat. Rimpang mulai bercabang.', '2026-02-28', 'Siti Nurhaliza (Siswa)');