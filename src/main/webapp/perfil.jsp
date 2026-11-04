<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, viewport-fit=cover">
    <title>Perfil de Usuario - DUTS UTS</title>
    
    <meta name="theme-color" content="#1b3d21">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="manifest" href="${pageContext.request.contextPath}/manifest.json">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/images/favicon.svg">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/assets/images/favicon.svg">
    <style>
        :root {
            --uts-green: #2f5c35;
            --uts-green-dark: #1b3d21;
            --uts-green-light: #8cb82b;
            --uts-green-soft: #f0f7f1;
            --bg-body: #f4f6f9;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border-light: #e2e8f0;
            --white: #ffffff;
            --card-shadow: 0 4px 16px -2px rgba(15, 23, 42, 0.06), 0 2px 6px -2px rgba(15, 23, 42, 0.04);
            --danger: #ef4444;
            --danger-bg: #fef2f2;
            --success: #16a34a;
            --success-bg: #f0fdf4;
        }

        * { box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; }
        body { background-color: var(--bg-body); color: var(--text-main); display: flex; flex-direction: column; min-height: 100vh; }

        .top-navbar {
            background-color: var(--white);
            height: 62px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 28px;
            border-bottom: 1px solid var(--border-light);
            position: sticky;
            top: 0;
            z-index: 50;
        }
        .top-navbar-left { display: flex; align-items: center; gap: 16px; }
        .logo-container { display: flex; align-items: center; gap: 12px; text-decoration: none; cursor: pointer; }
        .logo-container img { height: 38px; }
        .logo-text { color: var(--uts-green-light); font-weight: 800; font-size: 22px; letter-spacing: 0.5px; }
        .logo-subtext { font-size: 11px; color: #888; border-left: 1px solid #cbd5e1; padding-left: 10px; line-height: 1.2; }

        .top-navbar-right { display: flex; align-items: center; gap: 24px; color: var(--text-muted); font-size: 14px; }
        .user-menu { display: flex; align-items: center; gap: 12px; font-weight: 600; color: var(--uts-green); text-decoration: none; padding: 4px 10px; border-radius: 6px; }
        .user-menu img { width: 34px; height: 34px; border-radius: 50%; object-fit: cover; border: 2px solid var(--uts-green-light); }

        .main-wrapper { display: flex; flex: 1; }

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

        .content-area { flex: 1; padding: 30px; overflow-y: auto; }
        .container { max-width: 1200px; margin: 0 auto; }

        .page-header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        .page-title-box h1 { font-size: 24px; font-weight: 700; color: var(--text-main); margin-bottom: 4px; }
        .page-title-box p { font-size: 13px; color: var(--text-muted); }

        .alert { padding: 14px 18px; border-radius: 8px; margin-bottom: 22px; font-size: 14px; }
        .alert-success { background-color: var(--success-bg); color: var(--success); border: 1px solid #bbf7d0; }
        .alert-error { background-color: var(--danger-bg); color: var(--danger); border: 1px solid #fecaca; }

        .profile-grid {
            display: grid;
            grid-template-columns: 280px 1fr 320px;
            gap: 24px;
            align-items: start;
        }
        @media (max-width: 1050px) {
            .profile-grid { grid-template-columns: 260px 1fr; }
            .col-wallet { grid-column: span 2; }
        }
        @media (max-width: 768px) {
            .profile-grid { grid-template-columns: 1fr; }
            .col-wallet { grid-column: span 1; }
        }

        .profile-card {
            background: var(--white);
            border: 1px solid var(--border-light);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            margin-bottom: 20px;
        }
        .profile-card-header {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-light);
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #fafbfc;
        }
        .profile-card-header h3 {
            font-size: 15px;
            font-weight: 700;
            color: var(--text-main);
        }
        .profile-card-body { padding: 22px; }

        .avatar-card {
            background: var(--white);
            border: 1px solid var(--border-light);
            border-radius: 12px;
            text-align: center;
            overflow: hidden;
            box-shadow: var(--card-shadow);
        }
        .avatar-card-top {
            display: flex;
            justify-content: flex-end;
            padding: 12px 14px 0 14px;
        }
        .gear-btn {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 15px;
            padding: 4px 8px;
            border-radius: 4px;
            transition: background 0.2s;
        }
        .gear-btn:hover { background: #f1f5f9; color: var(--uts-green); }
        .avatar-img-circle {
            width: 125px;
            height: 125px;
            border-radius: 50%;
            background: #f1f5f9;
            margin: 10px auto 20px auto;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            border: 3px solid var(--uts-green-light);
        }
        .avatar-img-circle img { width: 100%; height: 100%; object-fit: cover; }
        .avatar-card-footer {
            border-top: 1px solid var(--border-light);
            padding: 18px 16px;
            background: #fafbfc;
        }
        .avatar-user-name {
            font-size: 15px;
            font-weight: 800;
            color: var(--text-main);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            line-height: 1.3;
            margin-bottom: 6px;
        }
        .role-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .role-badge-student { background: #e0f2fe; color: #0369a1; }
        .role-badge-admin { background: #fef3c7; color: #b45309; }

        .avatar-change-box {
            margin: 0 16px 14px 16px;
            background: #f8fafc;
            border: 1px dashed var(--border-light);
            border-radius: 8px;
            padding: 8px 10px;
            font-size: 12px;
            text-align: left;
        }
        .avatar-change-box[open] {
            background: var(--uts-green-soft);
            border-color: var(--uts-green-light);
        }
        .avatar-change-toggle {
            cursor: pointer;
            font-weight: 700;
            color: var(--uts-green);
            list-style: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            user-select: none;
            padding: 4px 0;
            font-size: 12px;
        }
        .avatar-change-toggle::-webkit-details-marker { display: none; }
        .avatar-change-toggle:hover { color: var(--uts-green-dark); }
        .avatar-upload-form { margin-top: 10px; display: flex; flex-direction: column; gap: 8px; }
        .file-upload-input {
            width: 100%;
            font-size: 11px;
            padding: 6px;
            background: #ffffff;
            border: 1px solid var(--border-light);
            border-radius: 6px;
            color: var(--text-main);
        }
        .btn-upload-submit {
            background-color: var(--uts-green);
            color: #ffffff;
            border: none;
            border-radius: 6px;
            padding: 7px 12px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
            width: 100%;
        }
        .btn-upload-submit:hover { background-color: var(--uts-green-dark); }
        .btn-restore-avatar {
            background: transparent;
            border: none;
            color: var(--text-muted);
            font-size: 11px;
            text-decoration: underline;
            cursor: pointer;
            padding: 4px 0;
            width: 100%;
            text-align: center;
        }
        .btn-restore-avatar:hover { color: var(--danger); }

        .info-group { margin-bottom: 18px; }
        .info-group:last-child { margin-bottom: 0; }
        .info-label { font-size: 12px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
        .info-value { font-size: 14px; font-weight: 600; color: var(--text-main); }
        .info-value a { color: var(--uts-green); text-decoration: none; }
        .info-value a:hover { text-decoration: underline; }

        .btn-uts {
            background-color: var(--uts-green);
            color: white;
            border: none;
            padding: 9px 18px;
            font-size: 13px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background 0.2s;
        }
        .btn-uts:hover { background-color: var(--uts-green-dark); }

        .btn-secondary {
            background-color: #f1f5f9;
            color: var(--text-main);
            border: 1px solid var(--border-light);
            padding: 8px 14px;
            font-size: 12px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn-secondary:hover { background-color: #e2e8f0; }

        .edit-form-group { display: flex; flex-direction: column; gap: 5px; margin-bottom: 16px; }
        .edit-form-group label { font-size: 13px; font-weight: 700; color: var(--text-main); }
        .edit-form-group input, .edit-form-group select {
            padding: 10px 12px;
            border: 1px solid var(--border-light);
            border-radius: 6px;
            font-size: 13px;
            background: #f8fafc;
        }
        .edit-form-group input:focus, .edit-form-group select:focus {
            background: #fff;
            border-color: var(--uts-green-light);
            outline: none;
        }

        .wallet-preview-box {
            background: linear-gradient(135deg, var(--uts-green-dark) 0%, var(--uts-green) 100%);
            border-radius: 10px;
            padding: 20px;
            color: white;
            margin-bottom: 16px;
        }
        .wallet-prev-label { font-size: 11px; text-transform: uppercase; color: rgba(255,255,255,0.7); letter-spacing: 1px; }
        .wallet-prev-amount { font-size: 26px; font-weight: 800; color: #fff; margin: 6px 0; }
        .wallet-prev-currency { font-size: 14px; font-weight: 700; color: var(--uts-green-light); }
        
        .action-link-btn {
            display: block;
            width: 100%;
            text-align: center;
            padding: 10px 14px;
            margin-top: 10px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s;
        }
        .action-link-primary { background: var(--uts-green); color: white; }
        .action-link-primary:hover { background: var(--uts-green-dark); }
        .action-link-outline { background: #f8fafc; color: var(--text-main); border: 1px solid var(--border-light); }
        .action-link-outline:hover { background: #e2e8f0; }

        .app-download-card {
            border: 2px solid rgba(140, 184, 43, 0.35) !important;
            background: linear-gradient(180deg, #ffffff 0%, #f7fdf8 100%);
            border-radius: 14px;
            box-shadow: 0 8px 24px rgba(47, 92, 53, 0.08);
            margin-top: 20px;
        }
        .app-badge-pill {
            font-size: 10px;
            font-weight: 800;
            background: rgba(140, 184, 43, 0.2);
            color: #1e4522;
            border: 1px solid rgba(140, 184, 43, 0.45);
            padding: 3px 8px;
            border-radius: 20px;
            letter-spacing: 0.5px;
        }
        .app-download-box {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 12px;
        }
        .app-icon-circle {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: #1b3d21;
            padding: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 12px rgba(27, 61, 33, 0.25);
            flex-shrink: 0;
        }
        .app-icon-circle img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
        .app-title-name {
            font-size: 15px;
            font-weight: 800;
            color: var(--uts-green-dark);
            line-height: 1.2;
        }
        .app-version-sub {
            font-size: 11.5px;
            color: var(--text-muted);
            margin-top: 2px;
        }
        .app-download-desc {
            font-size: 12.5px;
            color: #475569;
            line-height: 1.45;
            margin-bottom: 16px;
        }
        .btn-download-app-primary {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            background: linear-gradient(135deg, #1b3d21 0%, #2f5c35 55%, #8cb82b 100%);
            color: #ffffff;
            font-size: 14px;
            font-weight: 800;
            padding: 13px 18px;
            border-radius: 10px;
            text-decoration: none;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(47, 92, 53, 0.3);
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            margin-bottom: 8px;
        }
        .btn-download-app-primary:hover {
            transform: translateY(-1.5px);
            box-shadow: 0 6px 20px rgba(47, 92, 53, 0.4);
            filter: brightness(1.05);
        }
        .btn-download-app-primary:active {
            transform: scale(0.98);
        }
        .btn-install-pwa-secondary {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            background: #ffffff;
            color: var(--uts-green);
            border: 1.5px solid var(--border-light);
            font-size: 12.5px;
            font-weight: 700;
            padding: 10px 14px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-install-pwa-secondary:hover {
            background: #f8fafc;
            border-color: var(--uts-green-light);
        }
        .sidebar-badge-new {
            background: #8cb82b;
            color: #0d2813;
            font-size: 9px;
            font-weight: 900;
            padding: 2px 6px;
            border-radius: 4px;
            margin-left: auto;
            letter-spacing: 0.5px;
        }

        .mobile-bottom-nav,
        .btn-close-sidebar,
        .mobile-drawer-overlay {
            display: none;
        }

        @media (max-width: 992px) {
            body {
                height: auto !important;
                min-height: 100vh !important;
                overflow-y: auto !important;
                overflow-x: hidden !important;
                -webkit-tap-highlight-color: transparent;
            }

            .main-wrapper {
                display: block !important;
                overflow: visible !important;
                position: relative !important;
            }

            .sidebar {
                position: fixed !important;
                top: 0 !important;
                bottom: 0 !important;
                left: 0 !important;
                width: 290px !important;
                max-width: 85vw !important;
                height: 100vh !important;
                z-index: 10001 !important;
                transform: translateX(-100%) !important;
                transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
                box-shadow: 4px 0 30px rgba(0, 0, 0, 0.6) !important;
                display: flex !important;
            }
            .sidebar.mobile-open {
                transform: translateX(0) !important;
            }

            .btn-close-sidebar {
                display: flex !important;
                position: absolute !important;
                top: 14px !important;
                right: 14px !important;
                background: rgba(255, 255, 255, 0.12) !important;
                border: 1px solid rgba(255, 255, 255, 0.2) !important;
                color: #ffffff !important;
                width: 32px !important;
                height: 32px !important;
                border-radius: 50% !important;
                align-items: center !important;
                justify-content: center !important;
                font-size: 20px !important;
                line-height: 1 !important;
                cursor: pointer !important;
                z-index: 10;
            }

            .mobile-drawer-overlay {
                display: none;
                position: fixed !important;
                inset: 0 !important;
                background: rgba(0, 0, 0, 0.65) !important;
                backdrop-filter: blur(4px) !important;
                -webkit-backdrop-filter: blur(4px) !important;
                z-index: 10000 !important;
                opacity: 0;
                transition: opacity 0.3s ease;
            }
            .mobile-drawer-overlay.active {
                display: block !important;
                opacity: 1 !important;
            }

            .content-area {
                width: 100% !important;
                max-width: 100% !important;
                padding: 16px 14px calc(85px + env(safe-area-inset-bottom, 0px)) 14px !important;
                overflow-y: visible !important;
            }

            .top-navbar {
                height: 54px !important;
                padding: 0 14px !important;
            }
            .nav-icon-menu {
                display: flex !important;
                width: 36px !important;
                height: 36px !important;
                align-items: center !important;
                justify-content: center !important;
                border-radius: 8px !important;
                background: #f1f5f9 !important;
                color: #1b3d21 !important;
                font-size: 19px !important;
                cursor: pointer !important;
                border: none !important;
            }
            .logo-subtext,
            .top-navbar-right > span {
                display: none !important;
            }
            .logo-container img {
                height: 32px !important;
            }
            .logo-text {
                font-size: 19px !important;
            }
            .user-menu span {
                font-size: 12px;
                max-width: 90px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
            .user-menu img {
                width: 32px !important;
                height: 32px !important;
            }

            .mobile-bottom-nav {
                display: flex !important;
                position: fixed !important;
                bottom: 0 !important;
                left: 0 !important;
                right: 0 !important;
                height: calc(62px + env(safe-area-inset-bottom, 0px)) !important;
                padding-bottom: env(safe-area-inset-bottom, 0px) !important;
                background: rgba(255, 255, 255, 0.96) !important;
                backdrop-filter: blur(20px) !important;
                -webkit-backdrop-filter: blur(20px) !important;
                border-top: 1px solid rgba(0, 0, 0, 0.08) !important;
                box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.07) !important;
                z-index: 9999 !important;
                justify-content: space-around !important;
                align-items: center !important;
            }

            .mobile-nav-item {
                flex: 1 !important;
                display: flex !important;
                flex-direction: column !important;
                align-items: center !important;
                justify-content: center !important;
                height: 100% !important;
                text-decoration: none !important;
                color: #64748b !important;
                transition: all 0.15s ease !important;
                position: relative !important;
                -webkit-tap-highlight-color: transparent !important;
            }

            .mobile-nav-item:active {
                transform: scale(0.92) !important;
            }

            .mobile-nav-icon-wrap {
                width: 32px !important;
                height: 26px !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                transition: transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1) !important;
            }

            .mobile-nav-label {
                font-size: 10.5px !important;
                font-weight: 600 !important;
                margin-top: 2px !important;
                letter-spacing: -0.2px !important;
            }

            .mobile-nav-item.active {
                color: #27522d !important;
            }

            .mobile-nav-item.active .mobile-nav-icon-wrap {
                color: #27522d !important;
                transform: translateY(-2px) !important;
            }

            .mobile-nav-item.active .mobile-nav-label {
                font-weight: 800 !important;
                color: #1e4522 !important;
            }

            .mobile-nav-item.active::after {
                content: '' !important;
                position: absolute !important;
                top: 4px !important;
                width: 24px !important;
                height: 3px !important;
                background: #8cb82b !important;
                border-radius: 99px !important;
                box-shadow: 0 0 8px rgba(140, 184, 43, 0.7) !important;
            }

            .profile-grid {
                grid-template-columns: 1fr !important;
                gap: 16px !important;
            }
            .profile-card {
                border-radius: 18px !important;
            }
            .edit-form-group input,
            .edit-form-group select {
                font-size: 15px !important;
                min-height: 48px !important;
                border-radius: 10px !important;
            }
            .btn-uts {
                min-height: 46px !important;
                border-radius: 10px !important;
                font-size: 14px !important;
            }
            .wallet-preview-box {
                border-radius: 18px !important;
            }
        }
    </style>
</head>
<body>

    <header class="top-navbar">
        <div class="top-navbar-left">
            <button type="button" class="nav-icon-menu" id="btnToggleSidebar" aria-label="Abrir Menú Lateral">☰</button>
            <a href="${pageContext.request.contextPath}/dashboard" class="logo-container">
                <img src="${pageContext.request.contextPath}/assets/images/logouts.png" alt="DUTS UTS">
                <span class="logo-text">DUTS</span>
                <span class="logo-subtext">Plataforma Financiera Institucional</span>
            </a>
        </div>
        <div class="top-navbar-right">
            <span>Saldo: <strong><fmt:formatNumber value="${saldo}" minFractionDigits="2"/> DUTS</strong></span>
            <a href="${pageContext.request.contextPath}/perfil" class="user-menu">
                <span><c:out value="${sessionScope.usuario.nombreCompleto}"/></span>
                <img src="${pageContext.request.contextPath}/assets/images/${not empty sessionScope.usuario.fotoPerfil && sessionScope.usuario.fotoPerfil != 'avatar.jpg' ? sessionScope.usuario.fotoPerfil : 'default-avatar.svg'}" alt="Avatar">
            </a>
        </div>
    </header>

    <div class="main-wrapper">
        <div class="mobile-drawer-overlay" id="mobileDrawerOverlay"></div>
        
        <aside class="sidebar">
            <div class="sidebar-brand-box">
                <button type="button" class="btn-close-sidebar" id="btnCloseSidebar" aria-label="Cerrar Menú">&times;</button>
                <div class="sidebar-user-pill">
                    <div class="sidebar-user-avatar-wrap">
                        <img src="${pageContext.request.contextPath}/assets/images/${not empty sessionScope.usuario.fotoPerfil && sessionScope.usuario.fotoPerfil != 'avatar.jpg' ? sessionScope.usuario.fotoPerfil : 'default-avatar.svg'}" alt="Avatar">
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

            <div class="sidebar-nav-container">
                <div class="sidebar-nav-section-title">Menú Principal</div>
                <ul class="sidebar-menu">
                    <li>
                        <a href="${pageContext.request.contextPath}/dashboard">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                            </span>
                            <span>Área personal</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/perfil" class="active">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                            </span>
                            <span>Mi Perfil y Ajustes</span>
                            <span class="active-pip"></span>
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
                    <li>
                        <a href="${pageContext.request.contextPath}/descargar-app?tipo=apk" download="DUTS-UTS-Movil.apk" style="color: #c4e477; font-weight: 700; background: rgba(140, 184, 43, 0.12); border-radius: 8px;">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#8cb82b" stroke-width="2.2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
                            </span>
                            <span>Descargar App Móvil</span>
                            <span class="sidebar-badge-new">APK</span>
                        </a>
                    </li>
                </ul>

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

            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout-btn">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                    <span>Cerrar sesión segura</span>
                </a>
                <div class="sidebar-version-info">Plataforma DUTS • v2.4</div>
            </div>
        </aside>

        <main class="content-area">
            <div class="container">

                <div class="page-header-row">
                    <div class="page-title-box">
                        <h1>Perfil y Ajustes</h1>
                        <p>Información institucional, configuración de cuenta y descarga de la aplicación móvil oficial UTS</p>
                    </div>
                </div>

                <c:if test="${not empty flashSuccess}">
                    <div class="alert alert-success">
                        <strong>Completado:</strong> <c:out value="${flashSuccess}"/>
                    </div>
                </c:if>
                <c:if test="${not empty flashError}">
                    <div class="alert alert-error">
                        <strong>Atención:</strong> <c:out value="${flashError}"/>
                    </div>
                </c:if>

                <div class="profile-grid">
                    
                    <div>
                        <div class="avatar-card">
                            <div class="avatar-card-top">
                                <a href="${pageContext.request.contextPath}/perfil?edit=true" class="gear-btn" title="Editar perfil">⚙ &#9662;</a>
                            </div>
                            <div class="avatar-img-circle">
                                <img src="${pageContext.request.contextPath}/assets/images/${not empty usuarioPerfil.fotoPerfil && usuarioPerfil.fotoPerfil != 'avatar.jpg' ? usuarioPerfil.fotoPerfil : 'default-avatar.svg'}" alt="Foto de perfil">
                            </div>

                            <details class="avatar-change-box">
                                <summary class="avatar-change-toggle">Cambiar foto de perfil &#9662;</summary>
                                <form action="${pageContext.request.contextPath}/perfil" method="POST" enctype="multipart/form-data" class="avatar-upload-form">
                                    <input type="hidden" name="action" value="cambiar_foto">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="file" name="foto" id="fotoFile" accept="image/jpeg,image/png,image/webp,image/jpg" required class="file-upload-input">
                                    <button type="submit" class="btn-upload-submit">Subir y Guardar</button>
                                </form>
                                <c:if test="${not empty usuarioPerfil.fotoPerfil && usuarioPerfil.fotoPerfil != 'default-avatar.svg' && usuarioPerfil.fotoPerfil != 'avatar.jpg'}">
                                    <form action="${pageContext.request.contextPath}/perfil" method="POST" style="margin-top: 6px;">
                                        <input type="hidden" name="action" value="restablecer_foto">
                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <button type="submit" class="btn-restore-avatar">Restablecer foto predeterminada</button>
                                    </form>
                                </c:if>
                            </details>

                            <div class="avatar-card-footer">
                                <div class="avatar-user-name">
                                    <c:out value="${usuarioPerfil.nombreCompleto}"/>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${usuarioPerfil.rolId == 2}">
                                            <span class="role-badge role-badge-admin">Administrador</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="role-badge role-badge-student">Estudiante Activo</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div>
                        <div class="profile-card">
                            <div class="profile-card-header">
                                <h3>Detalles de Usuario</h3>
                                <c:choose>
                                    <c:when test="${editMode}">
                                        <a href="${pageContext.request.contextPath}/perfil" class="btn-secondary">Cancelar</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/perfil?edit=true" class="btn-secondary">Editar Información</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="profile-card-body">
                                
                                <c:choose>
                                    <c:when test="${editMode}">
                                        <form action="${pageContext.request.contextPath}/perfil" method="POST">
                                            <input type="hidden" name="action" value="actualizar_perfil">
                                            <input type="hidden" name="csrfToken" value="${csrfToken}">

                                            <div class="edit-form-group">
                                                <label for="nombreCompleto">Nombre Completo *</label>
                                                <input type="text" id="nombreCompleto" name="nombreCompleto" value="${usuarioPerfil.nombreCompleto}" required>
                                            </div>

                                            <div class="edit-form-group">
                                                <label for="correo">Correo Institucional *</label>
                                                <input type="email" id="correo" name="correo" value="${usuarioPerfil.correo}" required>
                                            </div>

                                            <div class="edit-form-group">
                                                <label for="programaAcademico">Programa Académico *</label>
                                                <select id="programaAcademico" name="programaAcademico" required>
                                                    <optgroup label="Facultad de Ciencias Naturales e Ingenierías">
                                                        <option value="Ingeniería de Sistemas" ${usuarioPerfil.programaAcademico == 'Ingeniería de Sistemas' ? 'selected' : ''}>Ingeniería de Sistemas</option>
                                                        <option value="Tecnología en Desarrollo de Sistemas Informáticos" ${usuarioPerfil.programaAcademico == 'Tecnología en Desarrollo de Sistemas Informáticos' || usuarioPerfil.programaAcademico == 'TECNOLOGIA EN DESARROLLO DE SISTEMAS INFORMATICOS' ? 'selected' : ''}>Tecnología en Desarrollo de Sistemas Informáticos</option>
                                                        <option value="Ingeniería en Inteligencia Artificial y Ciencia de Datos" ${usuarioPerfil.programaAcademico == 'Ingeniería en Inteligencia Artificial y Ciencia de Datos' ? 'selected' : ''}>Ingeniería en Inteligencia Artificial y Ciencia de Datos</option>
                                                        <option value="Ingeniería Electromecánica" ${usuarioPerfil.programaAcademico == 'Ingeniería Electromecánica' ? 'selected' : ''}>Ingeniería Electromecánica</option>
                                                        <option value="Tecnología en Telecomunicaciones" ${usuarioPerfil.programaAcademico == 'Tecnología en Telecomunicaciones' ? 'selected' : ''}>Tecnología en Telecomunicaciones</option>
                                                    </optgroup>
                                                    <optgroup label="Facultad de Ciencias Socioeconómicas y Empresariales">
                                                        <option value="Administración de Empresas" ${usuarioPerfil.programaAcademico == 'Administración de Empresas' ? 'selected' : ''}>Administración de Empresas</option>
                                                        <option value="Tecnología en Gestión Empresarial" ${usuarioPerfil.programaAcademico == 'Tecnología en Gestión Empresarial' ? 'selected' : ''}>Tecnología en Gestión Empresarial</option>
                                                        <option value="Contaduría Pública" ${usuarioPerfil.programaAcademico == 'Contaduría Pública' ? 'selected' : ''}>Contaduría Pública</option>
                                                    </optgroup>
                                                </select>
                                            </div>

                                            <div class="edit-form-group">
                                                <label for="semestre">Semestre</label>
                                                <input type="number" id="semestre" name="semestre" min="1" max="12" value="${usuarioPerfil.semestre}">
                                            </div>

                                            <div style="display: flex; gap: 10px; margin-top: 18px;">
                                                <button type="submit" class="btn-uts">Guardar Cambios</button>
                                                <a href="${pageContext.request.contextPath}/perfil" class="btn-secondary">Cancelar</a>
                                            </div>
                                        </form>
                                    </c:when>

                                    <c:otherwise>
                                        <div class="info-group">
                                            <div class="info-label">Código Estudiantil</div>
                                            <div class="info-value"><c:out value="${usuarioPerfil.codigoEstudiantil}"/></div>
                                        </div>

                                        <div class="info-group">
                                            <div class="info-label">Nombre de Usuario</div>
                                            <div class="info-value"><c:out value="${usuarioPerfil.username}"/></div>
                                        </div>

                                        <div class="info-group">
                                            <div class="info-label">Dirección de Correo Institucional</div>
                                            <div class="info-value">
                                                <a href="mailto:${usuarioPerfil.correo}"><c:out value="${usuarioPerfil.correo}"/></a>
                                            </div>
                                        </div>

                                        <div class="info-group">
                                            <div class="info-label">Programa Académico</div>
                                            <div class="info-value"><c:out value="${usuarioPerfil.programaAcademico}"/> (Semestre <c:out value="${usuarioPerfil.semestre}"/>)</div>
                                        </div>

                                        <div class="info-group">
                                            <div class="info-label">Sede Universitaria</div>
                                            <div class="info-value">SEDE PRINCIPAL — Bucaramanga, Colombia (Código 1750)</div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </div>
                    </div>

                    <div class="col-wallet">
                        
                        <div class="profile-card">
                            <div class="profile-card-header">
                                <h3>Billetera DUTS</h3>
                            </div>
                            <div class="profile-card-body">
                                <div class="wallet-preview-box">
                                    <div class="wallet-prev-label">Saldo Disponible</div>
                                    <div class="wallet-prev-amount">
                                        <fmt:formatNumber value="${saldo}" minFractionDigits="2" maxFractionDigits="2"/>
                                    </div>
                                    <span class="wallet-prev-currency">DUTS Institucionales</span>
                                </div>

                                <a href="${pageContext.request.contextPath}/transferencias" class="action-link-btn action-link-primary">
                                    Transferir DUTS
                                </a>
                                <a href="${pageContext.request.contextPath}/movimientos" class="action-link-btn action-link-outline">
                                    Ver Historial de Movimientos
                                </a>
                            </div>
                        </div>

                        <div class="profile-card">
                            <div class="profile-card-header">
                                <h3>Estado de la Cuenta</h3>
                            </div>
                            <div class="profile-card-body">
                                <div class="info-group">
                                    <div class="info-label">Fecha de Registro</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty usuarioPerfil.fechaRegistro}">
                                                <fmt:formatDate value="${usuarioPerfil.fechaRegistro}" pattern="yyyy-MM-dd HH:mm"/>
                                            </c:when>
                                            <c:otherwise>
                                                Activa en el sistema
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="info-group" style="margin-top: 12px;">
                                    <div class="info-label">Estado en Plataforma</div>
                                    <div class="info-value" style="color: var(--success); font-weight: 700;">
                                        ● Activo y Verificado
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="profile-card app-download-card" id="seccionDescargaApp">
                            <div class="profile-card-header" style="background: rgba(140, 184, 43, 0.08);">
                                <h3>Ajustes de Aplicación Móvil</h3>
                                <span class="app-badge-pill">OFICIAL UTS</span>
                            </div>
                            <div class="profile-card-body">
                                <div class="app-download-box">
                                    <div class="app-icon-circle">
                                        <img src="${pageContext.request.contextPath}/assets/images/logouts.png" alt="UTS App">
                                    </div>
                                    <div>
                                        <div class="app-title-name">DUTS Móvil UTS</div>
                                        <div class="app-version-sub">Versión 2.4 Oficial • Android / PWA</div>
                                    </div>
                                </div>
                                <p class="app-download-desc">
                                    Lleva la plataforma DUTS a tu celular para transferencias instantáneas, consulta de saldo en tiempo real y notificaciones institucionales sin límites.
                                </p>

                                <a href="${pageContext.request.contextPath}/descargar-app?tipo=apk" class="btn-download-app-primary" id="btnDescargarApp" download="DUTS-UTS-Movil.apk" title="Descargar instalador APK directo para celulares Android">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
                                    <span>Descargar App (APK)</span>
                                </a>

                                <button type="button" class="btn-install-pwa-secondary" id="btnInstallPwa" onclick="triggerPwaInstall()" title="Agregar como acceso directo tipo App nativa">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="5" y="2" width="14" height="20" rx="2" ry="2"></rect><line x1="12" y1="18" x2="12.01" y2="18"></line></svg>
                                    <span>Instalar en Pantalla de Inicio</span>
                                </button>
                            </div>
                        </div>

                    </div>

                </div>

            </div>
        </main>
    </div>

    <nav class="mobile-bottom-nav" aria-label="Navegación principal de la aplicación">
        <a href="${pageContext.request.contextPath}/dashboard" class="mobile-nav-item" title="Inicio">
            <div class="mobile-nav-icon-wrap">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
            </div>
            <span class="mobile-nav-label">Inicio</span>
        </a>
        <a href="${pageContext.request.contextPath}/transferencias" class="mobile-nav-item" title="Transferencias">
            <div class="mobile-nav-icon-wrap">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="7" y1="17" x2="17" y2="7"></line><polyline points="7 7 17 7 17 17"></polyline></svg>
            </div>
            <span class="mobile-nav-label">Transferir</span>
        </a>
        <a href="${pageContext.request.contextPath}/eventos" class="mobile-nav-item" title="Eventos y Recompensas">
            <div class="mobile-nav-icon-wrap">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
            </div>
            <span class="mobile-nav-label">Eventos</span>
        </a>
        <a href="${pageContext.request.contextPath}/movimientos" class="mobile-nav-item" title="Historial y Facturas">
            <div class="mobile-nav-icon-wrap">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
            </div>
            <span class="mobile-nav-label">Facturas</span>
        </a>
        <a href="${pageContext.request.contextPath}/perfil" class="mobile-nav-item active" title="Ajustes y Perfil">
            <div class="mobile-nav-icon-wrap">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
            </div>
            <span class="mobile-nav-label">Ajustes</span>
        </a>
    </nav>

    <script>
        const btnToggleSidebar = document.getElementById('btnToggleSidebar');
        const btnCloseSidebar = document.getElementById('btnCloseSidebar');
        const mobileDrawerOverlay = document.getElementById('mobileDrawerOverlay');
        const sidebar = document.querySelector('.sidebar');

        function openDrawer() {
            if (sidebar) sidebar.classList.add('mobile-open');
            if (mobileDrawerOverlay) mobileDrawerOverlay.classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        function closeDrawer() {
            if (sidebar) sidebar.classList.remove('mobile-open');
            if (mobileDrawerOverlay) mobileDrawerOverlay.classList.remove('active');
            document.body.style.overflow = '';
        }

        if (btnToggleSidebar) btnToggleSidebar.addEventListener('click', openDrawer);
        if (btnCloseSidebar) btnCloseSidebar.addEventListener('click', closeDrawer);
        if (mobileDrawerOverlay) mobileDrawerOverlay.addEventListener('click', closeDrawer);

        if ('serviceWorker' in navigator) {
            window.addEventListener('load', function() {
                navigator.serviceWorker.register('${pageContext.request.contextPath}/sw.js')
                    .then(function(reg) {
                        console.log('DUTS Service Worker registrado:', reg.scope);
                    })
                    .catch(function(err) {
                        console.log('Error registrando Service Worker:', err);
                    });
            });
        }

        let deferredPrompt = null;
        window.addEventListener('beforeinstallprompt', function(e) {
            e.preventDefault();
            deferredPrompt = e;
            const btnPwa = document.getElementById('btnInstallPwa');
            if (btnPwa) {
                btnPwa.style.display = 'flex';
            }
        });

        function triggerPwaInstall() {
            if (deferredPrompt) {
                deferredPrompt.prompt();
                deferredPrompt.userChoice.then(function(choiceResult) {
                    if (choiceResult.outcome === 'accepted') {
                        console.log('El usuario aceptó la instalación de la App DUTS');
                    }
                    deferredPrompt = null;
                });
            } else {
                alert('Para instalar la App DUTS en tu celular:\n1. En Android/Chrome: Menú (⋮) -> "Instalar aplicación" o "Agregar a la pantalla principal".\n2. En iPhone/Safari: Botón Compartir (⬆) -> "Agregar al inicio".\n\nTambién puedes descargar el archivo instalador APK con el botón verde superior.');
            }
        }
    </script>
</body>
</html>
