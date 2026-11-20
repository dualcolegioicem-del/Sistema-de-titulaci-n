-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-10-2026 a las 16:03:10
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `icem`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alumnos`
--

CREATE TABLE `alumnos` (
  `id_alumno` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `matricula` varchar(30) DEFAULT NULL,
  `apellido_paterno` varchar(80) DEFAULT NULL,
  `apellido_materno` varchar(80) DEFAULT NULL,
  `nombre` varchar(80) DEFAULT NULL,
  `estatus_academico` enum('activo','egresado','titulado','baja') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `alumnos`
--

INSERT INTO `alumnos` (`id_alumno`, `id_usuario`, `matricula`, `apellido_paterno`, `apellido_materno`, `nombre`, `estatus_academico`) VALUES
(6, 11113, 'A001', 'Pérez', 'López', 'Juan', 'activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `areas`
--

CREATE TABLE `areas` (
  `id_area` int(11) NOT NULL,
  `nombre_area` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `estatus` enum('activo','inactivo') DEFAULT 'activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `areas`
--

INSERT INTO `areas` (`id_area`, `nombre_area`, `descripcion`, `estatus`) VALUES
(1, 'Titulación', 'Coordinación de titulación del Colegio ICEM', 'activo'),
(2, 'Coordinación de Titulación', 'Área encargada del proceso de titulación', 'activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add alumnos', 7, 'add_alumnos'),
(26, 'Can change alumnos', 7, 'change_alumnos'),
(27, 'Can delete alumnos', 7, 'delete_alumnos'),
(28, 'Can view alumnos', 7, 'view_alumnos'),
(29, 'Can add areas', 8, 'add_areas'),
(30, 'Can change areas', 8, 'change_areas'),
(31, 'Can delete areas', 8, 'delete_areas'),
(32, 'Can view areas', 8, 'view_areas'),
(33, 'Can add detalle factura', 9, 'add_detallefactura'),
(34, 'Can change detalle factura', 9, 'change_detallefactura'),
(35, 'Can delete detalle factura', 9, 'delete_detallefactura'),
(36, 'Can view detalle factura', 9, 'view_detallefactura'),
(37, 'Can add django content type', 10, 'add_djangocontenttype'),
(38, 'Can change django content type', 10, 'change_djangocontenttype'),
(39, 'Can delete django content type', 10, 'delete_djangocontenttype'),
(40, 'Can view django content type', 10, 'view_djangocontenttype'),
(41, 'Can add django migrations', 11, 'add_djangomigrations'),
(42, 'Can change django migrations', 11, 'change_djangomigrations'),
(43, 'Can delete django migrations', 11, 'delete_djangomigrations'),
(44, 'Can view django migrations', 11, 'view_djangomigrations'),
(45, 'Can add documentos alumno', 12, 'add_documentosalumno'),
(46, 'Can change documentos alumno', 12, 'change_documentosalumno'),
(47, 'Can delete documentos alumno', 12, 'delete_documentosalumno'),
(48, 'Can view documentos alumno', 12, 'view_documentosalumno'),
(49, 'Can add documentos requeridos modalidad', 13, 'add_documentosrequeridosmodalidad'),
(50, 'Can change documentos requeridos modalidad', 13, 'change_documentosrequeridosmodalidad'),
(51, 'Can delete documentos requeridos modalidad', 13, 'delete_documentosrequeridosmodalidad'),
(52, 'Can view documentos requeridos modalidad', 13, 'view_documentosrequeridosmodalidad'),
(53, 'Can add empleados', 14, 'add_empleados'),
(54, 'Can change empleados', 14, 'change_empleados'),
(55, 'Can delete empleados', 14, 'delete_empleados'),
(56, 'Can view empleados', 14, 'view_empleados'),
(57, 'Can add facturas', 15, 'add_facturas'),
(58, 'Can change facturas', 15, 'change_facturas'),
(59, 'Can delete facturas', 15, 'delete_facturas'),
(60, 'Can view facturas', 15, 'view_facturas'),
(61, 'Can add modalidades titulacion', 16, 'add_modalidadestitulacion'),
(62, 'Can change modalidades titulacion', 16, 'change_modalidadestitulacion'),
(63, 'Can delete modalidades titulacion', 16, 'delete_modalidadestitulacion'),
(64, 'Can view modalidades titulacion', 16, 'view_modalidadestitulacion'),
(65, 'Can add observaciones documentos', 17, 'add_observacionesdocumentos'),
(66, 'Can change observaciones documentos', 17, 'change_observacionesdocumentos'),
(67, 'Can delete observaciones documentos', 17, 'delete_observacionesdocumentos'),
(68, 'Can view observaciones documentos', 17, 'view_observacionesdocumentos'),
(69, 'Can add procesos titulacion', 18, 'add_procesostitulacion'),
(70, 'Can change procesos titulacion', 18, 'change_procesostitulacion'),
(71, 'Can delete procesos titulacion', 18, 'delete_procesostitulacion'),
(72, 'Can view procesos titulacion', 18, 'view_procesostitulacion'),
(73, 'Can add roles', 19, 'add_roles'),
(74, 'Can change roles', 19, 'change_roles'),
(75, 'Can delete roles', 19, 'delete_roles'),
(76, 'Can view roles', 19, 'view_roles'),
(77, 'Can add seguimiento titulacion', 20, 'add_seguimientotitulacion'),
(78, 'Can change seguimiento titulacion', 20, 'change_seguimientotitulacion'),
(79, 'Can delete seguimiento titulacion', 20, 'delete_seguimientotitulacion'),
(80, 'Can view seguimiento titulacion', 20, 'view_seguimientotitulacion'),
(81, 'Can add tipos documentos', 21, 'add_tiposdocumentos'),
(82, 'Can change tipos documentos', 21, 'change_tiposdocumentos'),
(83, 'Can delete tipos documentos', 21, 'delete_tiposdocumentos'),
(84, 'Can view tipos documentos', 21, 'view_tiposdocumentos'),
(85, 'Can add usuario', 22, 'add_usuario'),
(86, 'Can change usuario', 22, 'change_usuario'),
(87, 'Can delete usuario', 22, 'delete_usuario'),
(88, 'Can view usuario', 22, 'view_usuario'),
(89, 'Can add usuarios roles', 23, 'add_usuariosroles'),
(90, 'Can change usuarios roles', 23, 'change_usuariosroles'),
(91, 'Can delete usuarios roles', 23, 'delete_usuariosroles'),
(92, 'Can view usuarios roles', 23, 'view_usuariosroles');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session'),
(7, 'titulacion', 'alumnos'),
(8, 'titulacion', 'areas'),
(9, 'titulacion', 'detallefactura'),
(10, 'titulacion', 'djangocontenttype'),
(11, 'titulacion', 'djangomigrations'),
(12, 'titulacion', 'documentosalumno'),
(13, 'titulacion', 'documentosrequeridosmodalidad'),
(14, 'titulacion', 'empleados'),
(15, 'titulacion', 'facturas'),
(16, 'titulacion', 'modalidadestitulacion'),
(17, 'titulacion', 'observacionesdocumentos'),
(18, 'titulacion', 'procesostitulacion'),
(19, 'titulacion', 'roles'),
(20, 'titulacion', 'seguimientotitulacion'),
(21, 'titulacion', 'tiposdocumentos'),
(22, 'titulacion', 'usuario'),
(23, 'titulacion', 'usuariosroles');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2026-10-02 15:19:59.510747'),
(2, 'auth', '0001_initial', '2026-10-02 15:19:59.874822'),
(3, 'admin', '0001_initial', '2026-10-02 15:19:59.967462'),
(4, 'admin', '0002_logentry_remove_auto_add', '2026-10-02 15:19:59.976389'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2026-10-02 15:19:59.985613'),
(6, 'contenttypes', '0002_remove_content_type_name', '2026-10-02 15:20:00.044274'),
(7, 'auth', '0002_alter_permission_name_max_length', '2026-10-02 15:20:00.081270'),
(8, 'auth', '0003_alter_user_email_max_length', '2026-10-02 15:20:00.094774'),
(9, 'auth', '0004_alter_user_username_opts', '2026-10-02 15:20:00.102538'),
(10, 'auth', '0005_alter_user_last_login_null', '2026-10-02 15:20:00.135147'),
(11, 'auth', '0006_require_contenttypes_0002', '2026-10-02 15:20:00.137676'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2026-10-02 15:20:00.145666'),
(13, 'auth', '0008_alter_user_username_max_length', '2026-10-02 15:20:00.157567'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2026-10-02 15:20:00.173557'),
(15, 'auth', '0010_alter_group_name_max_length', '2026-10-02 15:20:00.192628'),
(16, 'auth', '0011_update_proxy_permissions', '2026-10-02 15:20:00.201262'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2026-10-02 15:20:00.220137'),
(18, 'sessions', '0001_initial', '2026-10-02 15:20:00.245588'),
(19, 'titulacion', '0001_initial', '2026-10-02 15:20:00.259000');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('a11sl0d1zpqu0zt36vqvf3yjstjlhm2w', '.eJyrVspMiS8tLk0sysxXsjI0NDQ01lEqySzIRwgqJeaU5ublK-mAlBYU5SenFucrWZnWAgBesxRF:1xIB8y:uN3cbqwb4uWXD1DlXc-lxLR27T3kcScTqeoB3c6GgBs', '2026-10-31 20:36:40.527250'),
('cfffr9j3tvsk532y8rys6ztrp5h1zco1', '.eJyrVspMiS8tLk0sysxXsjI0NDQ01lEqySzIRwgqJeaU5ublK-mAlBYU5SenFucrWZnWAgBesxRF:1xH1rQ:knOuwAoX62nDfv9wn0G4Fsxt7otqYM3ewTaVYoip6Tk', '2026-10-28 16:29:48.345493'),
('xzcamz3xwcfab4xgatlo8cstwa2f6hag', 'eyJpZF91c3VhcmlvIjoxMTExNywiaWRfcHJvY2VzbyI6NH0:1xDknH:mA0Nbf4xO3ulb8WweFH27JaXnt4HR8XmFkFnZwb8lgU', '2026-10-19 15:39:59.815844');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documentos_alumno`
--

CREATE TABLE `documentos_alumno` (
  `id_documento_alumno` int(11) NOT NULL,
  `id_proceso_titulacion` int(11) NOT NULL,
  `id_tipo_documento` int(11) NOT NULL,
  `nombre_archivo` varchar(255) DEFAULT NULL,
  `ruta_archivo` varchar(255) DEFAULT NULL,
  `fecha_subida` datetime DEFAULT current_timestamp(),
  `estado_revision` enum('pendiente','en_revision','aprobado','observado','rechazado') DEFAULT 'pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `documentos_alumno`
--

INSERT INTO `documentos_alumno` (`id_documento_alumno`, `id_proceso_titulacion`, `id_tipo_documento`, `nombre_archivo`, `ruta_archivo`, `fecha_subida`, `estado_revision`) VALUES
(1, 4, 1, '141 gB TIA-00 22.25.pdf', 'documentos/4/141 gB TIA-00 22.25.pdf', '2026-10-05 14:47:34', 'pendiente'),
(2, 4, 3, '142 gD TAD-00 22.25.pdf', 'documentos/4/142 gD TAD-00 22.25.pdf', '2026-10-05 14:47:34', 'pendiente'),
(3, 4, 4, '142 gD TAD-00 22.25.pdf', 'documentos/4/142 gD TAD-00 22.25_jRmlKZd.pdf', '2026-10-05 14:47:34', 'pendiente'),
(4, 4, 5, '141 gB TIA-00 22.25.pdf', 'documentos/4/141 gB TIA-00 22.25_L9OZ4mf.pdf', '2026-10-05 14:47:34', 'pendiente'),
(5, 4, 10, '142 gC TAD-00 22.25.pdf', 'documentos/4/142 gC TAD-00 22.25.pdf', '2026-10-05 14:47:34', 'pendiente'),
(6, 4, 7, '142 gD TAD-00 22.25.pdf', 'documentos/4/142 gD TAD-00 22.25_LZcLdDP.pdf', '2026-10-05 14:47:34', 'pendiente'),
(7, 4, 8, '142 gB TAD-00 22.25.pdf', 'documentos/4/142 gB TAD-00 22.25.pdf', '2026-10-05 14:47:34', 'pendiente'),
(8, 4, 9, '142 gD TAD-00 22.25.pdf', 'documentos/4/142 gD TAD-00 22.25_7bhATAh.pdf', '2026-10-05 14:47:34', 'pendiente'),
(9, 3, 1, '0225 Entrega Calificaciones iNTRODUCCIÓN A LAS MAT. FINANCIERAS (1).docx', 'documentos/3/0225 Entrega Calificaciones iNTRODUCCIÓN A LAS MAT. FINANCIERAS (1).docx', '2026-10-07 14:37:15', 'pendiente'),
(10, 3, 3, '0225 Entrega Calificaciones iNTRODUCCIÓN A LAS MAT. FINANCIERAS (1).docx', 'documentos/3/0225 Entrega Calificaciones iNTRODUCCIÓN A LAS MAT. FINANCIERAS (1)_NoQUpUd.docx', '2026-10-07 14:37:15', 'pendiente'),
(11, 3, 4, '127_0_0_1.sql', 'documentos/3/127_0_0_1.sql', '2026-10-07 14:37:15', 'pendiente'),
(12, 3, 5, '142 gC TAD-00 22.25.pdf', 'documentos/3/142 gC TAD-00 22.25.pdf', '2026-10-07 14:37:15', 'pendiente'),
(13, 3, 10, '142 gC TAD-00 22.25.pdf', 'documentos/3/142 gC TAD-00 22.25_imDWl8M.pdf', '2026-10-07 14:37:15', 'pendiente'),
(14, 3, 7, '142 gC TAD-00 22.25.pdf', 'documentos/3/142 gC TAD-00 22.25_oJ52Ymo.pdf', '2026-10-07 14:37:15', 'pendiente'),
(15, 3, 8, '142 gD TAD-00 22.25.pdf', 'documentos/3/142 gD TAD-00 22.25.pdf', '2026-10-07 14:37:15', 'pendiente'),
(16, 3, 9, '142 gD TAD-00 22.25.pdf', 'documentos/3/142 gD TAD-00 22.25_rfLPGPC.pdf', '2026-10-07 14:37:15', 'pendiente'),
(17, 5, 1, 'ACTA DE NACIMIENTO_Vania Daniela Lavin Velazquez.pdf', 'documentos/5/ACTA DE NACIMIENTO_Vania Daniela Lavin Velazquez_pemuu7j.pdf', '2026-10-16 15:54:44', 'pendiente'),
(18, 5, 2, 'CERTIFICADO_Vania Daniela Lavin Velazquez.pdf', 'documentos/5/CERTIFICADO_Vania Daniela Lavin Velazquez_3eStQdp.pdf', '2026-10-16 15:54:44', 'pendiente'),
(19, 5, 3, 'Historial - LAVIN VELAZQUEZ VANIA DANIELA.xlsx', 'documentos/5/Historial - LAVIN VELAZQUEZ VANIA DANIELA_a9vMccV.xlsx', '2026-10-16 15:54:44', 'pendiente'),
(20, 5, 4, 'COMPROBANTE DE DOMICILIO_Vania Daniela Lavin Velazquez.pdf', 'documentos/5/COMPROBANTE DE DOMICILIO_Vania Daniela Lavin Velazquez_3gqFf51.pdf', '2026-10-16 15:54:44', 'pendiente'),
(21, 5, 5, 'INE_Vania Daniela Lavin Velazquez.pdf', 'documentos/5/INE_Vania Daniela Lavin Velazquez_4HaoEmC.pdf', '2026-10-16 15:54:44', 'pendiente'),
(22, 5, 6, 'CURP_LAVV050713MDFVLNA1.pdf', 'documentos/5/CURP_LAVV050713MDFVLNA1_iJjmFOt.pdf', '2026-10-16 15:54:44', 'pendiente'),
(23, 5, 8, 'COMPROBANTE DE DOMICILIO_Vania Daniela Lavin Velazquez.pdf', 'documentos/5/COMPROBANTE DE DOMICILIO_Vania Daniela Lavin Velazquez_edSDVQM.pdf', '2026-10-16 15:54:44', 'pendiente'),
(24, 5, 9, 'INE_Vania Daniela Lavin Velazquez.pdf', 'documentos/5/INE_Vania Daniela Lavin Velazquez_EnBE1Ar.pdf', '2026-10-16 15:54:44', 'pendiente'),
(25, 5, 10, 'INE_Vania Daniela Lavin Velazquez.pdf', 'documentos/5/INE_Vania Daniela Lavin Velazquez_NL9SEKy.pdf', '2026-10-16 15:54:44', 'pendiente'),
(26, 3, 11, 'estilos.css', 'documentos/3/estilos.css', '2026-10-09 16:29:38', 'pendiente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documentos_requeridos_modalidad`
--

CREATE TABLE `documentos_requeridos_modalidad` (
  `id_documento_requerido` int(11) NOT NULL,
  `id_modalidad` int(11) NOT NULL,
  `id_tipo_documento` int(11) NOT NULL,
  `obligatorio` tinyint(1) DEFAULT 1,
  `orden_visualizacion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `documentos_requeridos_modalidad`
--

INSERT INTO `documentos_requeridos_modalidad` (`id_documento_requerido`, `id_modalidad`, `id_tipo_documento`, `obligatorio`, `orden_visualizacion`) VALUES
(1, 1, 1, 1, 1),
(2, 1, 2, 1, 2),
(3, 1, 3, 1, 3),
(4, 1, 4, 1, 4),
(5, 1, 5, 1, 5),
(6, 1, 6, 1, 6),
(7, 1, 8, 1, 7),
(8, 1, 9, 1, 8),
(9, 1, 10, 1, 9),
(10, 2, 1, 1, 1),
(11, 2, 3, 1, 2),
(12, 2, 4, 1, 3),
(13, 2, 5, 1, 4),
(14, 2, 10, 1, 5),
(15, 2, 7, 1, 6),
(16, 2, 8, 1, 7),
(17, 2, 9, 1, 8),
(18, 3, 1, 1, 1),
(19, 3, 3, 1, 2),
(20, 3, 4, 1, 3),
(21, 3, 5, 1, 4),
(22, 3, 10, 1, 5),
(23, 3, 7, 1, 6),
(24, 3, 8, 1, 7),
(25, 3, 9, 1, 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE `empleados` (
  `id_empleado` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_area` int(11) NOT NULL,
  `nombre` varchar(80) DEFAULT NULL,
  `apellido_paterno` varchar(80) DEFAULT NULL,
  `apellido_materno` varchar(80) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`id_empleado`, `id_usuario`, `id_area`, `nombre`, `apellido_paterno`, `apellido_materno`, `telefono`) VALUES
(2, 11117, 2, 'Laura', 'Hernández', 'Gómez', '5512345678');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modalidades_titulacion`
--

CREATE TABLE `modalidades_titulacion` (
  `id_modalidad` int(11) NOT NULL,
  `id_area` int(11) NOT NULL,
  `nombre_modalidad` varchar(120) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `requisitos` text DEFAULT NULL,
  `estatus` enum('activo','inactivo') DEFAULT 'activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `modalidades_titulacion`
--

INSERT INTO `modalidades_titulacion` (`id_modalidad`, `id_area`, `nombre_modalidad`, `descripcion`, `requisitos`, `estatus`) VALUES
(1, 1, 'Titulación directa', 'Dirigida a egresados que concluyeron sus estudios y están pendientes de obtener su título profesional.', 'Carta de pasante y certificado de licenciatura.', 'activo'),
(2, 1, 'Titulación por experiencia', 'Requiere un currículum vitae que acredite un mínimo de cinco años de experiencia laboral en el área de la carrera.', 'Mínimo cinco años de experiencia laboral comprobable.', 'activo'),
(3, 1, 'Titulación por proyecto', 'Requiere un currículum con mínimo cinco años de experiencia y el desarrollo de un proyecto vinculado a la carrera.', 'Cinco años de experiencia y proyecto profesional.', 'activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `observaciones_documentos`
--

CREATE TABLE `observaciones_documentos` (
  `id_observacion` int(11) NOT NULL,
  `id_documento_alumno` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `observacion` text NOT NULL,
  `fecha_observacion` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `procesos_titulacion`
--

CREATE TABLE `procesos_titulacion` (
  `id_proceso_titulacion` int(11) NOT NULL,
  `id_alumno` int(11) NOT NULL,
  `id_modalidad` int(11) NOT NULL,
  `fecha_inicio` datetime DEFAULT current_timestamp(),
  `estado_general` enum('pendiente','en_revision','observado','aprobado','finalizado') DEFAULT 'pendiente',
  `observaciones_generales` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `procesos_titulacion`
--

INSERT INTO `procesos_titulacion` (`id_proceso_titulacion`, `id_alumno`, `id_modalidad`, `fecha_inicio`, `estado_general`, `observaciones_generales`) VALUES
(3, 6, 2, '2026-10-05 14:39:33', 'pendiente', NULL),
(4, 6, 3, '2026-10-05 14:44:05', 'pendiente', NULL),
(5, 6, 1, '2026-10-05 15:32:56', 'pendiente', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seguimiento_titulacion`
--

CREATE TABLE `seguimiento_titulacion` (
  `id_seguimiento` int(11) NOT NULL,
  `id_proceso_titulacion` int(11) NOT NULL,
  `estado_anterior` varchar(50) DEFAULT NULL,
  `estado_nuevo` varchar(50) DEFAULT NULL,
  `comentario` text DEFAULT NULL,
  `id_usuario` int(11) NOT NULL,
  `fecha_registro` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `seguimiento_titulacion`
--

INSERT INTO `seguimiento_titulacion` (`id_seguimiento`, `id_proceso_titulacion`, `estado_anterior`, `estado_nuevo`, `comentario`, `id_usuario`, `fecha_registro`) VALUES
(3, 5, 'Pendiente', 'Revisión', 'aaaaaaa', 11117, '2026-10-14 14:46:28'),
(4, 3, 'Pendiente', 'Proyecto', 'jjkbjkbjkbjkjkbjkbjkbjkbjkbjkbjkjkbjk', 11117, '2026-10-14 16:10:21'),
(5, 5, 'Revisión', 'Equivalencia de materias', 'sfzxczxfsdggffd<gfgfgdffg', 11117, '2026-10-14 16:25:52'),
(6, 5, 'Equivalencia de materias', 'Revisión', 'rsusrty', 11117, '2026-10-16 15:42:40'),
(7, 5, 'Revisión', 'Entrega', 'bhjkhgj', 11117, '2026-10-17 20:36:06');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_documentos`
--

CREATE TABLE `tipos_documentos` (
  `id_tipo_documento` int(11) NOT NULL,
  `nombre_documento` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `formato_permitido` varchar(100) DEFAULT NULL,
  `tamano_maximo_mb` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipos_documentos`
--

INSERT INTO `tipos_documentos` (`id_tipo_documento`, `nombre_documento`, `descripcion`, `formato_permitido`, `tamano_maximo_mb`) VALUES
(1, 'Acta de nacimiento', NULL, 'pdf', 5.00),
(2, 'Carta de pasante', NULL, 'pdf', 5.00),
(3, 'Certificado de preparatoria', NULL, 'pdf', 5.00),
(4, 'CURP', NULL, 'pdf', 5.00),
(5, 'INE', NULL, 'pdf,jpg,png', 5.00),
(6, 'Certificado de licenciatura', NULL, 'pdf', 5.00),
(7, 'Constancia laboral', NULL, 'pdf', 5.00),
(8, 'Comprobante de domicilio', NULL, 'pdf,jpg,png', 5.00),
(9, 'Fotografías', NULL, 'jpg,png,zip', 10.00),
(10, 'Currículum vitae (CV)', NULL, 'pdf', 5.00),
(11, 'Caso de éxito', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `correo` varchar(120) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `tipo_usuario` enum('alumno','empleado') DEFAULT NULL,
  `estatus` enum('activo','inactivo') DEFAULT 'activo',
  `fecha_registro` datetime DEFAULT current_timestamp(),
  `ultimo_acceso` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `correo`, `contrasena`, `tipo_usuario`, `estatus`, `fecha_registro`, `ultimo_acceso`) VALUES
(11113, 'prueba@icem.edu.mx', '123456', 'alumno', 'activo', '2026-10-05 08:30:51', NULL),
(11117, 'coordinacion2@icem.edu.mx', 'coord123', 'empleado', 'activo', '2026-10-05 09:38:09', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `alumnos`
--
ALTER TABLE `alumnos`
  ADD PRIMARY KEY (`id_alumno`),
  ADD UNIQUE KEY `uq_alumnos_usuario` (`id_usuario`),
  ADD UNIQUE KEY `uq_alumnos_matricula` (`matricula`);

--
-- Indices de la tabla `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`id_area`),
  ADD UNIQUE KEY `uq_areas_nombre` (`nombre_area`);

--
-- Indices de la tabla `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indices de la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indices de la tabla `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indices de la tabla `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indices de la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indices de la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indices de la tabla `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indices de la tabla `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indices de la tabla `documentos_alumno`
--
ALTER TABLE `documentos_alumno`
  ADD PRIMARY KEY (`id_documento_alumno`),
  ADD UNIQUE KEY `uq_doc_proceso_tipo` (`id_proceso_titulacion`,`id_tipo_documento`),
  ADD KEY `idx_doc_tipo` (`id_tipo_documento`);

--
-- Indices de la tabla `documentos_requeridos_modalidad`
--
ALTER TABLE `documentos_requeridos_modalidad`
  ADD PRIMARY KEY (`id_documento_requerido`),
  ADD UNIQUE KEY `uq_requerido_modalidad_tipo` (`id_modalidad`,`id_tipo_documento`),
  ADD KEY `idx_requerido_tipo` (`id_tipo_documento`);

--
-- Indices de la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD PRIMARY KEY (`id_empleado`),
  ADD UNIQUE KEY `uq_empleados_usuario` (`id_usuario`),
  ADD KEY `idx_empleados_area` (`id_area`);

--
-- Indices de la tabla `modalidades_titulacion`
--
ALTER TABLE `modalidades_titulacion`
  ADD PRIMARY KEY (`id_modalidad`),
  ADD UNIQUE KEY `uq_modalidad_nombre` (`nombre_modalidad`),
  ADD KEY `idx_modalidad_area` (`id_area`);

--
-- Indices de la tabla `observaciones_documentos`
--
ALTER TABLE `observaciones_documentos`
  ADD PRIMARY KEY (`id_observacion`),
  ADD KEY `idx_obs_documento` (`id_documento_alumno`),
  ADD KEY `idx_obs_empleado` (`id_empleado`);

--
-- Indices de la tabla `procesos_titulacion`
--
ALTER TABLE `procesos_titulacion`
  ADD PRIMARY KEY (`id_proceso_titulacion`),
  ADD UNIQUE KEY `uq_proceso_alumno_modalidad` (`id_alumno`,`id_modalidad`),
  ADD KEY `idx_proceso_modalidad` (`id_modalidad`);

--
-- Indices de la tabla `seguimiento_titulacion`
--
ALTER TABLE `seguimiento_titulacion`
  ADD PRIMARY KEY (`id_seguimiento`),
  ADD KEY `idx_seg_proceso` (`id_proceso_titulacion`),
  ADD KEY `idx_seg_usuario` (`id_usuario`);

--
-- Indices de la tabla `tipos_documentos`
--
ALTER TABLE `tipos_documentos`
  ADD PRIMARY KEY (`id_tipo_documento`),
  ADD UNIQUE KEY `uq_tipo_documento_nombre` (`nombre_documento`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `uq_usuario_correo` (`correo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `alumnos`
--
ALTER TABLE `alumnos`
  MODIFY `id_alumno` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `areas`
--
ALTER TABLE `areas`
  MODIFY `id_area` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT de la tabla `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `documentos_alumno`
--
ALTER TABLE `documentos_alumno`
  MODIFY `id_documento_alumno` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de la tabla `documentos_requeridos_modalidad`
--
ALTER TABLE `documentos_requeridos_modalidad`
  MODIFY `id_documento_requerido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `empleados`
--
ALTER TABLE `empleados`
  MODIFY `id_empleado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `modalidades_titulacion`
--
ALTER TABLE `modalidades_titulacion`
  MODIFY `id_modalidad` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `observaciones_documentos`
--
ALTER TABLE `observaciones_documentos`
  MODIFY `id_observacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `procesos_titulacion`
--
ALTER TABLE `procesos_titulacion`
  MODIFY `id_proceso_titulacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `seguimiento_titulacion`
--
ALTER TABLE `seguimiento_titulacion`
  MODIFY `id_seguimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tipos_documentos`
--
ALTER TABLE `tipos_documentos`
  MODIFY `id_tipo_documento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11118;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `alumnos`
--
ALTER TABLE `alumnos`
  ADD CONSTRAINT `fk_alumnos_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Filtros para la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Filtros para la tabla `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `documentos_alumno`
--
ALTER TABLE `documentos_alumno`
  ADD CONSTRAINT `fk_doc_proceso` FOREIGN KEY (`id_proceso_titulacion`) REFERENCES `procesos_titulacion` (`id_proceso_titulacion`),
  ADD CONSTRAINT `fk_doc_tipo` FOREIGN KEY (`id_tipo_documento`) REFERENCES `tipos_documentos` (`id_tipo_documento`);

--
-- Filtros para la tabla `documentos_requeridos_modalidad`
--
ALTER TABLE `documentos_requeridos_modalidad`
  ADD CONSTRAINT `fk_requerido_modalidad` FOREIGN KEY (`id_modalidad`) REFERENCES `modalidades_titulacion` (`id_modalidad`),
  ADD CONSTRAINT `fk_requerido_tipo` FOREIGN KEY (`id_tipo_documento`) REFERENCES `tipos_documentos` (`id_tipo_documento`);

--
-- Filtros para la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD CONSTRAINT `fk_empleados_area` FOREIGN KEY (`id_area`) REFERENCES `areas` (`id_area`),
  ADD CONSTRAINT `fk_empleados_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `modalidades_titulacion`
--
ALTER TABLE `modalidades_titulacion`
  ADD CONSTRAINT `fk_modalidad_area` FOREIGN KEY (`id_area`) REFERENCES `areas` (`id_area`);

--
-- Filtros para la tabla `observaciones_documentos`
--
ALTER TABLE `observaciones_documentos`
  ADD CONSTRAINT `fk_obs_documento` FOREIGN KEY (`id_documento_alumno`) REFERENCES `documentos_alumno` (`id_documento_alumno`),
  ADD CONSTRAINT `fk_obs_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`);

--
-- Filtros para la tabla `procesos_titulacion`
--
ALTER TABLE `procesos_titulacion`
  ADD CONSTRAINT `fk_proceso_alumno` FOREIGN KEY (`id_alumno`) REFERENCES `alumnos` (`id_alumno`),
  ADD CONSTRAINT `fk_proceso_modalidad` FOREIGN KEY (`id_modalidad`) REFERENCES `modalidades_titulacion` (`id_modalidad`);

--
-- Filtros para la tabla `seguimiento_titulacion`
--
ALTER TABLE `seguimiento_titulacion`
  ADD CONSTRAINT `fk_seg_proceso` FOREIGN KEY (`id_proceso_titulacion`) REFERENCES `procesos_titulacion` (`id_proceso_titulacion`),
  ADD CONSTRAINT `fk_seg_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
