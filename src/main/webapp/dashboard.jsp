<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Área Personal - DUTS</title>
    <style>
        :root {
            --atena-green: #2f5c35;
            --atena-green-hover: #24492a;
            --atena-light-green: #8cb82b;
            --bg-light: #f4f6f8;
            --text-dark: #2c3e50;
            --text-muted: #606f7b;
            --border-color: #dbe2e8;
            --white: #ffffff;
            --success-bg: #e8f5e9;
            --success-text: #2e7d32;
            --error-bg: #ffebee;
            --error-text: #c62828;
        }

        * { box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; }
        body { background-color: var(--bg-light); color: var(--text-dark); display: flex; flex-direction: column; height: 100vh; overflow: hidden; }

        /* TOP NAVBAR */
        .top-navbar {
            background-color: var(--white);
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 25px;
            border-bottom: 1px solid var(--border-color);
            z-index: 10;
        }
        .top-navbar-left { display: flex; align-items: center; gap: 18px; }
        .nav-icon-menu { font-size: 20px; color: var(--text-muted); cursor: pointer; border: none; background: none; }
        .logo-container { display: flex; align-items: center; gap: 12px; text-decoration: none; cursor: pointer; }
        .logo-container img { height: 38px; }
        .logo-text { color: var(--atena-light-green); font-weight: 800; font-size: 22px; letter-spacing: 0.5px; }
        .logo-subtext { font-size: 11px; color: #888; border-left: 1px solid #ccc; padding-left: 10px; line-height: 1.2; }

        .top-navbar-right { display: flex; align-items: center; gap: 20px; color: var(--text-muted); font-size: 14px; }
        .user-menu { display: flex; align-items: center; gap: 12px; font-weight: 600; color: var(--atena-green); }
        .user-menu img { width: 34px; height: 34px; border-radius: 50%; object-fit: cover; border: 1px solid var(--border-color); }

        /* MAIN LAYOUT */
        .main-wrapper { display: flex; flex: 1; overflow: hidden; }

        /* MAIN WRAPPER & SIDEBAR REDISEÑADO */
        .sidebar {
            width: 270px;
            background: linear-gradient(180deg, #102613 0%, #17361a 35%, #1e4522 100%);
            color: white;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            box-shadow: 4px 0 24px rgba(0, 0, 0, 0.08);
            border-right: 1px solid rgba(255, 255, 255, 0.08);
            position: relative;
        }

        /* PERFIL DE USUARIO EN CABECERA DEL SIDEBAR */
        .sidebar-brand-box {
            padding: 20px 18px 16px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            background: rgba(0, 0, 0, 0.15);
        }
        .sidebar-user-pill {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .sidebar-user-avatar-wrap {
            position: relative;
            width: 44px;
            height: 44px;
            flex-shrink: 0;
        }
        .sidebar-user-avatar-wrap img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--uts-green-light);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }
        .user-live-indicator {
            position: absolute;
            bottom: 1px;
            right: 1px;
            width: 11px;
            height: 11px;
            background: #22c55e;
            border: 2px solid #102613;
            border-radius: 50%;
            box-shadow: 0 0 6px #22c55e;
        }
        .sidebar-user-meta {
            overflow: hidden;
            flex: 1;
        }
        .sidebar-user-name {
            font-size: 13.5px;
            font-weight: 700;
            color: #ffffff;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.3;
        }
        .sidebar-user-tag {
            margin-top: 3px;
        }
        .role-pill {
            font-size: 10.5px;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 12px;
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }
        .role-pill-est {
            background: rgba(140, 184, 43, 0.22);
            color: #c4e477;
            border: 1px solid rgba(140, 184, 43, 0.4);
        }
        .role-pill-admin {
            background: rgba(234, 179, 8, 0.22);
            color: #fef08a;
            border: 1px solid rgba(234, 179, 8, 0.4);
        }

        /* NAVEGACIÓN INSTITUCIONAL */
        .sidebar-nav-container {
            flex: 1;
            padding: 14px 0;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
        }
        .sidebar-nav-section-title {
            font-size: 10.5px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.9px;
            color: rgba(255, 255, 255, 0.42);
            padding: 10px 20px 6px;
        }
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .sidebar-menu li {
            padding: 2px 10px;
        }
        .sidebar-menu a {
            color: rgba(255, 255, 255, 0.78);
            text-decoration: none;
            font-size: 13.5px;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 14px;
            border-radius: 10px;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            font-weight: 500;
            border-left: 3.5px solid transparent;
            position: relative;
        }
        .sidebar-menu a .nav-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 22px;
            height: 22px;
            color: rgba(255, 255, 255, 0.7);
            transition: color 0.2s, transform 0.2s;
            flex-shrink: 0;
        }
        .sidebar-menu a:hover {
            background-color: rgba(255, 255, 255, 0.09);
            color: #ffffff;
            transform: translateX(3px);
        }
        .sidebar-menu a:hover .nav-icon {
            color: #ffffff;
            transform: scale(1.08);
        }
        .sidebar-menu a.active {
            background: linear-gradient(90deg, rgba(140, 184, 43, 0.26) 0%, rgba(140, 184, 43, 0.08) 100%);
            color: #ffffff;
            font-weight: 700;
            border-left: 3.5px solid var(--uts-green-light);
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.12);
        }
        .sidebar-menu a.active .nav-icon {
            color: var(--uts-green-light);
        }
        .sidebar-menu a .active-pip {
            margin-left: auto;
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: var(--uts-green-light);
            box-shadow: 0 0 6px var(--uts-green-light);
        }

        /* WIDGET BILLETERA CIRCULAR EN SIDEBAR */
        .sidebar-wallet-card {
            margin: auto 12px 14px;
            background: rgba(0, 0, 0, 0.25);
            border: 1px solid rgba(255, 255, 255, 0.09);
            border-radius: 14px;
            padding: 14px 15px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
        }
        .sidebar-wallet-card::before {
            content: '';
            position: absolute;
            top: -20px;
            right: -20px;
            width: 70px;
            height: 70px;
            background: radial-gradient(circle, rgba(140, 184, 43, 0.25) 0%, transparent 70%);
            pointer-events: none;
        }
        .sidebar-wallet-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 8px;
        }
        .wallet-badge-pill {
            font-size: 9.5px;
            font-weight: 800;
            letter-spacing: 0.6px;
            color: #c4e477;
            background: rgba(140, 184, 43, 0.18);
            border: 1px solid rgba(140, 184, 43, 0.35);
            padding: 2px 7px;
            border-radius: 10px;
            text-transform: uppercase;
        }
        .sidebar-wallet-label {
            font-size: 11px;
            color: rgba(255, 255, 255, 0.65);
            font-weight: 500;
            margin-bottom: 3px;
        }
        .sidebar-wallet-val {
            font-size: 18px;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.3px;
            display: flex;
            align-items: baseline;
            gap: 4px;
        }
        .sidebar-wallet-symbol {
            font-size: 11px;
            font-weight: 700;
            color: var(--uts-green-light);
        }
        .sidebar-wallet-footer {
            margin-top: 8px;
            padding-top: 8px;
            border-top: 1px solid rgba(255, 255, 255, 0.07);
            font-size: 10.5px;
            color: rgba(255, 255, 255, 0.5);
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .wallet-loc-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: var(--uts-green-light);
            display: inline-block;
        }

        /* PIE DE PÁGINA Y CERRAR SESIÓN */
        .sidebar-footer {
            padding: 14px 14px 18px;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            background: rgba(0, 0, 0, 0.18);
        }
        .sidebar-logout-btn {
            background: rgba(239, 68, 68, 0.12);
            border: 1px solid rgba(239, 68, 68, 0.28);
            color: #fca5a5;
            text-decoration: none;
            font-size: 12.5px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            padding: 10px 14px;
            border-radius: 10px;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .sidebar-logout-btn:hover {
            background: rgba(239, 68, 68, 0.25);
            color: #ffffff;
            border-color: rgba(239, 68, 68, 0.5);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2);
        }
        .sidebar-version-info {
            font-size: 10.5px;
            color: rgba(255, 255, 255, 0.38);
            text-align: center;
            margin-top: 10px;
            letter-spacing: 0.3px;
        }

        /* CONTENT */
        .content-area { flex: 1; padding: 25px 30px; overflow-y: auto; }
        .container { max-width: 1200px; margin: 0 auto; }

        /* NOTIFICATIONS */
        .alert { padding: 14px 18px; border-radius: 4px; margin-bottom: 20px; font-size: 14px; border: 1px solid transparent; }
        .alert-success { background-color: var(--success-bg); color: var(--success-text); border-color: #c8e6c9; }
        .alert-error { background-color: var(--error-bg); color: var(--error-text); border-color: #ffcdd2; }

        /* HEADER CARD */
        .page-header-card {
            background: var(--white);
            padding: 20px 25px;
            border-radius: 4px;
            border: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .user-info-large { display: flex; align-items: center; gap: 20px; }
        .avatar-large { width: 75px; height: 75px; border-radius: 50%; overflow: hidden; border: 2px solid var(--atena-light-green); }
        .avatar-large img { width: 100%; height: 100%; object-fit: cover; }
        .user-titles h1 { font-size: 22px; font-weight: 600; color: var(--text-dark); margin-bottom: 4px; }
        .user-titles p { font-size: 13px; color: var(--text-muted); }
        .role-tag { display: inline-block; padding: 3px 8px; border-radius: 3px; font-size: 11px; font-weight: 700; text-transform: uppercase; margin-top: 5px; }
        .role-admin { background: #ffeaa7; color: #d63031; }
        .role-student { background: #e8f5e9; color: var(--atena-green); }

        /* SECTION CARDS */
        .section-card {
            background: var(--white);
            border: 1px solid var(--border-color);
            border-radius: 4px;
            margin-bottom: 22px;
            overflow: hidden;
        }
        .section-header {
            padding: 14px 20px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #fafbfc;
        }
        .section-title { font-size: 15px; font-weight: 700; color: var(--atena-green); }
        .section-body { padding: 20px; }

        /* BALANCE SUMMARY & NOTICIAS UTS */
        .balance-grid {
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 20px;
            margin-bottom: 24px;
            align-items: stretch;
        }
        @media(max-width: 992px) { 
            .balance-grid { 
                grid-template-columns: 1fr; 
            } 
        }

        .balance-box {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 14px;
            padding: 24px;
            text-align: center;
            box-shadow: var(--card-shadow);
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .balance-label { font-size: 13px; color: var(--text-muted); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; }
        .balance-amount { font-size: 36px; font-weight: 800; color: var(--atena-green); margin: 12px 0 6px; }
        .balance-actions { display: flex; justify-content: center; gap: 10px; margin-top: 15px; }

        .btn-atena {
            background-color: var(--atena-green);
            color: white;
            border: none;
            padding: 10px 18px;
            font-size: 13px;
            font-weight: 600;
            border-radius: 8px;
            text-decoration: none;
            cursor: pointer;
            display: inline-block;
            transition: background 0.2s, transform 0.15s;
        }
        .btn-atena:hover { background-color: var(--atena-green-hover); transform: translateY(-1px); }

        .btn-secondary {
            background-color: #f1f3f5;
            color: var(--text-dark);
            border: 1px solid var(--border-color);
            padding: 10px 16px;
            font-size: 13px;
            font-weight: 600;
            border-radius: 8px;
            text-decoration: none;
            cursor: pointer;
            display: inline-block;
            transition: background 0.2s;
        }
        .btn-secondary:hover { background-color: #e2e6ea; }

        /* CARRUSEL DE NOTICIAS INSTITUCIONALES UTS (100% PURO CSS CONSTANTE) */
        .uts-news-carousel-container {
            position: relative;
            width: 100%;
            min-height: 250px;
            height: 100%;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
            border: 1px solid rgba(47, 92, 53, 0.25);
            background: #142918;
        }

        .uts-carousel-radio {
            display: none;
        }

        .uts-carousel-viewport {
            position: relative;
            width: 100%;
            height: 100%;
            min-height: 250px;
            overflow: hidden;
        }

        .uts-carousel-track {
            display: flex;
            width: 400%;
            height: 100%;
            min-height: 250px;
            transition: transform 0.7s cubic-bezier(0.4, 0, 0.2, 1);
            animation: utsCarouselAutoSlide 24s cubic-bezier(0.65, 0, 0.35, 1) infinite;
        }

        .uts-news-carousel-container:hover .uts-carousel-track {
            animation-play-state: paused;
        }

        #c-slide-1:checked ~ .uts-carousel-viewport .uts-carousel-track {
            animation: none;
            transform: translateX(0%);
        }
        #c-slide-2:checked ~ .uts-carousel-viewport .uts-carousel-track {
            animation: none;
            transform: translateX(-25%);
        }
        #c-slide-3:checked ~ .uts-carousel-viewport .uts-carousel-track {
            animation: none;
            transform: translateX(-50%);
        }
        #c-slide-4:checked ~ .uts-carousel-viewport .uts-carousel-track {
            animation: none;
            transform: translateX(-75%);
        }

        @keyframes utsCarouselAutoSlide {
            0%, 20% {
                transform: translateX(0%);
            }
            25%, 45% {
                transform: translateX(-25%);
            }
            50%, 70% {
                transform: translateX(-50%);
            }
            75%, 95% {
                transform: translateX(-75%);
            }
            100% {
                transform: translateX(0%);
            }
        }

        .uts-slide {
            width: 25%;
            position: relative;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 24px 28px;
            color: #ffffff;
            box-sizing: border-box;
        }

        .uts-slide-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(10, 25, 12, 0.15) 0%, rgba(10, 25, 12, 0.58) 45%, rgba(6, 16, 8, 0.94) 100%);
            pointer-events: none;
        }

        .uts-slide-content {
            position: relative;
            z-index: 2;
            max-width: 95%;
        }

        .uts-slide-badge-row {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
            flex-wrap: wrap;
        }

        .uts-news-pill {
            background: rgba(140, 184, 43, 0.28);
            border: 1px solid rgba(140, 184, 43, 0.55);
            color: #d8f58c;
            font-size: 10px;
            font-weight: 800;
            padding: 3px 10px;
            border-radius: 20px;
            letter-spacing: 0.6px;
            text-transform: uppercase;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .carousel-live-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: #8cb82b;
            box-shadow: 0 0 8px #8cb82b;
            display: inline-block;
        }

        .uts-news-category {
            font-size: 10.5px;
            font-weight: 700;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            color: rgba(255, 255, 255, 0.78);
        }

        .uts-slide-title {
            font-size: 19px;
            font-weight: 800;
            line-height: 1.25;
            margin: 0 0 6px 0;
            color: #ffffff;
            text-shadow: 0 2px 6px rgba(0, 0, 0, 0.8);
            letter-spacing: -0.2px;
        }

        .uts-slide-desc {
            font-size: 12.5px;
            line-height: 1.45;
            color: rgba(255, 255, 255, 0.88);
            margin: 0 0 8px 0;
            text-shadow: 0 1px 4px rgba(0, 0, 0, 0.9);
            max-width: 620px;
        }

        .uts-slide-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 4px;
        }

        .uts-slide-tag {
            font-size: 11px;
            color: #a3e635;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .uts-carousel-indicators {
            position: absolute;
            bottom: 14px;
            right: 20px;
            z-index: 5;
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .uts-carousel-dot {
            display: inline-block;
            width: 18px;
            height: 5px;
            border-radius: 4px;
            background: rgba(255, 255, 255, 0.35);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .uts-carousel-dot:hover {
            background: rgba(255, 255, 255, 0.8);
        }

        #c-slide-1:checked ~ .uts-carousel-indicators label[for="c-slide-1"],
        #c-slide-2:checked ~ .uts-carousel-indicators label[for="c-slide-2"],
        #c-slide-3:checked ~ .uts-carousel-indicators label[for="c-slide-3"],
        #c-slide-4:checked ~ .uts-carousel-indicators label[for="c-slide-4"] {
            background: #8cb82b;
            width: 28px;
            box-shadow: 0 0 8px rgba(140, 184, 43, 0.6);
        }

        .uts-carousel-hint {
            position: absolute;
            top: 12px;
            right: 14px;
            z-index: 5;
            background: rgba(0, 0, 0, 0.45);
            backdrop-filter: blur(4px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: rgba(255, 255, 255, 0.7);
            font-size: 9.5px;
            font-weight: 600;
            padding: 3px 8px;
            border-radius: 12px;
            letter-spacing: 0.4px;
            pointer-events: none;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        /* REQUISITO DE GRADUACIÓN UTS (70.000 DUTS) */
        .grad-requirement-card {
            background: linear-gradient(135deg, #1b3d21 0%, #2f5c35 100%);
            border-radius: 12px;
            padding: 22px 26px;
            color: #ffffff;
            margin-bottom: 24px;
            box-shadow: 0 4px 20px rgba(27, 61, 33, 0.18);
            position: relative;
            overflow: hidden;
        }
        .grad-requirement-card::after {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 180px;
            height: 180px;
            background: radial-gradient(circle, rgba(140, 184, 43, 0.25) 0%, transparent 70%);
            pointer-events: none;
        }
        .grad-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
            flex-wrap: wrap;
            gap: 10px;
        }
        .grad-badge {
            background: rgba(140, 184, 43, 0.25);
            border: 1px solid rgba(140, 184, 43, 0.5);
            color: #c4e477;
            font-size: 11px;
            font-weight: 800;
            padding: 4px 12px;
            border-radius: 20px;
            letter-spacing: 0.6px;
            text-transform: uppercase;
        }
        .grad-target-num {
            font-size: 14px;
            font-weight: 700;
            color: rgba(255, 255, 255, 0.9);
        }
        .grad-card-title {
            font-size: 20px;
            font-weight: 800;
            margin-bottom: 6px;
            letter-spacing: -0.3px;
        }
        .grad-card-desc {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 16px;
            max-width: 750px;
            line-height: 1.45;
        }
        .grad-progress-wrap {
            margin-bottom: 14px;
        }
        .grad-progress-labels {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
            color: rgba(255, 255, 255, 0.9);
        }
        .grad-progress-bar-bg {
            height: 12px;
            background: rgba(0, 0, 0, 0.28);
            border-radius: 20px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.12);
        }
        .grad-progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #8cb82b 0%, #a3e635 100%);
            border-radius: 20px;
            transition: width 0.4s ease;
            box-shadow: 0 0 10px rgba(140, 184, 43, 0.6);
        }
        .grad-meta-stats {
            display: flex;
            align-items: center;
            gap: 20px;
            font-size: 12.5px;
            flex-wrap: wrap;
        }
        .grad-stat-pill {
            background: rgba(0, 0, 0, 0.2);
            padding: 6px 14px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.08);
        }
        .grad-stat-pill strong {
            color: #8cb82b;
        }

        /* PROMEDIOS DE DUTS (REQUERIMIENTO 2.3) */
        .averages-section {
            margin-bottom: 25px;
        }
        .averages-section-title {
            font-size: 14px;
            font-weight: 800;
            color: var(--text-dark);
            text-transform: uppercase;
            letter-spacing: 0.6px;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .averages-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 16px;
        }
        .average-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 16px 18px;
            box-shadow: var(--card-shadow);
            transition: transform 0.2s, box-shadow 0.2s;
            position: relative;
            overflow: hidden;
        }
        .average-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.06);
        }
        .avg-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 8px;
        }
        .avg-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .avg-icon {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            background: #f0fdf4;
            color: #16a34a;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .avg-amount {
            font-size: 20px;
            font-weight: 800;
            color: var(--text-dark);
            letter-spacing: -0.4px;
            margin-bottom: 4px;
        }
        .avg-unit {
            font-size: 12px;
            font-weight: 700;
            color: var(--uts-green);
            margin-left: 3px;
        }
        .avg-hint {
            font-size: 11px;
            color: var(--text-muted);
        }

        /* EVENTS GRID */
        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
            gap: 20px;
        }
        .event-card {
            border: 1px solid var(--border-color);
            border-radius: 4px;
            overflow: hidden;
            background: #ffffff;
            display: flex;
            flex-direction: column;
        }
        .event-img {
            height: 130px;
            background-size: cover;
            background-position: center;
            position: relative;
        }
        .event-category {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(47, 92, 53, 0.9);
            color: white;
            font-size: 11px;
            font-weight: 600;
            padding: 3px 8px;
            border-radius: 3px;
        }
        .event-content { padding: 15px; flex: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .event-title { font-size: 15px; font-weight: 700; color: var(--atena-green); margin-bottom: 6px; }
        .event-desc { font-size: 12px; color: var(--text-muted); line-height: 1.4; margin-bottom: 12px; }
        .event-meta { font-size: 11px; color: #777; margin-bottom: 12px; }
        .event-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 10px;
            border-top: 1px solid #eee;
        }
        .reward-tag {
            font-size: 12px;
            font-weight: 700;
            color: var(--atena-green);
            background: #eef7ee;
            padding: 4px 8px;
            border-radius: 3px;
            border: 1px solid #d4ecd4;
        }

        /* MOVEMENTS TABLE */
        .table-responsive { width: 100%; overflow-x: auto; }
        .styled-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            text-align: left;
        }
        .styled-table th {
            background-color: #f8f9fa;
            color: var(--text-muted);
            font-weight: 600;
            padding: 12px 15px;
            border-bottom: 2px solid var(--border-color);
        }
        .styled-table td {
            padding: 12px 15px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }
        .badge-ingreso {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 11px;
            font-weight: 700;
        }
        .badge-egreso {
            background: #ffebee;
            color: #c62828;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 11px;
            font-weight: 700;
        }
        .amount-pos { color: #2e7d32; font-weight: 700; }
        .amount-neg { color: #c62828; font-weight: 700; }
        .empty-state { text-align: center; color: var(--text-muted); padding: 30px; font-size: 13px; }

        .form-inline { display: inline; }
    </style>
</head>
<body>

    <!-- TOP NAVBAR -->
    <header class="top-navbar">
        <div class="top-navbar-left">
            <button class="nav-icon-menu" aria-label="Menú">&#9776;</button>
            <a href="${pageContext.request.contextPath}/dashboard" class="logo-container" title="Ir a Inicio">
                <img src="${pageContext.request.contextPath}/assets/images/logouts.png" alt="DUTS UTS">
                <span class="logo-text">DUTS</span>
                <span class="logo-subtext">Plataforma Financiera Institucional</span>
            </a>
        </div>
        <div class="top-navbar-right">
            <span>Portal Académico UTS</span>
            <a href="${pageContext.request.contextPath}/perfil" class="user-menu" style="text-decoration: none;">
                <span><c:out value="${sessionScope.usuario.nombreCompleto}"/></span>
                <img src="${pageContext.request.contextPath}/assets/images/${sessionScope.usuario.fotoPerfil}" alt="Avatar">
            </a>
        </div>
    </header>

    <!-- MAIN WRAPPER -->
    <div class="main-wrapper">
        
        <!-- SIDEBAR INSTITUCIONAL REDISEÑADO -->
        <aside class="sidebar">
            <!-- CABECERA: PERFIL DE USUARIO -->
            <div class="sidebar-brand-box">
                <div class="sidebar-user-pill">
                    <div class="sidebar-user-avatar-wrap">
                        <img src="${pageContext.request.contextPath}/assets/images/${not empty sessionScope.usuario.fotoPerfil ? sessionScope.usuario.fotoPerfil : 'avatar.jpg'}" alt="Avatar">
                        <span class="user-live-indicator" title="Sesión activa"></span>
                    </div>
                    <div class="sidebar-user-meta">
                        <div class="sidebar-user-name" title="${sessionScope.usuario.nombreCompleto}">
                            <c:out value="${sessionScope.usuario.nombreCompleto}"/>
                        </div>
                        <div class="sidebar-user-tag">
                            <c:choose>
                                <c:when test="${sessionScope.usuario.rolId == 2}">
                                    <span class="role-pill role-pill-admin">Admin UTS</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="role-pill role-pill-est">Estudiante</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- NAVEGACIÓN PRINCIPAL -->
            <div class="sidebar-nav-container">
                <div class="sidebar-nav-section-title">Menú Principal</div>
                <ul class="sidebar-menu">
                    <li>
                        <a href="${pageContext.request.contextPath}/dashboard" class="active">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                            </span>
                            <span>Área personal</span>
                            <span class="active-pip"></span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/perfil">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                            </span>
                            <span>Mi Perfil</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/transferencias">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="7" y1="17" x2="17" y2="7"></line><polyline points="7 7 17 7 17 17"></polyline></svg>
                            </span>
                            <span>Transferencias DUTS</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/eventos">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            </span>
                            <span>Eventos y Recompensas</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/movimientos">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                            </span>
                            <span>Historial y Facturas</span>
                        </a>
                    </li>
                    <c:if test="${sessionScope.usuario.rolId == 2}">
                        <li>
                            <a href="${pageContext.request.contextPath}/eventos" style="background: rgba(234, 179, 8, 0.18); border-left-color: #facc15;">
                                <span class="nav-icon" style="color: #facc15;">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                                </span>
                                <span>Gestión CRUD Eventos</span>
                            </a>
                        </li>
                    </c:if>
                </ul>

                <!-- WIDGET BILLETERA CIRCULAR EN SIDEBAR -->
                <div class="sidebar-wallet-card">
                    <div class="sidebar-wallet-top">
                        <span class="wallet-badge-pill">ECONOMÍA CIRCULAR</span>
                        <span class="wallet-spark-icon">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#8cb82b" stroke-width="2.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
                        </span>
                    </div>
                    <div class="sidebar-wallet-label">Saldo en Billetera</div>
                    <div class="sidebar-wallet-val">
                        <c:choose>
                            <c:when test="${not empty saldo}">
                                <fmt:formatNumber value="${saldo}" minFractionDigits="2" maxFractionDigits="2"/>
                            </c:when>
                            <c:otherwise>0.00</c:otherwise>
                        </c:choose>
                        <span class="sidebar-wallet-symbol">DUTS</span>
                    </div>
                    <div class="sidebar-wallet-footer">
                        <span class="wallet-loc-dot"></span> Sede Bucaramanga
                    </div>
                </div>
            </div>

            <!-- PIE DE PÁGINA DEL SIDEBAR -->
            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout-btn">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                    <span>Cerrar sesión segura</span>
                </a>
                <div class="sidebar-version-info">Plataforma DUTS • v2.4</div>
            </div>
        </aside>

        <!-- CONTENT AREA -->
        <main class="content-area">
            <div class="container">
                
                <!-- FLASH MESSAGES -->
                <c:if test="${not empty flashSuccess}">
                    <div class="alert alert-success">
                        <strong>Operación exitosa:</strong> <c:out value="${flashSuccess}" />
                    </div>
                </c:if>
                <c:if test="${not empty flashError}">
                    <div class="alert alert-error">
                        <strong>Aviso:</strong> <c:out value="${flashError}" />
                    </div>
                </c:if>

                <!-- HEADER CARD -->
                <div class="page-header-card">
                    <div class="user-info-large">
                        <div class="avatar-large">
                            <img src="${pageContext.request.contextPath}/assets/images/${sessionScope.usuario.fotoPerfil}" alt="Avatar">
                        </div>
                        <div class="user-titles">
                            <h1><c:out value="${sessionScope.usuario.nombreCompleto}"/>: Área personal</h1>
                            <p>Código: <c:out value="${sessionScope.usuario.codigoEstudiantil}"/> | Programa: <c:out value="${sessionScope.usuario.programaAcademico}"/> (Semestre <c:out value="${sessionScope.usuario.semestre}"/>)</p>
                            <c:choose>
                                <c:when test="${sessionScope.usuario.rolId == 2}">
                                    <span class="role-tag role-admin">Administrador del Sistema</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="role-tag role-student">Estudiante Activo</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/transferencias" class="btn-atena">Transferir DUTS</a>
                    </div>
                </div>

                <!-- REQUISITO DE GRADUACIÓN INSTITUCIONAL (70.000 DUTS) -->
                <div class="grad-requirement-card">
                    <div class="grad-card-header">
                        <span class="grad-badge">Requisito Obligatorio de Grado UTS</span>
                        <span class="grad-target-num">Meta Institucional: 70.000,00 DUTS</span>
                    </div>
                    <div class="grad-card-title">Avance hacia el Requisito de Graduación</div>
                    <div class="grad-card-desc">
                        Como parte de la propuesta institucional, cada estudiante debe acumular <strong>70.000 DUTS</strong> 
                        participando en eventos académicos, deportivos y proyectos para cumplir con el requisito de graduación.
                    </div>
                    <div class="grad-progress-wrap">
                        <div class="grad-progress-labels">
                            <span>Progreso Actual: <fmt:formatNumber value="${metricas.progresoGraduacion}" minFractionDigits="1" maxFractionDigits="1"/>%</span>
                            <span><fmt:formatNumber value="${saldo}" minFractionDigits="2" maxFractionDigits="2"/> / 70.000,00 DUTS</span>
                        </div>
                        <div class="grad-progress-bar-bg">
                            <div class="grad-progress-bar-fill" style="width: ${metricas.progresoGraduacion}%;"></div>
                        </div>
                    </div>
                    <div class="grad-meta-stats">
                        <div class="grad-stat-pill">
                            DUTS Acumulados: <strong><fmt:formatNumber value="${saldo}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                        </div>
                        <div class="grad-stat-pill">
                            Faltante para Grado: <strong><fmt:formatNumber value="${metricas.faltanteGraduacion}" minFractionDigits="2" maxFractionDigits="2"/> DUTS</strong>
                        </div>
                        <div class="grad-stat-pill">
                            Estado: <strong>${metricas.progresoGraduacion >= 100.0 ? 'Cumplido con Éxito' : 'En Acumulación Activa'}</strong>
                        </div>
                    </div>
                </div>

                <!-- RESUMEN DE SALDO -->
                <div class="balance-grid">
                    <div class="balance-box">
                        <div class="balance-label">Saldo Disponible en tu Billetera DUTS</div>
                        <div class="balance-amount">
                            <fmt:formatNumber value="${saldo}" type="number" minFractionDigits="2" maxFractionDigits="2"/> DUTS
                        </div>
                        <p style="font-size: 12px; color: var(--text-muted); margin-bottom: 15px;">Moneda institucional para eventos, cafetería y estímulos</p>
                        <div class="balance-actions">
                            <a href="${pageContext.request.contextPath}/transferencias" class="btn-atena">Enviar DUTS</a>
                            
                            <form action="${pageContext.request.contextPath}/dashboard" method="POST" class="form-inline">
                                <input type="hidden" name="action" value="recargar_estimulo">
                                <button type="submit" class="btn-secondary" title="Acreditar 5,000 DUTS de prueba a tu saldo">+ Recargar Estímulo (5,000)</button>
                            </form>
                        </div>
                    </div>

                    <!-- CARRUSEL DE NOTICIAS INSTITUCIONALES UTS (100% CONSTANTE) -->
                    <div class="uts-news-carousel-container" title="Pasa el cursor sobre las noticias para pausar la lectura">
                        <!-- Controles de selección de diapositivas -->
                        <input type="radio" name="uts-carousel-select" id="c-slide-1" class="uts-carousel-radio" checked>
                        <input type="radio" name="uts-carousel-select" id="c-slide-2" class="uts-carousel-radio">
                        <input type="radio" name="uts-carousel-select" id="c-slide-3" class="uts-carousel-radio">
                        <input type="radio" name="uts-carousel-select" id="c-slide-4" class="uts-carousel-radio">

                        <div class="uts-carousel-hint">
                            <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="10" y1="15" x2="10" y2="9"></line><line x1="14" y1="15" x2="14" y2="9"></line></svg>
                            <span>Pausar al pasar el cursor</span>
                        </div>

                        <div class="uts-carousel-viewport">
                            <div class="uts-carousel-track">
                                <!-- DIAPOSITIVA 1: CAMPUS CENTRAL Y ESTUDIANTES -->
                                <div class="uts-slide" style="background-image: url('${pageContext.request.contextPath}/assets/images/uts_campus_estudiantes.png');">
                                    <div class="uts-slide-overlay"></div>
                                    <div class="uts-slide-content">
                                        <div class="uts-slide-badge-row">
                                            <span class="uts-news-pill"><span class="carousel-live-dot"></span> NOTICIA OFICIAL</span>
                                            <span class="uts-news-category">Campus Bucaramanga • UTS</span>
                                        </div>
                                        <div class="uts-slide-title">Unidades Tecnol&oacute;gicas de Santander &iexcl;Lo Hacemos Posible!</div>
                                        <div class="uts-slide-desc">
                                            Abiertas las convocatorias para semilleros de investigaci&oacute;n, pasant&iacute;as y becas por excelencia para estudiantes ute&iacute;stas activos.
                                        </div>
                                        <div class="uts-slide-footer">
                                            <span class="uts-slide-tag">
                                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                                Comunidad &amp; Vida Estudiantil
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <!-- DIAPOSITIVA 2: PLAZOLETA Y EDIFICIO CENTRAL UTS -->
                                <div class="uts-slide" style="background-image: url('${pageContext.request.contextPath}/assets/images/uts_campus_plazoleta.png');">
                                    <div class="uts-slide-overlay"></div>
                                    <div class="uts-slide-content">
                                        <div class="uts-slide-badge-row">
                                            <span class="uts-news-pill"><span class="carousel-live-dot"></span> INFRAESTRUCTURA</span>
                                            <span class="uts-news-category">Plazoleta &amp; Edificio Central</span>
                                        </div>
                                        <div class="uts-slide-title">Nuevos Espacios Acad&eacute;micos y Salas Digitales UTS</div>
                                        <div class="uts-slide-desc">
                                            Aprovecha los renovados laboratorios tecnol&oacute;gicos, auditorios y zonas colaborativas de estudio en la sede Bucaramanga.
                                        </div>
                                        <div class="uts-slide-footer">
                                            <span class="uts-slide-tag">
                                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><line x1="3" y1="9" x2="21" y2="9"></line><line x1="9" y1="21" x2="9" y2="9"></line></svg>
                                                Instalaciones Tecnol&oacute;gicas UTS
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <!-- DIAPOSITIVA 3: REQUISITO DE GRADO 70.000 DUTS -->
                                <div class="uts-slide" style="background-image: url('${pageContext.request.contextPath}/assets/images/banner-dashboard.jpg');">
                                    <div class="uts-slide-overlay"></div>
                                    <div class="uts-slide-content">
                                        <div class="uts-slide-badge-row">
                                            <span class="uts-news-pill"><span class="carousel-live-dot"></span> REQUISITO DE GRADO</span>
                                            <span class="uts-news-category">Econom&iacute;a Digital DUTS</span>
                                        </div>
                                        <div class="uts-slide-title">Meta Institucional: Acumula 70.000 DUTS para Graduarte</div>
                                        <div class="uts-slide-desc">
                                            Participa en conferencias, desaf&iacute;os y talleres formativos institucionales para asegurar tu meta de grado en la plataforma DUTS.
                                        </div>
                                        <div class="uts-slide-footer">
                                            <span class="uts-slide-tag">
                                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="8" r="7"></circle><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline></svg>
                                                Reglamento &amp; Certificaci&oacute;n de Grado
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <!-- DIAPOSITIVA 4: BIENESTAR Y TORNEO ASCUN / RALLY -->
                                <div class="uts-slide" style="background-image: url('${pageContext.request.contextPath}/assets/images/evento-rally.jpg');">
                                    <div class="uts-slide-overlay"></div>
                                    <div class="uts-slide-content">
                                        <div class="uts-slide-badge-row">
                                            <span class="uts-news-pill"><span class="carousel-live-dot"></span> DEPORTES &amp; BIENESTAR</span>
                                            <span class="uts-news-category">Juegos ASCUN y Rally de Observaci&oacute;n</span>
                                        </div>
                                        <div class="uts-slide-title">Rally de Observaci&oacute;n UTS y Torneo Deportivo ASCUN</div>
                                        <div class="uts-slide-desc">
                                            Inscr&iacute;bete desde la secci&oacute;n Eventos y obt&eacute;n recompensas de hasta +3.500 DUTS en tu balance mientras representas a tu facultad.
                                        </div>
                                        <div class="uts-slide-footer">
                                            <span class="uts-slide-tag">
                                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                                Recompensas y M&eacute;rito Ute&iacute;sta
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Indicadores interactivos (Bullets / P&iacute;ldoras) -->
                        <div class="uts-carousel-indicators">
                            <label for="c-slide-1" class="uts-carousel-dot" title="Noticia 1: Lo Hacemos Posible"></label>
                            <label for="c-slide-2" class="uts-carousel-dot" title="Noticia 2: Campus Bucaramanga"></label>
                            <label for="c-slide-3" class="uts-carousel-dot" title="Noticia 3: Meta 70.000 DUTS"></label>
                            <label for="c-slide-4" class="uts-carousel-dot" title="Noticia 4: Torneo ASCUN y Rally"></label>
                        </div>
                    </div>
                </div>

                <!-- PROMEDIOS DE DUTS (REQUERIMIENTO 2.3) -->
                <div class="averages-section">
                    <div class="averages-section-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline><polyline points="17 6 23 6 23 12"></polyline></svg>
                        <span>Métricas y Promedios de Acumulación DUTS (Semana, Mes, Año y Semestre)</span>
                    </div>
                    <div class="averages-grid">
                        <div class="average-card">
                            <div class="avg-card-header">
                                <span class="avg-label">Promedio Semanal</span>
                                <div class="avg-icon">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                </div>
                            </div>
                            <div class="avg-amount">
                                <fmt:formatNumber value="${metricas.promedioSemanal}" minFractionDigits="2" maxFractionDigits="2"/><span class="avg-unit">DUTS</span>
                            </div>
                            <div class="avg-hint">Ritmo por semana activa</div>
                        </div>

                        <div class="average-card">
                            <div class="avg-card-header">
                                <span class="avg-label">Promedio Mensual</span>
                                <div class="avg-icon">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                </div>
                            </div>
                            <div class="avg-amount">
                                <fmt:formatNumber value="${metricas.promedioMensual}" minFractionDigits="2" maxFractionDigits="2"/><span class="avg-unit">DUTS</span>
                            </div>
                            <div class="avg-hint">Promedio cada 30 días</div>
                        </div>

                        <div class="average-card">
                            <div class="avg-card-header">
                                <span class="avg-label">Promedio Semestral</span>
                                <div class="avg-icon">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                                </div>
                            </div>
                            <div class="avg-amount">
                                <fmt:formatNumber value="${metricas.promedioSemestral}" minFractionDigits="2" maxFractionDigits="2"/><span class="avg-unit">DUTS</span>
                            </div>
                            <div class="avg-hint">Por ciclo académico cursado</div>
                        </div>

                        <div class="average-card">
                            <div class="avg-card-header">
                                <span class="avg-label">Promedio Anual</span>
                                <div class="avg-icon">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                </div>
                            </div>
                            <div class="avg-amount">
                                <fmt:formatNumber value="${metricas.promedioAnual}" minFractionDigits="2" maxFractionDigits="2"/><span class="avg-unit">DUTS</span>
                            </div>
                            <div class="avg-hint">Proyección anual (2 semestres)</div>
                        </div>
                    </div>
                </div>

                <!-- EVENTOS ACTIVOS CONEXIÓN BD -->
                <div class="section-card">
                    <div class="section-header">
                        <span class="section-title">Eventos Institucionales Disponibles</span>
                        <a href="${pageContext.request.contextPath}/eventos" class="btn-secondary" style="font-size: 12px; padding: 5px 12px;">Ver todos los eventos</a>
                    </div>
                    <div class="section-body">
                        <c:choose>
                            <c:when test="${not empty eventos}">
                                <div class="events-grid">
                                    <c:forEach items="${eventos}" var="ev">
                                        <div class="event-card">
                                            <div class="event-img" style="background-image: url('${pageContext.request.contextPath}/assets/images/${ev.imagenUrl}');">
                                                <span class="event-category"><c:out value="${ev.categoria}"/></span>
                                            </div>
                                            <div class="event-content">
                                                <div>
                                                    <h4 class="event-title"><c:out value="${ev.nombre}"/></h4>
                                                    <p class="event-desc"><c:out value="${ev.descripcion}"/></p>
                                                    <div style="margin-top: 6px; font-size: 11px; color: #64748b; display: flex; flex-direction: column; gap: 2px;">
                                                        <div><strong>Lugar:</strong> <c:out value="${ev.lugar}"/> | <strong>Cupos:</strong> <c:out value="${ev.cupos}"/></div>
                                                        <div style="color: #0369a1;"><strong>Dirección:</strong> <c:out value="${ev.direccion}"/></div>
                                                    </div>
                                                </div>
                                                <div class="event-footer">
                                                    <span class="reward-tag">+<fmt:formatNumber value="${ev.recompensaDuts}" minFractionDigits="0"/> DUTS</span>
                                                    
                                                    <c:choose>
                                                        <c:when test="${ev.inscrito}">
                                                            <form action="${pageContext.request.contextPath}/dashboard" method="POST" class="form-inline">
                                                                <input type="hidden" name="action" value="reclamar_recompensa">
                                                                <input type="hidden" name="eventoId" value="${ev.id}">
                                                                <button type="submit" class="btn-atena" style="font-size: 11px; padding: 5px 10px; background-color: var(--atena-light-green);">Reclamar DUTS</button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form action="${pageContext.request.contextPath}/dashboard" method="POST" class="form-inline">
                                                                <input type="hidden" name="action" value="inscribir_evento">
                                                                <input type="hidden" name="eventoId" value="${ev.id}">
                                                                <button type="submit" class="btn-secondary" style="font-size: 11px; padding: 5px 10px;">Inscribirme</button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">No hay eventos activos registrados en este momento.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- MOVIMIENTOS RECIENTES CONEXIÓN BD -->
                <div class="section-card">
                    <div class="section-header">
                        <span class="section-title">Últimos Movimientos Financieros</span>
                        <a href="${pageContext.request.contextPath}/movimientos" class="btn-secondary" style="font-size: 12px; padding: 5px 12px;">Ver historial completo</a>
                    </div>
                    <div class="section-body" style="padding: 0;">
                        <c:choose>
                            <c:when test="${not empty movimientos}">
                                <div class="table-responsive">
                                    <table class="styled-table">
                                        <thead>
                                            <tr>
                                                <th>Referencia</th>
                                                <th>Tipo</th>
                                                <th>Descripción</th>
                                                <th>Fecha y Hora</th>
                                                <th style="text-align: right;">Monto</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${movimientos}" var="m">
                                                <tr>
                                                    <td><code><c:out value="${m.referencia}"/></code></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${m.tipo == 'INGRESO'}">
                                                                <span class="badge-ingreso">INGRESO</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-egreso">EGRESO</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><c:out value="${m.descripcion}"/></td>
                                                    <td><fmt:formatDate value="${m.fechaHora}" pattern="yyyy-MM-dd HH:mm"/></td>
                                                    <td style="text-align: right;">
                                                        <c:choose>
                                                            <c:when test="${m.tipo == 'INGRESO'}">
                                                                <span class="amount-pos">+<fmt:formatNumber value="${m.monto}" minFractionDigits="2"/> DUTS</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="amount-neg">-<fmt:formatNumber value="${m.monto}" minFractionDigits="2"/> DUTS</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">No tienes movimientos financieros registrados.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>
        </main>
    </div>

</body>
</html>
