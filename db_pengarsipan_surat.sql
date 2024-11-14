-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 29 Jul 2023 pada 09.37
-- Versi server: 10.1.38-MariaDB
-- Versi PHP: 5.6.40

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_pengarsipan_surat`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `laporanSuratMasuk` (`start` VARCHAR(10), `endd` VARCHAR(10), `disposisi` INT(1))  BEGIN

	CASE disposisi
		WHEN 1 THEN
			SELECT no_surat, tgl_surat, pengirim, ditujukan, perihal, deskripsi FROM v_surat_masuk WHERE (tgl_surat BETWEEN start AND endd) AND status_disposisi = "Sudah Disposisi";
		WHEN 2 THEN
			SELECT no_surat, tgl_surat, pengirim, ditujukan, perihal, deskripsi FROM v_surat_masuk WHERE (tgl_surat BETWEEN start AND endd) AND status_disposisi = "Belum Disposisi"; 
		ELSE
			SELECT no_surat, tgl_surat, pengirim, ditujukan, perihal, deskripsi FROM v_surat_masuk WHERE (tgl_surat BETWEEN start AND endd);
    END CASE;

 END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `disposisi_surat_masuk`
--

CREATE TABLE `disposisi_surat_masuk` (
  `id` int(11) NOT NULL,
  `tgl_disposisi` date DEFAULT NULL,
  `keterangan` varchar(100) DEFAULT NULL,
  `id_surat_masuk` int(11) NOT NULL,
  `id_petugas` int(11) UNSIGNED NOT NULL,
  `dibuat_pada` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `groups`
--

CREATE TABLE `groups` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `name` varchar(20) NOT NULL,
  `description` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `groups`
--

INSERT INTO `groups` (`id`, `name`, `description`) VALUES
(1, 'admin', 'Administrator'),
(2, 'members', 'General User');

-- --------------------------------------------------------

--
-- Struktur dari tabel `jenis_surat`
--

CREATE TABLE `jenis_surat` (
  `id_jenis_surat` int(5) NOT NULL,
  `jenis_surat` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `jenis_surat`
--

INSERT INTO `jenis_surat` (`id_jenis_surat`, `jenis_surat`) VALUES
(1, 'Surat Perintah'),
(2, 'Surat Keterangan'),
(3, 'Perjalanan Dinas!');

-- --------------------------------------------------------

--
-- Struktur dari tabel `login_attempts`
--

CREATE TABLE `login_attempts` (
  `id` int(11) UNSIGNED NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `login` varchar(100) NOT NULL,
  `time` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `login_attempts`
--

INSERT INTO `login_attempts` (`id`, `ip_address`, `login`, `time`) VALUES
(2, '::1', 'ridho', 1689940720);

-- --------------------------------------------------------

--
-- Struktur dari tabel `petugas`
--

CREATE TABLE `petugas` (
  `id` int(11) UNSIGNED NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `salt` varchar(255) DEFAULT NULL,
  `email` varchar(254) NOT NULL,
  `activation_code` varchar(40) DEFAULT NULL,
  `forgotten_password_code` varchar(40) DEFAULT NULL,
  `forgotten_password_time` int(11) UNSIGNED DEFAULT NULL,
  `remember_code` varchar(40) DEFAULT NULL,
  `created_on` int(11) UNSIGNED NOT NULL,
  `last_login` int(11) UNSIGNED DEFAULT NULL,
  `active` tinyint(1) UNSIGNED DEFAULT NULL,
  `nama_petugas` varchar(35) NOT NULL,
  `jenis_kelamin` char(1) NOT NULL,
  `tgl_lahir` varchar(15) NOT NULL,
  `alamat` tinytext,
  `telp` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `petugas`
--

INSERT INTO `petugas` (`id`, `ip_address`, `username`, `password`, `salt`, `email`, `activation_code`, `forgotten_password_code`, `forgotten_password_time`, `remember_code`, `created_on`, `last_login`, `active`, `nama_petugas`, `jenis_kelamin`, `tgl_lahir`, `alamat`, `telp`) VALUES
(1, '127.0.0.1', 'admin', '$2a$07$SeBknntpZror9uyftVopmu61qg0ms8Qv1yV6FG.kQOSM.9QhmTo36', '', '', '', NULL, NULL, NULL, 1268889823, 1690016699, 1, 'Admin', '', '', NULL, NULL),
(7, '::1', 'najmie', '$2y$08$WthRIz/0Y4DOi4gWv0foRuVbGmFvyZVZEO8BOq9I.Us5huoVYgNfq', NULL, 'najmie@gmail.com', NULL, NULL, NULL, NULL, 1689944727, 1690016594, 1, 'najmie', 'P', '07/24/2023', 'tangerang', '000000000');

-- --------------------------------------------------------

--
-- Struktur dari tabel `surat_keluar`
--

CREATE TABLE `surat_keluar` (
  `id_surat_keluar` int(10) NOT NULL,
  `no_surat` varchar(15) DEFAULT NULL,
  `tgl_surat` date DEFAULT NULL,
  `perihal` varchar(100) DEFAULT NULL,
  `pengirim` varchar(45) DEFAULT NULL,
  `kepada` varchar(30) DEFAULT NULL,
  `id_jenis_surat` int(5) DEFAULT NULL,
  `sifat_surat` enum('Rahasia','Penting','Segera','Biasa') DEFAULT NULL,
  `id_petugas` int(11) UNSIGNED DEFAULT NULL,
  `deskripsi` longtext,
  `dibuat_pada` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `surat_masuk`
--

CREATE TABLE `surat_masuk` (
  `id_surat_masuk` int(11) NOT NULL,
  `no_surat` varchar(13) DEFAULT NULL,
  `tgl_surat` date DEFAULT NULL,
  `perihal` varchar(100) DEFAULT NULL,
  `id_jenis_surat` int(5) DEFAULT NULL,
  `pengirim` varchar(30) DEFAULT NULL,
  `ditujukan` varchar(30) DEFAULT NULL,
  `deskripsi` mediumtext,
  `id_petugas` int(11) UNSIGNED DEFAULT NULL,
  `sifat_surat` enum('Rahasia','Penting','Segera','Biasa') DEFAULT NULL,
  `status_disposisi` enum('Sudah Disposisi','Belum Disposisi') DEFAULT NULL,
  `dibuat_pada` int(11) NOT NULL,
  `berkas_surat` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users_groups`
--

CREATE TABLE `users_groups` (
  `id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `group_id` mediumint(8) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `users_groups`
--

INSERT INTO `users_groups` (`id`, `user_id`, `group_id`) VALUES
(1, 1, 1),
(7, 7, 2);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `v_disposisi_surat_masuk`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `v_disposisi_surat_masuk` (
`id` int(11)
,`no_surat` varchar(13)
,`tgl_surat` date
,`tgl_disposisi` date
,`perihal` varchar(100)
,`dari` varchar(30)
,`kepada` varchar(30)
,`keterangan` varchar(100)
,`username` varchar(100)
,`dibuat_pada` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `v_petugas`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `v_petugas` (
`id` int(11) unsigned
,`nama_petugas` varchar(35)
,`username` varchar(100)
,`jenis_kelamin` char(1)
,`tgl_lahir` varchar(15)
,`alamat` tinytext
,`email` varchar(254)
,`telp` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `v_surat_keluar`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `v_surat_keluar` (
`id` int(10)
,`no_surat` varchar(15)
,`tgl_surat` date
,`perihal` varchar(100)
,`pengirim` varchar(45)
,`kepada` varchar(30)
,`jenis_surat` varchar(40)
,`sifat_surat` enum('Rahasia','Penting','Segera','Biasa')
,`petugas` varchar(100)
,`deskripsi` longtext
,`dibuat_pada` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `v_surat_masuk`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `v_surat_masuk` (
`id` int(11)
,`no_surat` varchar(13)
,`tgl_surat` date
,`perihal` varchar(100)
,`jenis_surat` varchar(40)
,`pengirim` varchar(30)
,`ditujukan` varchar(30)
,`deskripsi` mediumtext
,`username` varchar(100)
,`berkas_surat` varchar(20)
,`sifat_surat` enum('Rahasia','Penting','Segera','Biasa')
,`status_disposisi` enum('Sudah Disposisi','Belum Disposisi')
,`dibuat_pada` int(11)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `v_disposisi_surat_masuk`
--
DROP TABLE IF EXISTS `v_disposisi_surat_masuk`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_disposisi_surat_masuk`  AS  select `disposisi_surat_masuk`.`id` AS `id`,`surat_masuk`.`no_surat` AS `no_surat`,`surat_masuk`.`tgl_surat` AS `tgl_surat`,`disposisi_surat_masuk`.`tgl_disposisi` AS `tgl_disposisi`,`surat_masuk`.`perihal` AS `perihal`,`surat_masuk`.`pengirim` AS `dari`,`surat_masuk`.`ditujukan` AS `kepada`,`disposisi_surat_masuk`.`keterangan` AS `keterangan`,`petugas`.`username` AS `username`,`disposisi_surat_masuk`.`dibuat_pada` AS `dibuat_pada` from ((`disposisi_surat_masuk` join `surat_masuk`) join `petugas`) where ((`disposisi_surat_masuk`.`id_surat_masuk` = `surat_masuk`.`id_surat_masuk`) and (`disposisi_surat_masuk`.`id_petugas` = `petugas`.`id`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `v_petugas`
--
DROP TABLE IF EXISTS `v_petugas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_petugas`  AS  select `petugas`.`id` AS `id`,`petugas`.`nama_petugas` AS `nama_petugas`,`petugas`.`username` AS `username`,`petugas`.`jenis_kelamin` AS `jenis_kelamin`,`petugas`.`tgl_lahir` AS `tgl_lahir`,`petugas`.`alamat` AS `alamat`,`petugas`.`email` AS `email`,`petugas`.`telp` AS `telp` from (`petugas` join `users_groups` on((`petugas`.`id` = `users_groups`.`user_id`))) where (`users_groups`.`group_id` = 2) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `v_surat_keluar`
--
DROP TABLE IF EXISTS `v_surat_keluar`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_surat_keluar`  AS  select `surat_keluar`.`id_surat_keluar` AS `id`,`surat_keluar`.`no_surat` AS `no_surat`,`surat_keluar`.`tgl_surat` AS `tgl_surat`,`surat_keluar`.`perihal` AS `perihal`,`surat_keluar`.`pengirim` AS `pengirim`,`surat_keluar`.`kepada` AS `kepada`,`jenis_surat`.`jenis_surat` AS `jenis_surat`,`surat_keluar`.`sifat_surat` AS `sifat_surat`,`petugas`.`username` AS `petugas`,`surat_keluar`.`deskripsi` AS `deskripsi`,`surat_keluar`.`dibuat_pada` AS `dibuat_pada` from ((`surat_keluar` join `jenis_surat`) join `petugas`) where ((`surat_keluar`.`id_jenis_surat` = `jenis_surat`.`id_jenis_surat`) and (`surat_keluar`.`id_petugas` = `petugas`.`id`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `v_surat_masuk`
--
DROP TABLE IF EXISTS `v_surat_masuk`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_surat_masuk`  AS  select `surat_masuk`.`id_surat_masuk` AS `id`,`surat_masuk`.`no_surat` AS `no_surat`,`surat_masuk`.`tgl_surat` AS `tgl_surat`,`surat_masuk`.`perihal` AS `perihal`,`jenis_surat`.`jenis_surat` AS `jenis_surat`,`surat_masuk`.`pengirim` AS `pengirim`,`surat_masuk`.`ditujukan` AS `ditujukan`,`surat_masuk`.`deskripsi` AS `deskripsi`,`petugas`.`username` AS `username`,`surat_masuk`.`berkas_surat` AS `berkas_surat`,`surat_masuk`.`sifat_surat` AS `sifat_surat`,`surat_masuk`.`status_disposisi` AS `status_disposisi`,`surat_masuk`.`dibuat_pada` AS `dibuat_pada` from ((`surat_masuk` join `jenis_surat`) join `petugas`) where ((`surat_masuk`.`id_jenis_surat` = `jenis_surat`.`id_jenis_surat`) and (`surat_masuk`.`id_petugas` = `petugas`.`id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `disposisi_surat_masuk`
--
ALTER TABLE `disposisi_surat_masuk`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_disposisi_surat_masuk_petugas1` (`id_petugas`),
  ADD KEY `fk_disposisi_surat_masuk_surat_masuk1` (`id_surat_masuk`);

--
-- Indeks untuk tabel `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `jenis_surat`
--
ALTER TABLE `jenis_surat`
  ADD PRIMARY KEY (`id_jenis_surat`);

--
-- Indeks untuk tabel `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `petugas`
--
ALTER TABLE `petugas`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `surat_keluar`
--
ALTER TABLE `surat_keluar`
  ADD PRIMARY KEY (`id_surat_keluar`),
  ADD KEY `fk_surat_keluar__jenis_surat1` (`id_jenis_surat`),
  ADD KEY `fk_surat_keluar_petugas1` (`id_petugas`);

--
-- Indeks untuk tabel `surat_masuk`
--
ALTER TABLE `surat_masuk`
  ADD PRIMARY KEY (`id_surat_masuk`),
  ADD KEY `fk_surat_masuk_jenis_surat1` (`id_jenis_surat`),
  ADD KEY `fk_surat_masuk_petugas1` (`id_petugas`);

--
-- Indeks untuk tabel `users_groups`
--
ALTER TABLE `users_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uc_users_groups` (`user_id`,`group_id`),
  ADD KEY `fk_users_groups_users1_idx` (`user_id`),
  ADD KEY `fk_users_groups_groups1_idx` (`group_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `disposisi_surat_masuk`
--
ALTER TABLE `disposisi_surat_masuk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `groups`
--
ALTER TABLE `groups`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `petugas`
--
ALTER TABLE `petugas`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `surat_keluar`
--
ALTER TABLE `surat_keluar`
  MODIFY `id_surat_keluar` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `surat_masuk`
--
ALTER TABLE `surat_masuk`
  MODIFY `id_surat_masuk` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `users_groups`
--
ALTER TABLE `users_groups`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `disposisi_surat_masuk`
--
ALTER TABLE `disposisi_surat_masuk`
  ADD CONSTRAINT `fk_disposisi_surat_masuk_petugas1` FOREIGN KEY (`id_petugas`) REFERENCES `petugas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_disposisi_surat_masuk_surat_masuk1` FOREIGN KEY (`id_surat_masuk`) REFERENCES `surat_masuk` (`id_surat_masuk`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `surat_keluar`
--
ALTER TABLE `surat_keluar`
  ADD CONSTRAINT `fk_surat_keluar__jenis_surat1` FOREIGN KEY (`id_jenis_surat`) REFERENCES `jenis_surat` (`id_jenis_surat`),
  ADD CONSTRAINT `fk_surat_keluar_petugas1` FOREIGN KEY (`id_petugas`) REFERENCES `petugas` (`id`);

--
-- Ketidakleluasaan untuk tabel `surat_masuk`
--
ALTER TABLE `surat_masuk`
  ADD CONSTRAINT `fk_surat_masuk_jenis_surat1` FOREIGN KEY (`id_jenis_surat`) REFERENCES `jenis_surat` (`id_jenis_surat`),
  ADD CONSTRAINT `fk_surat_masuk_petugas1` FOREIGN KEY (`id_petugas`) REFERENCES `petugas` (`id`);

--
-- Ketidakleluasaan untuk tabel `users_groups`
--
ALTER TABLE `users_groups`
  ADD CONSTRAINT `fk_users_groups_groups1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_users_groups_users1` FOREIGN KEY (`user_id`) REFERENCES `petugas` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
