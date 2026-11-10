<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, viewport-fit=cover">
    <title>Transferencias DUTS - Plataforma UTS</title>
    
    <meta name="theme-color" content="#1b3d21">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/images/favicon.svg">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/assets/images/favicon.svg">
    <link rel="manifest" href="${pageContext.request.contextPath}/manifest.json">
    <style>
        :root {
            --uts-green: #2f5c35;
            --uts-green-dark: #1b3d21;
            --uts-green-light: #8cb82b;
            --uts-green-soft: #f0f7f1;
            --uts-accent: #6d961e;
            --bg-body: #f4f6f9;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border-light: #e2e8f0;
            --white: #ffffff;
            --card-shadow: 0 4px 16px -2px rgba(15, 23, 42, 0.06), 0 2px 6px -2px rgba(15, 23, 42, 0.04);
            --card-shadow-hover: 0 10px 24px -3px rgba(15, 23, 42, 0.09), 0 4px 10px -2px rgba(15, 23, 42, 0.05);
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
            box-shadow: 0 1px 3px rgba(0,0,0,0.03);
        }
        .top-navbar-left { display: flex; align-items: center; gap: 16px; }
        .logo-container { display: flex; align-items: center; gap: 12px; text-decoration: none; cursor: pointer; }
        .logo-container img { height: 38px; }
        .logo-text { color: var(--uts-green-light); font-weight: 800; font-size: 22px; letter-spacing: 0.5px; }
        .logo-subtext { font-size: 11px; color: #888; border-left: 1px solid #cbd5e1; padding-left: 10px; line-height: 1.2; }

        .top-navbar-right { display: flex; align-items: center; gap: 24px; color: var(--text-muted); font-size: 14px; }
        .user-menu { display: flex; align-items: center; gap: 12px; font-weight: 600; color: var(--uts-green); text-decoration: none; padding: 4px 10px; border-radius: 6px; transition: background 0.2s; }
        .user-menu:hover { background: #f1f5f9; }
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
        .logout-link a:hover { color: #ffffff; }

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

        .alert {
            padding: 14px 18px;
            border-radius: 8px;
            margin-bottom: 22px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .alert-success { background-color: var(--success-bg); color: var(--success); border: 1px solid #bbf7d0; }
        .alert-error { background-color: var(--danger-bg); color: var(--danger); border: 1px solid #fecaca; }

        .transfer-grid {
            display: grid;
            grid-template-columns: 380px 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }
        @media (max-width: 992px) {
            .transfer-grid { grid-template-columns: 1fr; }
        }

        .digital-wallet-card {
            background: linear-gradient(135deg, #1b3d21 0%, #2f5c35 55%, #18421e 100%);
            border-radius: 16px;
            padding: 26px;
            color: white;
            box-shadow: 0 12px 30px -5px rgba(27, 61, 33, 0.4);
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 230px;
        }
        .digital-wallet-card::before {
            content: '';
            position: absolute;
            top: -60px;
            right: -60px;
            width: 200px;
            height: 200px;
            background: radial-gradient(circle, rgba(140, 184, 43, 0.25) 0%, rgba(255,255,255,0) 70%);
            border-radius: 50%;
            pointer-events: none;
        }
        .wallet-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }
        .card-brand {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: rgba(255, 255, 255, 0.8);
            font-weight: 700;
        }
        .card-subbrand {
            font-size: 18px;
            font-weight: 900;
            color: var(--uts-green-light);
            letter-spacing: 1px;
        }
        .card-chip {
            width: 44px;
            height: 32px;
            background: linear-gradient(135deg, #e2d9a6 0%, #d4af37 50%, #aa8c2c 100%);
            border-radius: 6px;
            border: 1px solid rgba(0,0,0,0.15);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0.9;
        }
        .card-chip svg { width: 30px; height: 22px; opacity: 0.6; }

        .card-balance-box {
            margin: 10px 0 20px 0;
        }
        .balance-title {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: rgba(255, 255, 255, 0.75);
            font-weight: 600;
            margin-bottom: 4px;
        }
        .balance-value {
            font-size: 34px;
            font-weight: 800;
            letter-spacing: -0.5px;
            color: #ffffff;
            display: flex;
            align-items: baseline;
            gap: 8px;
        }
        .balance-currency {
            font-size: 18px;
            font-weight: 700;
            color: var(--uts-green-light);
        }

        .wallet-bottom {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            padding-top: 14px;
            border-top: 1px solid rgba(255, 255, 255, 0.15);
        }
        .wallet-holder-label { font-size: 10px; text-transform: uppercase; color: rgba(255,255,255,0.65); letter-spacing: 0.8px; }
        .wallet-holder-name { font-size: 14px; font-weight: 700; text-transform: uppercase; color: #ffffff; letter-spacing: 0.5px; }
        .wallet-code { font-size: 13px; font-family: monospace; color: rgba(255,255,255,0.85); letter-spacing: 1px; }

        .wallet-action-panel {
            background: var(--white);
            border: 1px solid var(--border-light);
            border-radius: 12px;
            padding: 20px;
            margin-top: 15px;
            box-shadow: var(--card-shadow);
        }
        .panel-badge-circular {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #ecfdf5;
            color: #047857;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 14px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            border: 1px solid #a7f3d0;
        }
        .panel-title { font-size: 14px; font-weight: 700; color: var(--uts-green); margin-bottom: 6px; }
        .panel-desc { font-size: 12px; color: var(--text-muted); line-height: 1.45; margin-bottom: 14px; }

        .circular-rules-list {
            list-style: none;
            padding: 0;
            margin: 0 0 16px 0;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .circular-rules-list li {
            font-size: 12px;
            color: #475569;
            display: flex;
            align-items: flex-start;
            gap: 9px;
            line-height: 1.4;
        }
        .circular-rules-list li strong {
            color: #0f172a;
        }
        .rule-icon {
            color: var(--uts-green);
            background: #f1f5f9;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            margin-top: 1px;
            border: 1px solid #e2e8f0;
        }
        .btn-earn-duts {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            background: linear-gradient(135deg, var(--uts-green) 0%, var(--uts-green-dark) 100%);
            color: white;
            font-size: 13px;
            font-weight: 700;
            padding: 11px 16px;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.2s;
            box-shadow: 0 4px 12px rgba(47, 92, 53, 0.25);
        }
        .btn-earn-duts:hover {
            background: linear-gradient(135deg, var(--uts-green-light) 0%, var(--uts-green) 100%);
            color: white;
            box-shadow: 0 6px 16px rgba(140, 184, 43, 0.35);
        }

        .transfer-card {
            background: var(--white);
            border: 1px solid var(--border-light);
            border-radius: 16px;
            padding: 30px;
            box-shadow: var(--card-shadow);
        }
        .card-header-styled {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 18px;
            margin-bottom: 24px;
            border-bottom: 1px solid #f1f5f9;
        }
        .card-header-styled h2 { font-size: 18px; font-weight: 700; color: var(--uts-green); }
        .badge-live {
            background: #dcfce7;
            color: #15803d;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .badge-live-dot { width: 7px; height: 7px; border-radius: 50%; background: #15803d; }

        .form-grid-2 {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        @media (max-width: 650px) { .form-grid-2 { grid-template-columns: 1fr; } }

        .input-block { display: flex; flex-direction: column; gap: 7px; }
        .input-label {
            font-size: 13px;
            font-weight: 700;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .input-label span.req { color: var(--danger); }
        
        .input-control-wrap {
            position: relative;
            display: flex;
            align-items: center;
        }
        .input-icon-left {
            position: absolute;
            left: 14px;
            color: #94a3b8;
            display: flex;
            align-items: center;
            pointer-events: none;
        }
        .input-styled {
            width: 100%;
            padding: 12px 14px 12px 42px;
            border: 1.5px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            color: var(--text-main);
            background: #f8fafc;
            transition: all 0.2s ease;
        }
        .input-styled:focus {
            background: #ffffff;
            border-color: var(--uts-green-light);
            outline: none;
            box-shadow: 0 0 0 3px rgba(140, 184, 43, 0.2);
        }
        .input-hint { font-size: 11px; color: var(--text-muted); margin-top: 2px; }

        .quick-amounts {
            display: flex;
            gap: 8px;
            margin-top: 8px;
            flex-wrap: wrap;
        }
        .quick-chip {
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            color: var(--text-muted);
            font-size: 11px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
        }

        .destinatario-verificado-card {
            background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 100%);
            border: 1.5px solid #86efac;
            border-radius: 10px;
            padding: 10px 14px;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 8px;
            box-shadow: 0 2px 6px rgba(16, 185, 129, 0.08);
        }
        .destinatario-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            overflow: hidden;
            flex-shrink: 0;
            border: 2px solid #22c55e;
            background: #dcfce7;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .destinatario-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .destinatario-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 2px;
            min-width: 0;
        }
        .destinatario-badge-check {
            font-size: 11px;
            font-weight: 700;
            color: #15803d;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        .destinatario-info strong {
            font-size: 13px;
            color: #14532d;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .destinatario-info span {
            font-size: 11px;
            color: #4b5563;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .btn-cambiar-destinatario {
            font-size: 11px;
            font-weight: 700;
            color: #b91c1c;
            background: #fee2e2;
            padding: 4px 10px;
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.2s;
            flex-shrink: 0;
        }
        .btn-cambiar-destinatario:hover {
            background: #fecaca;
            color: #991b1b;
        }

        .user-picker-directory {
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            background: #f8fafc;
            margin-bottom: 20px;
            overflow: hidden;
            transition: all 0.2s;
        }
        .user-picker-directory[open] {
            border-color: #cbd5e1;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }
        .user-picker-summary {
            padding: 11px 16px;
            background: #f1f5f9;
            color: var(--uts-green);
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 9px;
            user-select: none;
            transition: background 0.2s;
        }
        .user-picker-summary:hover {
            background: #e2e8f0;
        }
        .user-picker-body {
            padding: 12px 14px;
            background: #ffffff;
        }
        .user-search-form {
            display: flex;
            gap: 8px;
            margin-bottom: 12px;
        }
        .user-search-input {
            flex: 1;
            padding: 9px 12px;
            border: 1.5px solid #cbd5e1;
            border-radius: 7px;
            font-size: 13px;
            background: #f8fafc;
        }
        .user-search-input:focus {
            background: #ffffff;
            border-color: var(--uts-green-light);
            outline: none;
            box-shadow: 0 0 0 2px rgba(140, 184, 43, 0.2);
        }
        .btn-search-user {
            background: var(--uts-green);
            color: white;
            border: none;
            padding: 9px 16px;
            border-radius: 7px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-search-user:hover {
            background: var(--uts-green-dark);
        }
        .btn-clear-user {
            background: #f1f5f9;
            color: #475569;
            padding: 9px 12px;
            border-radius: 7px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            border: 1px solid #cbd5e1;
            display: inline-flex;
            align-items: center;
        }
        .btn-clear-user:hover {
            background: #e2e8f0;
        }
        .users-list-scroll {
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid #f1f5f9;
            border-radius: 8px;
            padding: 4px;
        }
        .user-mini-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 8px 10px;
            border-radius: 6px;
            border-bottom: 1px solid #f8fafc;
            transition: background 0.15s;
        }
        .user-mini-row:hover {
            background: #f1f5f9;
        }
        .user-mini-avatar {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            overflow: hidden;
            flex-shrink: 0;
            background: #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .user-mini-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .user-avatar-initials {
            font-size: 13px;
            font-weight: 700;
            color: var(--uts-green);
            background: #dcfce7;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .user-mini-details {
            flex: 1;
            margin: 0 12px;
            display: flex;
            flex-direction: column;
            gap: 2px;
            min-width: 0;
        }
        .user-mini-name {
            font-size: 13px;
            font-weight: 700;
            color: var(--text-main);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .user-mini-sub {
            font-size: 11px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 6px;
            flex-wrap: wrap;
        }
        .badge-code {
            background: #e2e8f0;
            color: #334155;
            font-family: monospace;
            font-weight: 700;
            padding: 1px 6px;
            border-radius: 4px;
            font-size: 11px;
        }
        .btn-pick-recipient {
            background: var(--uts-green);
            color: white;
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s;
            flex-shrink: 0;
        }
        .btn-pick-recipient:hover {
            background: var(--uts-green-light);
            color: white;
            box-shadow: 0 2px 6px rgba(140, 184, 43, 0.4);
        }
        .no-users-found {
            padding: 18px;
            text-align: center;
            font-size: 12px;
            color: var(--text-muted);
        }

        .submit-btn-row {
            margin-top: 25px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            flex-wrap: wrap;
        }
        .btn-transfer-now {
            background: linear-gradient(135deg, var(--uts-green) 0%, var(--uts-green-dark) 100%);
            color: white;
            border: none;
            padding: 13px 28px;
            font-size: 15px;
            font-weight: 700;
            border-radius: 8px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(47, 92, 53, 0.3);
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.2s;
        }
        .btn-transfer-now:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(47, 92, 53, 0.4);
            background: linear-gradient(135deg, #366d3d 0%, #1e4525 100%);
        }
        .security-badge {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            color: var(--text-muted);
        }

        .history-card {
            background: var(--white);
            border: 1px solid var(--border-light);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
        }
        .history-header {
            padding: 18px 25px;
            border-bottom: 1px solid var(--border-light);
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #fafbfc;
        }
        .history-header h2 { font-size: 16px; font-weight: 700; color: var(--text-main); }
        .history-count {
            font-size: 12px;
            color: var(--uts-green);
            background: var(--uts-green-soft);
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 700;
        }

        .table-wrap { width: 100%; overflow-x: auto; }
        .transfer-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            text-align: left;
        }
        .transfer-table th {
            padding: 14px 20px;
            background-color: #f8fafc;
            color: var(--text-muted);
            font-weight: 700;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            border-bottom: 1px solid var(--border-light);
        }
        .transfer-table td {
            padding: 16px 20px;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }
        .transfer-table tr:hover td {
            background-color: #fbfcfd;
        }

        .flow-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.4px;
        }
        .flow-sent {
            background-color: var(--danger-bg);
            color: var(--danger);
            border: 1px solid #fecaca;
        }
        .flow-received {
            background-color: var(--success-bg);
            color: var(--success);
            border: 1px solid #bbf7d0;
        }
        .user-col { display: flex; flex-direction: column; }
        .user-name-strong { font-weight: 700; color: var(--text-main); }
        .user-code-sub { font-size: 11px; color: var(--text-muted); font-family: monospace; }
        .concept-text { color: #475569; font-weight: 500; }
        .date-text { color: var(--text-muted); font-size: 12px; }
        
        .amount-col {
            font-size: 15px;
            font-weight: 800;
            text-align: right;
            letter-spacing: -0.3px;
        }
        .amount-sent { color: var(--danger); }
        .amount-recv { color: var(--success); }

        .empty-history-box {
            text-align: center;
            padding: 50px 20px;
            color: var(--text-muted);
        }
        .empty-history-icon {
            width: 60px;
            height: 60px;
            margin: 0 auto 16px auto;
            color: #cbd5e1;
        }
        .empty-history-box h3 { font-size: 16px; font-weight: 700; color: var(--text-main); margin-bottom: 6px; }
        .empty-history-box p { font-size: 13px; max-width: 420px; margin: 0 auto; line-height: 1.5; }

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
                font-size: 12.5px;
                max-width: 110px;
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

            .transfer-card {
                padding: 18px 16px !important;
                border-radius: 18px !important;
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06) !important;
            }
            .form-grid {
                grid-template-columns: 1fr !important;
                gap: 14px !important;
            }
            .input-group input,
            .input-group textarea {
                font-size: 15px !important;
                min-height: 48px !important;
                border-radius: 10px !important;
            }
            .btn-transfer-now {
                width: 100% !important;
                justify-content: center !important;
                padding: 14px !important;
                font-size: 15px !important;
                border-radius: 12px !important;
                min-height: 48px !important;
            }
            .btn-transfer-now:active {
                transform: scale(0.98) !important;
            }
            .submit-btn-row {
                flex-direction: column !important;
                align-items: stretch !important;
                gap: 12px !important;
            }
            .security-badge {
                justify-content: center !important;
            }

            .history-card {
                border-radius: 18px !important;
            }
            .history-header {
                padding: 14px 16px !important;
            }
        }
    </style>
</head>
<body>

    <header class="top-navbar">
        <div class="top-navbar-left">
            <button type="button" class="nav-icon-menu" id="btnToggleSidebar" aria-label="Menú">&#9776;</button>
            <a href="${pageContext.request.contextPath}/dashboard" class="logo-container">
                <img src="${pageContext.request.contextPath}/assets/images/logouts.png" alt="DUTS UTS">
                <span class="logo-text">DUTS</span>
                <span class="logo-subtext">Ecosistema de Méritos UTS</span>
            </a>
        </div>
        <div class="top-navbar-right">
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
                        <a href="${pageContext.request.contextPath}/perfil">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                            </span>
                            <span>Mi Perfil y Ajustes</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/transferencias" class="active">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="7" y1="17" x2="17" y2="7"></line><polyline points="7 7 17 7 17 17"></polyline></svg>
                            </span>
                            <span>Transferencias DUTS</span>
                            <span class="active-pip"></span>
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
                            <span style="background:#8cb82b;color:#0d2813;font-size:9px;font-weight:900;padding:2px 6px;border-radius:4px;margin-left:auto;">APK</span>
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
                        <h1>Billetera y Transferencias DUTS</h1>
                        <p>Envía y recibe saldo en tiempo real entre estudiantes y docentes de las UTS</p>
                    </div>
                </div>

                <c:if test="${not empty flashSuccess}">
                    <div class="alert alert-success">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        <div><strong>¡Transferencia exitosa!</strong> <c:out value="${flashSuccess}" /></div>
                    </div>
                </c:if>
                <c:if test="${not empty flashError}">
                    <div class="alert alert-error">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        <div><strong>Atención:</strong> <c:out value="${flashError}" /></div>
                    </div>
                </c:if>

                <div class="transfer-grid">
                    
                    <div>
                        <div class="digital-wallet-card">
                            <div class="wallet-top">
                                <div>
                                    <div class="card-brand">Unidades Tecnológicas</div>
                                    <div class="card-subbrand">CUENTA DUTS</div>
                                </div>
                                <div class="card-chip">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="#685012" stroke-width="1.5"><rect x="2" y="2" width="20" height="20" rx="3"/><line x1="2" y1="8" x2="22" y2="8"/><line x1="2" y1="16" x2="22" y2="16"/><line x1="8" y1="2" x2="8" y2="22"/><line x1="16" y1="2" x2="16" y2="22"/></svg>
                                </div>
                            </div>

                            <div class="card-balance-box">
                                <div class="balance-title">Saldo Disponible</div>
                                <div class="balance-value">
                                    <fmt:formatNumber value="${saldo}" minFractionDigits="2" maxFractionDigits="2"/>
                                    <span class="balance-currency">DUTS</span>
                                </div>
                            </div>

                            <div class="wallet-bottom">
                                <div>
                                    <div class="wallet-holder-label">Titular de Cuenta</div>
                                    <div class="wallet-holder-name"><c:out value="${sessionScope.usuario.nombreCompleto}"/></div>
                                </div>
                                <div>
                                    <div class="wallet-code">COD: <c:out value="${sessionScope.usuario.codigoEstudiantil}"/></div>
                                </div>
                            </div>
                        </div>

                        <div class="wallet-action-panel">
                            <div class="panel-badge-circular">
                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M21.5 2v6h-6M2.5 22v-6h6M2 11.5a10 10 0 0 1 18.8-4.3M22 12.5a10 10 0 0 1-18.8 4.2"/></svg>
                                Economía Circular UTS
                            </div>
                            <div class="panel-title" style="margin-top: 10px;">¿Cómo circulan los DUTS?</div>
                            <div class="panel-desc">
                                En la plataforma institucional los DUTS no se recargan arbitrariamente. El saldo circula de manera orgánica a través del mérito y la colaboración:
                            </div>

                            <ul class="circular-rules-list">
                                <li>
                                    <span class="rule-icon">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                    </span>
                                    <span><strong>Eventos Universitarios:</strong> Inscríbete y participa en actividades para ganar DUTS institucionales.</span>
                                </li>
                                <li>
                                    <span class="rule-icon">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                    </span>
                                    <span><strong>Transferencias entre Estudiantes:</strong> Recibe pagos o comparte saldo con tus compañeros de clase.</span>
                                </li>
                                <li>
                                    <span class="rule-icon">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                    </span>
                                    <span><strong>Bono de Bienvenida:</strong> Otorgado una sola vez al registrarte en el sistema (+500 DUTS).</span>
                                </li>
                            </ul>

                            <a href="${pageContext.request.contextPath}/eventos" class="btn-earn-duts">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                Explorar Eventos UTS para Ganar DUTS
                            </a>
                        </div>
                    </div>

                    <div>
                        <div class="transfer-card">
                            <div class="card-header-styled">
                                <h2>Nueva Transferencia Institucional</h2>
                                <span class="badge-live">
                                    <span class="badge-live-dot"></span>
                                    Servicio Activo
                                </span>
                            </div>

                            <details class="user-picker-directory" ${not empty param.buscar ? 'open' : ''}>
                                <summary class="user-picker-summary">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                                    <span>Buscar y explorar estudiantes en la base de datos (${not empty usuariosDisponibles ? usuariosDisponibles.size() : 0} registrados)</span>
                                </summary>
                                <div class="user-picker-body">
                                    <form action="${pageContext.request.contextPath}/transferencias" method="GET" class="user-search-form">
                                        <input type="text" name="buscar" value="${not empty queryBusqueda ? queryBusqueda : ''}" placeholder="Filtrar por nombre, código estudiantil o carrera..." class="user-search-input">
                                        <button type="submit" class="btn-search-user">Buscar en BD</button>
                                        <c:if test="${not empty queryBusqueda}">
                                            <a href="${pageContext.request.contextPath}/transferencias" class="btn-clear-user">Ver todos</a>
                                        </c:if>
                                    </form>

                                    <div class="users-list-scroll">
                                        <c:choose>
                                            <c:when test="${not empty usuariosDisponibles}">
                                                <c:forEach items="${usuariosDisponibles}" var="dest">
                                                    <div class="user-mini-row">
                                                        <div class="user-mini-avatar">
                                                            <c:choose>
                                                                <c:when test="${not empty dest.fotoPerfil && dest.fotoPerfil != 'avatar.jpg'}">
                                                                    <img src="${pageContext.request.contextPath}/assets/images/${dest.fotoPerfil}" alt="Avatar">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="user-avatar-initials">${dest.nombreCompleto.substring(0, 1)}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="user-mini-details">
                                                            <span class="user-mini-name"><c:out value="${dest.nombreCompleto}"/></span>
                                                            <span class="user-mini-sub">
                                                                <span class="badge-code"><c:out value="${dest.codigoEstudiantil}"/></span>
                                                                <span>@<c:out value="${dest.username}"/></span>
                                                                <c:if test="${not empty dest.programaAcademico}">
                                                                    &bull; <span><c:out value="${dest.programaAcademico}"/></span>
                                                                </c:if>
                                                            </span>
                                                        </div>
                                                        <a href="${pageContext.request.contextPath}/transferencias?destinatario=${dest.codigoEstudiantil}#destinatario" class="btn-pick-recipient">
                                                            Seleccionar
                                                        </a>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="no-users-found">
                                                    No se encontraron estudiantes registrados con "${queryBusqueda}".
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </details>

                            <form id="form-transferencia" action="${pageContext.request.contextPath}/transferencias" method="POST">
                                <input type="hidden" name="action" value="enviar">
                                <input type="hidden" name="csrfToken" value="${csrfToken}">

                                <div class="form-grid-2">
                                    <div class="input-block">
                                        <label for="destinatario" class="input-label">
                                            Destinatario <span class="req">*</span>
                                        </label>
                                        <div class="input-control-wrap">
                                            <span class="input-icon-left">
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                            </span>
                                            <input type="text" id="destinatario" name="destinatario" list="listaUsuariosBD" class="input-styled" 
                                                   placeholder="Código o usuario (ej: 1007451037)" 
                                                   value="${not empty param.destinatario ? param.destinatario : ''}" 
                                                   autocomplete="off" required>
                                        </div>

                                        <datalist id="listaUsuariosBD">
                                            <c:forEach items="${usuariosDisponibles}" var="dest">
                                                <option value="${dest.codigoEstudiantil}">${dest.nombreCompleto} (@${dest.username}) - ${dest.programaAcademico != null ? dest.programaAcademico : 'Estudiante UTS'}</option>
                                                <option value="${dest.username}">${dest.nombreCompleto} (Cód: ${dest.codigoEstudiantil})</option>
                                            </c:forEach>
                                        </datalist>

                                        <c:choose>
                                            <c:when test="${not empty destinatarioSeleccionado}">
                                                <div class="destinatario-verificado-card">
                                                    <div class="destinatario-avatar">
                                                        <c:choose>
                                                            <c:when test="${not empty destinatarioSeleccionado.fotoPerfil && destinatarioSeleccionado.fotoPerfil != 'avatar.jpg'}">
                                                                <img src="${pageContext.request.contextPath}/assets/images/${destinatarioSeleccionado.fotoPerfil}" alt="Avatar">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="user-avatar-initials">${destinatarioSeleccionado.nombreCompleto.substring(0, 1)}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="destinatario-info">
                                                        <div class="destinatario-badge-check">
                                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                            Destinatario Verificado en BD
                                                        </div>
                                                        <strong><c:out value="${destinatarioSeleccionado.nombreCompleto}"/></strong>
                                                        <span>Cód: <c:out value="${destinatarioSeleccionado.codigoEstudiantil}"/> &bull; @<c:out value="${destinatarioSeleccionado.username}"/> &bull; <c:out value="${destinatarioSeleccionado.programaAcademico}"/></span>
                                                    </div>
                                                    <a href="${pageContext.request.contextPath}/transferencias" class="btn-cambiar-destinatario" title="Cambiar destinatario">Cambiar</a>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="input-hint">Escribe para autocompletar desde la BD o usa el buscador superior para seleccionar.</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="input-block">
                                        <label for="monto" class="input-label">
                                            Monto a Transferir <span class="req">*</span>
                                        </label>
                                        <div class="input-control-wrap">
                                            <span class="input-icon-left">
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8"/><path d="M12 18V6"/></svg>
                                            </span>
                                            <input type="number" id="monto" name="monto" class="input-styled" step="0.01" min="1" placeholder="Ej: 500" required>
                                        </div>
                                        <div class="quick-amounts">
                                            <span class="quick-chip">Sugeridos: 500</span>
                                            <span class="quick-chip">1,000</span>
                                            <span class="quick-chip">2,000 DUTS</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="input-block" style="margin-bottom: 10px;">
                                    <label for="concepto" class="input-label">Concepto o Motivo</label>
                                    <div class="input-control-wrap">
                                        <span class="input-icon-left">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                        </span>
                                        <input type="text" id="concepto" name="concepto" class="input-styled" placeholder="Ej: Aporte fotocopias, cafetería UTS o trabajo colaborativo" maxlength="250">
                                    </div>
                                </div>

                                <div class="submit-btn-row">
                                    <button type="submit" class="btn-transfer-now">
                                        <span>Confirmar y Enviar DUTS</span>
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                                    </button>

                                    <div class="security-badge">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#16a34a" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                                        <span>Operación transaccional segura</span>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                </div>

                <div class="history-card">
                    <div class="history-header">
                        <h2>Historial de Transferencias Realizadas y Recibidas</h2>
                        <span class="history-count">
                            <c:out value="${transferencias != null ? transferencias.size() : 0}"/> transacciones registradas
                        </span>
                    </div>

                    <div class="table-wrap">
                        <c:choose>
                            <c:when test="${not empty transferencias}">
                                <table class="transfer-table">
                                    <thead>
                                        <tr>
                                            <th>Estado / Flujo</th>
                                            <th>Origen</th>
                                            <th>Destino</th>
                                            <th>Concepto</th>
                                            <th>Fecha y Hora</th>
                                            <th style="text-align: right;">Monto</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${transferencias}" var="t">
                                            <tr>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${t.esRemitente}">
                                                            <span class="flow-pill flow-sent">
                                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="7" y1="17" x2="17" y2="7"></line><polyline points="7 7 17 7 17 17"></polyline></svg>
                                                                ENVIADO
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="flow-pill flow-received">
                                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="17" y1="7" x2="7" y2="17"></line><polyline points="17 17 7 17 7 7"></polyline></svg>
                                                                RECIBIDO
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="user-col">
                                                        <span class="user-name-strong"><c:out value="${t.nombreOrigen}"/></span>
                                                        <span class="user-code-sub">COD: <c:out value="${t.codigoOrigen}"/></span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="user-col">
                                                        <span class="user-name-strong"><c:out value="${t.nombreDestino}"/></span>
                                                        <span class="user-code-sub">COD: <c:out value="${t.codigoDestino}"/></span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="concept-text"><c:out value="${t.concepto}"/></span>
                                                </td>
                                                <td>
                                                    <span class="date-text"><fmt:formatDate value="${t.fechaHora}" pattern="yyyy-MM-dd HH:mm"/></span>
                                                </td>
                                                <td class="amount-col">
                                                    <c:choose>
                                                        <c:when test="${t.esRemitente}">
                                                            <span class="amount-sent">-<fmt:formatNumber value="${t.monto}" minFractionDigits="2"/> DUTS</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="amount-recv">+<fmt:formatNumber value="${t.monto}" minFractionDigits="2"/> DUTS</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-history-box">
                                    <div class="empty-history-icon">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12V7H5a2 2 0 0 1 0-4h14v4"/><path d="M3 5v14a2 2 0 0 0 2 2h16v-5"/><path d="M18 12a2 2 0 0 0 0 4h4v-4Z"/></svg>
                                    </div>
                                    <h3>Aún no tienes transferencias registradas</h3>
                                    <p>Envía saldo a un compañero ingresando su código estudiantil o usuario en el formulario superior. Tu primera transferencia aparecerá aquí al instante.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
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
        <a href="${pageContext.request.contextPath}/transferencias" class="mobile-nav-item active" title="Transferencias">
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
        <a href="${pageContext.request.contextPath}/perfil" class="mobile-nav-item" title="Ajustes y Perfil">
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
    </script>
</body>
</html>
