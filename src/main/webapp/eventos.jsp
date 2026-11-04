<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, viewport-fit=cover">
    <title>Eventos y Recompensas DUTS - Unidades Tecnológicas de Santander</title>
    
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
            --uts-green-soft: #ecfdf5;
            --bg-canvas: #f8fafc;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-light: #e2e8f0;
            --border-hover: #cbd5e1;
            --white: #ffffff;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
            --card-shadow-hover: 0 12px 24px -4px rgba(0, 0, 0, 0.1), 0 6px 12px -4px rgba(0, 0, 0, 0.05);
            --danger: #dc2626;
            --success: #16a34a;
        }

        * { box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 0; padding: 0; }
        body { background-color: var(--bg-canvas); color: var(--text-main); display: flex; flex-direction: column; min-height: 100vh; overflow-x: hidden; }

        .top-navbar {
            background-color: var(--white);
            height: 65px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 30px;
            border-bottom: 1px solid var(--border-light);
            position: sticky;
            top: 0;
            z-index: 50;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }
        .top-navbar-left { display: flex; align-items: center; gap: 20px; }
        .logo-container { display: flex; align-items: center; gap: 14px; text-decoration: none; }
        .logo-container img { height: 42px; object-fit: contain; }
        .logo-text-box { display: flex; flex-direction: column; }
        .logo-title { color: var(--uts-green); font-weight: 800; font-size: 19px; letter-spacing: 0.5px; line-height: 1.1; }
        .logo-subtitle { color: var(--uts-green-light); font-weight: 700; font-size: 11px; text-transform: uppercase; letter-spacing: 1.2px; }

        .top-navbar-right { display: flex; align-items: center; gap: 24px; font-size: 14px; }
        .balance-chip-nav {
            background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 100%);
            border: 1px solid #86efac;
            padding: 6px 14px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: #14532d;
        }
        .balance-chip-nav strong { font-weight: 800; }
        .user-menu {
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
            color: var(--uts-green);
            text-decoration: none;
            padding: 4px 8px;
            border-radius: 8px;
            transition: background 0.2s;
        }
        .user-menu:hover { background-color: #f1f5f9; }
        .user-menu img { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--uts-green-light); }

        .main-wrapper { display: flex; flex: 1; min-height: calc(100vh - 65px); }
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

        .content-area { flex: 1; padding: 32px; overflow-y: auto; }
        .container { max-width: 1240px; margin: 0 auto; }

        .alert {
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 24px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .alert-success { background-color: #f0fdf4; color: #166534; border: 1.5px solid #86efac; }
        .alert-error { background-color: #fef2f2; color: #991b1b; border: 1.5px solid #fecaca; }

        .events-hero-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 26px;
            gap: 20px;
            flex-wrap: wrap;
        }
        .hero-title-box h1 {
            font-size: 26px;
            font-weight: 800;
            color: var(--uts-green-dark);
            letter-spacing: -0.5px;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .hero-title-box p {
            font-size: 14px;
            color: var(--text-muted);
        }
        .hero-badges-group {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .badge-api-live {
            background: #e0f2fe;
            color: #0369a1;
            border: 1px solid #bae6fd;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-view-api {
            background: #f8fafc;
            color: var(--uts-green);
            border: 1px solid var(--border-light);
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-view-api:hover {
            background: var(--uts-green-soft);
            border-color: #86efac;
        }

        .kpi-grid-4 {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 28px;
        }
        @media (max-width: 1024px) { .kpi-grid-4 { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 600px) { .kpi-grid-4 { grid-template-columns: 1fr; } }

        .kpi-card {
            background: var(--white);
            border: 1px solid var(--border-light);
            border-radius: 14px;
            padding: 20px;
            box-shadow: var(--card-shadow);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .kpi-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--card-shadow-hover);
        }
        .kpi-card.highlight-events {
            background: linear-gradient(135deg, #1b3d21 0%, #2f5c35 100%);
            color: white;
            border-color: #1b3d21;
        }
        .kpi-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
        }
        .kpi-label {
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--text-muted);
        }
        .highlight-events .kpi-label { color: rgba(255,255,255,0.75); }
        .kpi-icon-badge {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f1f5f9;
            color: var(--uts-green);
        }
        .highlight-events .kpi-icon-badge {
            background: rgba(255,255,255,0.15);
            color: #ffffff;
        }
        .kpi-value {
            font-size: 24px;
            font-weight: 800;
            color: var(--text-main);
            letter-spacing: -0.5px;
            margin-bottom: 4px;
        }
        .highlight-events .kpi-value { color: #ffffff; }
        .kpi-value-currency { font-size: 13.5px; font-weight: 700; margin-left: 3px; color: var(--text-muted); }
        .highlight-events .kpi-value-currency { color: rgba(255,255,255,0.8); }
        .kpi-subtext { font-size: 11.5px; color: var(--text-muted); }
        .highlight-events .kpi-subtext { color: rgba(255,255,255,0.7); }

        .catalog-toolbar {
            background: var(--white);
            border: 1px solid var(--border-light);
            border-radius: 14px;
            padding: 16px 20px;
            margin-bottom: 25px;
            box-shadow: var(--card-shadow);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }
        .category-tabs {
            display: flex;
            align-items: center;
            gap: 6px;
            flex-wrap: wrap;
        }
        .category-tab-btn {
            font-size: 12.5px;
            font-weight: 700;
            padding: 7px 15px;
            border-radius: 20px;
            text-decoration: none;
            color: var(--text-muted);
            background: #f1f5f9;
            transition: all 0.2s;
        }
        .category-tab-btn:hover {
            background: #e2e8f0;
            color: var(--text-main);
        }
        .category-tab-btn.active {
            background: var(--uts-green);
            color: white;
            box-shadow: 0 2px 6px rgba(47, 92, 53, 0.3);
        }

        .api-network-banner {
            background: linear-gradient(135deg, #0e2913 0%, #17361a 50%, #1e4522 100%);
            border: 1px solid rgba(140, 184, 43, 0.4);
            border-radius: 14px;
            padding: 16px 20px;
            margin-bottom: 22px;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
            box-shadow: 0 4px 14px rgba(27, 61, 33, 0.12);
        }
        .api-network-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .api-pulse-dot {
            width: 11px;
            height: 11px;
            border-radius: 50%;
            background: #22c55e;
            box-shadow: 0 0 0 0 rgba(34, 197, 94, 0.7);
            animation: apiPulse 2s infinite;
            flex-shrink: 0;
        }
        @keyframes apiPulse {
            0% { box-shadow: 0 0 0 0 rgba(34, 197, 94, 0.7); }
            70% { box-shadow: 0 0 0 8px rgba(34, 197, 94, 0); }
            100% { box-shadow: 0 0 0 0 rgba(34, 197, 94, 0); }
        }
        .api-network-title {
            font-size: 14px;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: 0.3px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .api-network-subtitle {
            font-size: 12px;
            color: #c4e477;
            margin-top: 3px;
        }
        .api-endpoint-badge {
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.25);
            color: #ffffff;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }
        .api-endpoint-badge:hover {
            background: rgba(140, 184, 43, 0.25);
            border-color: #8cb82b;
            color: #c4e477;
            transform: translateY(-1px);
        }

        .university-filter-row {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 12px 16px;
            background: #ffffff;
            border: 1px solid var(--border-light);
            border-radius: 12px;
            margin-bottom: 14px;
            flex-wrap: wrap;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }
        .uni-filter-label {
            font-size: 11.5px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 6px;
            margin-right: 6px;
        }
        .uni-tabs {
            display: flex;
            align-items: center;
            gap: 6px;
            flex-wrap: wrap;
        }
        .uni-tab-pill {
            font-size: 12px;
            font-weight: 700;
            padding: 6px 14px;
            border-radius: 20px;
            text-decoration: none;
            color: #475569;
            background: #f8fafc;
            border: 1px solid var(--border-light);
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .uni-tab-pill:hover {
            background: #f1f5f9;
            border-color: var(--border-hover);
            color: var(--text-main);
            transform: translateY(-1px);
        }
        .uni-tab-pill.active {
            background: #0f172a;
            color: #ffffff;
            border-color: #0f172a;
            box-shadow: 0 2px 6px rgba(15, 23, 42, 0.25);
        }
        .uni-tab-pill.pill-uts.active {
            background: linear-gradient(135deg, #1b3d21 0%, #2f5c35 100%);
            border-color: #8cb82b;
            color: #ffffff;
            box-shadow: 0 2px 8px rgba(47, 92, 53, 0.35);
        }
        .uni-tab-pill.pill-uis.active {
            background: linear-gradient(135deg, #0c2340 0%, #1e3a8a 100%);
            border-color: #3b82f6;
            color: #ffffff;
            box-shadow: 0 2px 8px rgba(30, 58, 138, 0.35);
        }
        .uni-tab-pill.pill-unab.active {
            background: linear-gradient(135deg, #881337 0%, #b91c1c 100%);
            border-color: #f43f5e;
            color: #ffffff;
            box-shadow: 0 2px 8px rgba(185, 28, 28, 0.35);
        }
        .uni-tab-pill.pill-udes.active {
            background: linear-gradient(135deg, #155e75 0%, #0284c7 100%);
            border-color: #38bdf8;
            color: #ffffff;
            box-shadow: 0 2px 8px rgba(2, 132, 199, 0.35);
        }
        .uni-tab-pill.pill-ascun.active {
            background: linear-gradient(135deg, #064e3b 0%, #047857 100%);
            border-color: #10b981;
            color: #ffffff;
            box-shadow: 0 2px 8px rgba(4, 120, 87, 0.35);
        }

        .uni-badge-card {
            font-size: 10.5px;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 20px;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.25);
        }
        .uni-badge-uts {
            background: linear-gradient(135deg, #17361a 0%, #2f5c35 100%);
            color: #eafbe7;
            border: 1.5px solid #8cb82b;
        }
        .uni-badge-uis {
            background: linear-gradient(135deg, #0b1f36 0%, #1e3a8a 100%);
            color: #fed7aa;
            border: 1.5px solid #60a5fa;
        }
        .uni-badge-unab {
            background: linear-gradient(135deg, #701a24 0%, #991b1b 100%);
            color: #ffe4e6;
            border: 1.5px solid #fb7185;
        }
        .uni-badge-udes {
            background: linear-gradient(135deg, #0e4c63 0%, #0369a1 100%);
            color: #e0f2fe;
            border: 1.5px solid #38bdf8;
        }
        .uni-badge-ascun {
            background: linear-gradient(135deg, #043d2f 0%, #047857 100%);
            color: #d1fae5;
            border: 1.5px solid #34d399;
        }

        .search-catalog-form {
            display: flex;
            align-items: center;
            gap: 8px;
            flex: 1;
            max-width: 400px;
        }
        .search-catalog-wrap {
            position: relative;
            flex: 1;
            display: flex;
            align-items: center;
        }
        .search-catalog-icon {
            position: absolute;
            left: 12px;
            color: #94a3b8;
            pointer-events: none;
        }
        .search-catalog-input {
            width: 100%;
            padding: 8px 12px 8px 36px;
            border: 1.5px solid var(--border-light);
            border-radius: 8px;
            font-size: 13px;
            background: #f8fafc;
            color: var(--text-main);
            transition: all 0.2s;
        }
        .search-catalog-input:focus {
            outline: none;
            background: #ffffff;
            border-color: var(--uts-green-light);
            box-shadow: 0 0 0 3px rgba(140, 184, 43, 0.2);
        }
        .btn-search-catalog {
            background: var(--uts-green);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 12.5px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-search-catalog:hover { background: var(--uts-green-dark); }
        .btn-clear-catalog {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            padding: 8px 10px;
            border-radius: 6px;
            background: #f1f5f9;
        }

        .events-grid-styled {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 35px;
        }
        @media (max-width: 768px) {
            .events-grid-styled { grid-template-columns: 1fr; }
        }

        .event-card-modern {
            background: var(--white);
            border: 1px solid var(--border-light);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            display: flex;
            flex-direction: column;
            transition: transform 0.25s cubic-bezier(0.16, 1, 0.3, 1), box-shadow 0.25s ease;
            position: relative;
        }
        .event-card-modern:hover {
            transform: translateY(-5px);
            box-shadow: var(--card-shadow-hover);
            border-color: var(--border-hover);
        }

        .event-hero-banner {
            height: 185px;
            position: relative;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 14px;
        }
        .event-hero-banner::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(0,0,0,0.3) 0%, rgba(0,0,0,0) 40%, rgba(0,0,0,0.7) 100%);
            pointer-events: none;
        }
        .banner-top-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            z-index: 2;
        }
        .event-category-pill {
            background: rgba(15, 23, 42, 0.75);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            color: #ffffff;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 11px;
            border-radius: 20px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: 1px solid rgba(255, 255, 255, 0.25);
        }
        .reward-badge-floating {
            background: linear-gradient(135deg, #15803d 0%, #16a34a 100%);
            color: #ffffff;
            font-size: 13px;
            font-weight: 800;
            padding: 5px 12px;
            border-radius: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
            display: inline-flex;
            align-items: center;
            gap: 5px;
            border: 1.5px solid rgba(255,255,255,0.4);
            letter-spacing: 0.3px;
        }
        .banner-bottom-row {
            position: relative;
            z-index: 2;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .spots-badge-overlay {
            background: rgba(0, 0, 0, 0.65);
            backdrop-filter: blur(4px);
            color: #f1f5f9;
            font-size: 11px;
            font-weight: 600;
            padding: 3px 9px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .event-body-styled {
            padding: 20px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .event-title-styled {
            font-size: 17px;
            font-weight: 800;
            color: var(--text-main);
            line-height: 1.25;
            margin-bottom: 8px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .event-desc-styled {
            font-size: 13px;
            color: var(--text-muted);
            line-height: 1.45;
            margin-bottom: 16px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .event-location-box {
            background: #f8fafc;
            border: 1px solid var(--border-light);
            border-radius: 10px;
            padding: 10px 12px;
            margin-bottom: 18px;
            display: flex;
            flex-direction: column;
            gap: 6px;
            font-size: 11.5px;
        }
        .loc-row {
            display: flex;
            align-items: flex-start;
            gap: 7px;
            line-height: 1.35;
        }
        .loc-icon {
            color: var(--uts-green);
            flex-shrink: 0;
            margin-top: 1px;
        }
        .loc-text {
            color: #334155;
            font-weight: 600;
        }
        .address-highlight {
            color: #0369a1;
            font-weight: 600;
            background: #f0f9ff;
            padding: 2px 6px;
            border-radius: 4px;
            border: 1px solid #e0f2fe;
            display: inline-block;
        }

        .event-actions-footer {
            padding-top: 15px;
            border-top: 1px solid #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        .btn-register-event {
            width: 100%;
            background: linear-gradient(135deg, var(--uts-green) 0%, var(--uts-green-dark) 100%);
            color: white;
            border: none;
            padding: 11px 16px;
            border-radius: 8px;
            font-size: 13.5px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 4px 10px rgba(47, 92, 53, 0.2);
        }
        .btn-register-event:hover {
            background: linear-gradient(135deg, var(--uts-green-light) 0%, var(--uts-green) 100%);
            box-shadow: 0 6px 14px rgba(140, 184, 43, 0.35);
            transform: translateY(-1px);
        }

        .enrolled-actions-wrap {
            display: flex;
            flex-direction: column;
            gap: 8px;
            width: 100%;
        }
        .enrolled-badge-status {
            background: #ecfdf5;
            color: #047857;
            border: 1.5px solid #a7f3d0;
            padding: 6px 10px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        .enrolled-btns-row {
            display: flex;
            gap: 8px;
        }
        .btn-claim-duts {
            flex: 1;
            background: linear-gradient(135deg, #15803d 0%, #16a34a 100%);
            color: white;
            border: none;
            padding: 9px 12px;
            border-radius: 7px;
            font-size: 12.5px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            transition: all 0.2s;
            box-shadow: 0 3px 8px rgba(22, 163, 74, 0.25);
        }
        .btn-claim-duts:hover {
            background: #15803d;
            box-shadow: 0 4px 10px rgba(22, 163, 74, 0.35);
        }
        .btn-cancel-enroll {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
            padding: 9px 12px;
            border-radius: 7px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-cancel-enroll:hover {
            background: #dc2626;
            color: white;
        }

        .event-card-modern {
            cursor: pointer;
        }
        .event-datetime-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 4px 10px;
            font-size: 11.5px;
            font-weight: 700;
            color: #334155;
            margin-bottom: 8px;
            flex-wrap: wrap;
        }
        .click-info-badge {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.35);
            color: #ffffff;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.2s;
        }
        .event-card-modern:hover .click-info-badge {
            background: #8cb82b;
            color: #0f2e1b;
            border-color: #8cb82b;
            transform: scale(1.05);
        }

        .modal-event-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.75);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            z-index: 99999;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 16px;
            opacity: 0;
            transition: opacity 0.25s ease;
        }
        .modal-event-backdrop.active {
            opacity: 1;
        }
        .modal-event-dialog {
            background: #ffffff;
            border-radius: 24px;
            max-width: 620px;
            width: 100%;
            max-height: 90vh;
            overflow-y: auto;
            position: relative;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.45);
            border: 1px solid rgba(255, 255, 255, 0.4);
            transform: scale(0.94) translateY(15px);
            transition: transform 0.25s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .modal-event-backdrop.active .modal-event-dialog {
            transform: scale(1) translateY(0);
        }
        .modal-close-btn {
            position: absolute;
            top: 14px;
            right: 14px;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: rgba(0, 0, 0, 0.65);
            color: #ffffff;
            border: none;
            font-size: 22px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10;
            transition: background 0.2s, transform 0.2s;
            backdrop-filter: blur(4px);
            line-height: 1;
        }
        .modal-close-btn:hover {
            background: rgba(0, 0, 0, 0.9);
            transform: scale(1.08);
        }
        .modal-event-banner {
            height: 220px;
            background-size: cover;
            background-position: center;
            position: relative;
            border-radius: 24px 24px 0 0;
        }
        .modal-event-banner::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(0,0,0,0.3) 0%, rgba(0,0,0,0.1) 40%, rgba(15,23,42,0.85) 100%);
            border-radius: 24px 24px 0 0;
        }
        .modal-banner-overlay {
            position: relative;
            z-index: 2;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 16px 20px;
        }
        .modal-badges-row {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }
        .modal-banner-bottom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            flex-wrap: wrap;
        }
        .modal-mode-badge {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(8px);
            color: #ffffff;
            font-size: 11.5px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .modal-event-body {
            padding: 24px;
        }
        .modal-org-sub {
            font-size: 12px;
            font-weight: 800;
            color: var(--uts-green);
            text-transform: uppercase;
            letter-spacing: 0.6px;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .modal-event-title {
            font-size: 22px;
            font-weight: 800;
            color: #0f172a;
            line-height: 1.3;
            margin-bottom: 12px;
        }
        .modal-event-desc {
            font-size: 14.5px;
            color: #475569;
            line-height: 1.6;
            margin-bottom: 20px;
        }
        .modal-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin-bottom: 20px;
        }
        @media (max-width: 600px) {
            .modal-info-grid { grid-template-columns: 1fr; }
            .modal-event-dialog {
                border-radius: 24px 24px 0 0;
                max-height: 92vh;
                margin-top: auto;
                transform: translateY(100%);
            }
            .modal-event-backdrop {
                padding: 0;
                align-items: flex-end;
            }
            .modal-event-backdrop.active .modal-event-dialog {
                transform: translateY(0);
            }
        }
        .modal-info-card {
            background: #f8fafc;
            border: 1.5px solid #e2e8f0;
            border-radius: 14px;
            padding: 14px 16px;
            display: flex;
            gap: 12px;
            align-items: flex-start;
        }
        .modal-info-card.highlight-time {
            border-color: #cbd5e1;
            background: linear-gradient(145deg, #f8fafc 0%, #f1f5f9 100%);
        }
        .modal-info-card.highlight-loc {
            border-color: #cbd5e1;
            background: linear-gradient(145deg, #f8fafc 0%, #f1f5f9 100%);
        }
        .modal-info-icon {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .modal-info-icon.time-icon {
            background: #fef3c7;
            color: #b45309;
        }
        .modal-info-icon.loc-icon {
            background: #e0f2fe;
            color: #0369a1;
        }
        .modal-info-content {
            flex: 1;
            min-width: 0;
        }
        .modal-info-label {
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            margin-bottom: 4px;
        }
        .modal-info-main {
            font-size: 13.5px;
            font-weight: 800;
            color: #0f172a;
            line-height: 1.35;
            margin-bottom: 4px;
        }
        .modal-info-sub {
            font-size: 12.5px;
            color: #475569;
            line-height: 1.4;
        }
        .time-pill {
            display: inline-block;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            padding: 3px 8px;
            border-radius: 6px;
            font-weight: 600;
            color: #1e293b;
            margin-top: 4px;
        }
        .btn-open-maps {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            margin-top: 6px;
            font-size: 11.5px;
            font-weight: 700;
            color: #0284c7;
            text-decoration: none;
            padding: 4px 9px;
            background: #f0f9ff;
            border-radius: 6px;
            border: 1px solid #bae6fd;
            transition: all 0.15s;
        }
        .btn-open-maps:hover {
            background: #e0f2fe;
            color: #0369a1;
        }
        .modal-meta-box {
            background: #f0fdf4;
            border: 1.5px solid #bbf7d0;
            border-radius: 12px;
            padding: 14px 16px;
            margin-bottom: 22px;
        }
        .modal-meta-row {
            font-size: 13px;
            color: #166534;
            line-height: 1.5;
            margin-bottom: 6px;
        }
        .modal-meta-row:last-child {
            margin-bottom: 0;
        }
        .modal-actions-footer {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        .btn-modal-enroll {
            flex: 1;
            background: linear-gradient(135deg, #1b3d21 0%, #2f5c35 100%);
            color: #ffffff;
            border: 1px solid #8cb82b;
            padding: 13px 20px;
            border-radius: 12px;
            font-size: 14.5px;
            font-weight: 800;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s;
            box-shadow: 0 4px 12px rgba(27, 61, 33, 0.25);
        }
        .btn-modal-enroll:hover {
            background: linear-gradient(135deg, #15361a 0%, #244c2a 100%);
            box-shadow: 0 6px 16px rgba(27, 61, 33, 0.35);
            transform: translateY(-1px);
        }
        .btn-modal-close {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #cbd5e1;
            padding: 13px 18px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-modal-close:hover {
            background: #e2e8f0;
            color: #0f172a;
        }

        .empty-events-box {
            padding: 70px 20px;
            text-align: center;
            background: var(--white);
            border: 1px solid var(--border-light);
            border-radius: 16px;
            box-shadow: var(--card-shadow);
            color: var(--text-muted);
        }

        .admin-section-box {
            background: var(--white);
            border: 1px solid var(--border-light);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 30px;
            box-shadow: var(--card-shadow);
        }
        .admin-header-title {
            font-size: 17px;
            font-weight: 800;
            color: var(--uts-green);
            margin-bottom: 18px;
            padding-bottom: 12px;
            border-bottom: 1px solid #f1f5f9;
        }
        .admin-form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 16px;
            margin-bottom: 16px;
        }
        .admin-input-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .admin-input-group label {
            font-size: 12.5px;
            font-weight: 700;
            color: var(--text-main);
        }
        .admin-input-field {
            padding: 10px 14px;
            border: 1.5px solid var(--border-light);
            border-radius: 8px;
            font-size: 13.5px;
            background: #f8fafc;
        }
        .admin-input-field:focus {
            outline: none;
            background: #ffffff;
            border-color: var(--uts-green-light);
        }
        .styled-table-admin {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        .styled-table-admin th {
            background: #f8fafc;
            color: var(--text-muted);
            font-size: 11.5px;
            font-weight: 700;
            text-transform: uppercase;
            padding: 12px 14px;
            border-bottom: 1.5px solid var(--border-light);
        }
        .styled-table-admin td {
            padding: 12px 14px;
            border-bottom: 1px solid var(--border-light);
            vertical-align: middle;
        }
        .badge-status-activo {
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 700;
            background: #dcfce7;
            color: #15803d;
            display: inline-block;
        }
        .badge-status-inactivo {
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 700;
            background: #f1f5f9;
            color: #64748b;
            display: inline-block;
        }

        .institutional-note-banner {
            background: #f8fafc;
            border: 1px solid var(--border-light);
            border-radius: 12px;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 14px;
            color: var(--text-muted);
            font-size: 12.5px;
            line-height: 1.45;
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
            .logo-subtitle,
            .top-navbar-right > span {
                display: none !important;
            }
            .logo-container img {
                height: 32px !important;
            }
            .logo-title {
                font-size: 17px !important;
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
            .balance-chip-nav {
                padding: 4px 10px !important;
                font-size: 12px !important;
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

            .page-hero-banner {
                padding: 18px 16px !important;
                border-radius: 18px !important;
            }
            .events-catalog-grid {
                grid-template-columns: 1fr !important;
                gap: 16px !important;
            }
            .event-catalog-card {
                border-radius: 18px !important;
            }
            .filter-bar-catalog {
                flex-direction: column !important;
                align-items: stretch !important;
                gap: 10px !important;
            }
            .uni-filters-row {
                overflow-x: auto !important;
                padding-bottom: 6px !important;
                flex-wrap: nowrap !important;
            }
            .uni-filter-btn {
                flex-shrink: 0 !important;
                padding: 6px 12px !important;
                border-radius: 20px !important;
            }
            .admin-crud-card {
                border-radius: 18px !important;
                padding: 18px 16px !important;
            }
            .crud-form-grid {
                grid-template-columns: 1fr !important;
            }
        }
    </style>
</head>
<body>

    <header class="top-navbar">
        <div class="top-navbar-left">
            <button type="button" class="nav-icon-menu" id="btnToggleSidebar" aria-label="Menú">&#9776;</button>
            <a href="${pageContext.request.contextPath}/dashboard" class="logo-container" title="Ir a Inicio UTS">
                <img src="${pageContext.request.contextPath}/assets/images/logouts.png" alt="DUTS UTS">
                <div class="logo-text-box">
                    <span class="logo-title">DUTS</span>
                    <span class="logo-subtitle">Unidades Tecnológicas de Santander</span>
                </div>
            </a>
        </div>
        <div class="top-navbar-right">
            <div class="balance-chip-nav">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><path d="M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8"/><path d="M12 18V6"/></svg>
                <span>Saldo Actual: <strong><fmt:formatNumber value="${saldo}" minFractionDigits="2" maxFractionDigits="2"/> DUTS</strong></span>
            </div>
            <a href="${pageContext.request.contextPath}/perfil" class="user-menu" title="Ver mi perfil institucional">
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
                        <a href="${pageContext.request.contextPath}/transferencias">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="7" y1="17" x2="17" y2="7"></line><polyline points="7 7 17 7 17 17"></polyline></svg>
                            </span>
                            <span>Transferencias DUTS</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/eventos" class="active">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            </span>
                            <span>Eventos y Recompensas</span>
                            <span class="active-pip"></span>
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

                <c:if test="${not empty flashSuccess}">
                    <div class="alert alert-success">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        <div><strong>¡Operación exitosa!</strong> <c:out value="${flashSuccess}"/></div>
                    </div>
                </c:if>
                <c:if test="${not empty flashError}">
                    <div class="alert alert-error">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        <div><strong>Atención:</strong> <c:out value="${flashError}"/></div>
                    </div>
                </c:if>

                <div class="events-hero-header">
                    <div class="hero-title-box">
                        <h1>
                            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="var(--uts-green)" stroke-width="2.5"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            Eventos Institucionales y Puntos DUTS
                        </h1>
                        <p>Inscríbete en talleres, conferencias y torneos universitarios de Bucaramanga para sumar DUTS a tu billetera</p>
                    </div>
                    <div class="hero-badges-group">
                        <span class="badge-api-live">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                            API Bucaramanga Conectada
                        </span>
                        <a href="${pageContext.request.contextPath}/api/eventos/bucaramanga" target="_blank" class="btn-view-api" title="Consultar el endpoint REST institucional">
                            <span>Ver API JSON ↗</span>
                        </a>
                    </div>
                </div>

                <div class="kpi-grid-4">
                    <div class="kpi-card highlight-events">
                        <div class="kpi-header">
                            <span class="kpi-label">Eventos Activos</span>
                            <div class="kpi-icon-badge">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/></svg>
                            </div>
                        </div>
                        <div>
                            <div class="kpi-value">
                                <c:out value="${totalEventosDisponibles}"/>
                                <span class="kpi-value-currency">EVENTOS</span>
                            </div>
                            <div class="kpi-subtext">Catálogo abierto para inscripción</div>
                        </div>
                    </div>

                    <div class="kpi-card">
                        <div class="kpi-header">
                            <span class="kpi-label">Recompensas Totales</span>
                            <div class="kpi-icon-badge" style="background: #f0fdf4; color: #16a34a;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            </div>
                        </div>
                        <div>
                            <div class="kpi-value" style="color: #16a34a;">
                                +<fmt:formatNumber value="${totalRecompensas}" minFractionDigits="0"/>
                                <span class="kpi-value-currency">DUTS</span>
                            </div>
                            <div class="kpi-subtext">Puntos disponibles para ganar</div>
                        </div>
                    </div>

                    <div class="kpi-card">
                        <div class="kpi-header">
                            <span class="kpi-label">Mis Inscripciones</span>
                            <div class="kpi-icon-badge" style="background: #f8fafc; color: var(--uts-green);">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="8.5" cy="7" r="4"></circle><polyline points="17 11 19 13 23 9"></polyline></svg>
                            </div>
                        </div>
                        <div>
                            <div class="kpi-value">
                                <c:out value="${misInscritosCount}"/>
                                <span class="kpi-value-currency">ACTIVAS</span>
                            </div>
                            <div class="kpi-subtext">Listas para reclamar recompensa</div>
                        </div>
                    </div>

                    <div class="kpi-card">
                        <div class="kpi-header">
                            <span class="kpi-label">Sede Universitaria</span>
                            <div class="kpi-icon-badge" style="background: #e0f2fe; color: #0284c7;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                            </div>
                        </div>
                        <div>
                            <div class="kpi-value" style="font-size: 19px;">
                                Bucaramanga
                            </div>
                            <div class="kpi-subtext">Campus Real de Minas y Sedes</div>
                        </div>
                    </div>
                </div>

                <div class="api-network-banner">
                    <div class="api-network-left">
                        <div class="api-pulse-dot" title="Conexión en tiempo real con la Red Universitaria"></div>
                        <div>
                            <div class="api-network-title">
                                Red Abierta de Eventos Universitarios de Bucaramanga y Santander
                            </div>
                            <div class="api-network-subtitle">
                                Conectado a las APIs de UTS, UIS, UNAB, UDES y ASCUN Nodo Santander · Gana DUTS por participar
                            </div>
                        </div>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/api/eventos/bucaramanga" target="_blank" class="api-endpoint-badge" title="Explorar el endpoint JSON de la Red Universitaria">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"></polyline><polyline points="8 6 2 12 8 18"></polyline></svg>
                            <span>Ver API REST (JSON)</span>
                        </a>
                    </div>
                </div>

                <div class="university-filter-row">
                    <span class="uni-filter-label">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>
                        Universidad:
                    </span>
                    <div class="uni-tabs">
                        <a href="${pageContext.request.contextPath}/eventos?universidad=TODAS&categoria=${filtroCategoria}&buscar=${filtroBuscar}" class="uni-tab-pill ${filtroUniversidad == 'TODAS' ? 'active' : ''}">Todas</a>
                        <a href="${pageContext.request.contextPath}/eventos?universidad=UTS&categoria=${filtroCategoria}&buscar=${filtroBuscar}" class="uni-tab-pill pill-uts ${filtroUniversidad == 'UTS' ? 'active' : ''}">
                            <strong>UTS</strong> Unidades Tecnológicas
                        </a>
                        <a href="${pageContext.request.contextPath}/eventos?universidad=UIS&categoria=${filtroCategoria}&buscar=${filtroBuscar}" class="uni-tab-pill pill-uis ${filtroUniversidad == 'UIS' ? 'active' : ''}">
                            <strong>UIS</strong> Industrial Santander
                        </a>
                        <a href="${pageContext.request.contextPath}/eventos?universidad=UNAB&categoria=${filtroCategoria}&buscar=${filtroBuscar}" class="uni-tab-pill pill-unab ${filtroUniversidad == 'UNAB' ? 'active' : ''}">
                            <strong>UNAB</strong> Autónoma
                        </a>
                        <a href="${pageContext.request.contextPath}/eventos?universidad=UDES&categoria=${filtroCategoria}&buscar=${filtroBuscar}" class="uni-tab-pill pill-udes ${filtroUniversidad == 'UDES' ? 'active' : ''}">
                            <strong>UDES</strong> Santander
                        </a>
                        <a href="${pageContext.request.contextPath}/eventos?universidad=ASCUN&categoria=${filtroCategoria}&buscar=${filtroBuscar}" class="uni-tab-pill pill-ascun ${filtroUniversidad == 'ASCUN' ? 'active' : ''}">
                            <strong>ASCUN</strong> Deportes
                        </a>
                    </div>
                </div>

                <div class="catalog-toolbar">
                    <div class="category-tabs">
                        <a href="${pageContext.request.contextPath}/eventos?universidad=${filtroUniversidad}&categoria=TODOS&buscar=${filtroBuscar}" class="category-tab-btn ${filtroCategoria == 'TODOS' ? 'active' : ''}">Todos</a>
                        <a href="${pageContext.request.contextPath}/eventos?universidad=${filtroUniversidad}&categoria=Tecnología&buscar=${filtroBuscar}" class="category-tab-btn ${filtroCategoria == 'Tecnología' ? 'active' : ''}">Tecnología</a>
                        <a href="${pageContext.request.contextPath}/eventos?universidad=${filtroUniversidad}&categoria=Conferencias&buscar=${filtroBuscar}" class="category-tab-btn ${filtroCategoria == 'Conferencias' ? 'active' : ''}">Conferencias</a>
                        <a href="${pageContext.request.contextPath}/eventos?universidad=${filtroUniversidad}&categoria=Emprendimiento&buscar=${filtroBuscar}" class="category-tab-btn ${filtroCategoria == 'Emprendimiento' ? 'active' : ''}">Emprendimiento</a>
                        <a href="${pageContext.request.contextPath}/eventos?universidad=${filtroUniversidad}&categoria=Deportivos&buscar=${filtroBuscar}" class="category-tab-btn ${filtroCategoria == 'Deportivos' ? 'active' : ''}">Deportivos</a>
                        <a href="${pageContext.request.contextPath}/eventos?universidad=${filtroUniversidad}&categoria=Talleres&buscar=${filtroBuscar}" class="category-tab-btn ${filtroCategoria == 'Talleres' ? 'active' : ''}">Talleres</a>
                    </div>

                    <form action="${pageContext.request.contextPath}/eventos" method="GET" class="search-catalog-form">
                        <input type="hidden" name="universidad" value="${filtroUniversidad}">
                        <input type="hidden" name="categoria" value="${filtroCategoria}">
                        <div class="search-catalog-wrap">
                            <span class="search-catalog-icon">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                            </span>
                            <input type="text" name="buscar" value="${filtroBuscar}" placeholder="Buscar evento, lugar o dirección..." class="search-catalog-input">
                        </div>
                        <button type="submit" class="btn-search-catalog">Buscar</button>
                        <c:if test="${not empty filtroBuscar or filtroCategoria != 'TODOS' or filtroUniversidad != 'TODAS'}">
                            <a href="${pageContext.request.contextPath}/eventos" class="btn-clear-catalog">Limpiar</a>
                        </c:if>
                    </form>
                </div>

                <c:choose>
                    <c:when test="${not empty eventos}">
                        <div class="events-grid-styled">
                            <c:forEach items="${eventos}" var="ev">
                                <div class="event-card-modern">
                                    <c:set var="evImg" value="${not empty ev.imagenUrl ? ev.imagenUrl : 'evento_tecnologia.jpg'}"/>
                                    <div class="event-hero-banner" style="background-image: url('${pageContext.request.contextPath}/assets/images/${evImg}');">
                                        <div class="banner-top-row">
                                            <div style="display: flex; gap: 6px; align-items: center; flex-wrap: wrap;">
                                                <span class="uni-badge-card uni-badge-${ev.universidad.toLowerCase()}"><c:out value="${ev.universidad}"/></span>
                                                <span class="event-category-pill"><c:out value="${ev.categoria}"/></span>
                                            </div>
                                            <span class="reward-badge-floating">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                                +<fmt:formatNumber value="${ev.recompensaDuts}" minFractionDigits="0"/> DUTS
                                            </span>
                                        </div>
                                        <div class="banner-bottom-row">
                                            <span class="spots-badge-overlay">
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                                <c:out value="${ev.cupos}"/> cupos disponibles
                                            </span>
                                        </div>
                                    </div>

                                    <div class="event-body-styled">
                                        <div>
                                            <h3 class="event-title-styled" title="${ev.nombre}"><c:out value="${ev.nombre}"/></h3>
                                            <p class="event-desc-styled"><c:out value="${ev.descripcion}"/></p>

                                            <div class="event-location-box">
                                                <div class="loc-row">
                                                    <svg class="loc-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                                    <span class="loc-text"><c:out value="${ev.lugar}"/></span>
                                                </div>
                                                <div class="loc-row">
                                                    <svg class="loc-icon" style="color: #0284c7;" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"></polygon></svg>
                                                    <span class="address-highlight"><c:out value="${ev.direccion}"/></span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="event-actions-footer">
                                            <c:choose>
                                                <c:when test="${ev.inscrito}">
                                                    <div class="enrolled-actions-wrap">
                                                        <div class="enrolled-badge-status">
                                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                            Inscripción Confirmada
                                                        </div>
                                                        <div class="enrolled-btns-row">
                                                            <form action="${pageContext.request.contextPath}/eventos" method="POST" style="flex: 1;">
                                                                <input type="hidden" name="action" value="reclamar">
                                                                <input type="hidden" name="eventoId" value="${ev.id}">
                                                                <button type="submit" class="btn-claim-duts" title="Confirmar asistencia y abonar puntos a tu cuenta">
                                                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                                                    Reclamar +<fmt:formatNumber value="${ev.recompensaDuts}" minFractionDigits="0"/> DUTS
                                                                </button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/eventos" method="POST">
                                                                <input type="hidden" name="action" value="cancelar_inscripcion">
                                                                <input type="hidden" name="eventoId" value="${ev.id}">
                                                                <button type="submit" class="btn-cancel-enroll" title="Cancelar inscripción">Cancelar</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="${pageContext.request.contextPath}/eventos" method="POST" style="width: 100%;">
                                                        <input type="hidden" name="action" value="inscribir">
                                                        <input type="hidden" name="eventoId" value="${ev.id}">
                                                        <button type="submit" class="btn-register-event">
                                                            <span>Inscribirme y Ganar Puntos</span>
                                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                                                        </button>
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
                        <div class="empty-events-box">
                            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" stroke-width="1.5" style="margin-bottom: 12px;"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            <h3 style="font-size: 17px; font-weight: 700; color: var(--text-main); margin-bottom: 6px;">No se encontraron eventos institucionales</h3>
                            <p style="font-size: 13px;">No hay eventos que coincidan con la categoría o término de búsqueda seleccionado.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:if test="${esAdmin}">
                    <div class="admin-section-box">
                        <div class="admin-header-title">
                            <c:choose>
                                <c:when test="${not empty eventoEditar}">Editar Evento Institucional (#${eventoEditar.id})</c:when>
                                <c:otherwise>Crear Nuevo Evento Institucional (Panel Administrativo)</c:otherwise>
                            </c:choose>
                        </div>
                        <form action="${pageContext.request.contextPath}/eventos" method="POST">
                            <input type="hidden" name="action" value="${not empty eventoEditar ? 'actualizar' : 'crear'}">
                            <c:if test="${not empty eventoEditar}">
                                <input type="hidden" name="id" value="${eventoEditar.id}">
                            </c:if>

                            <div class="admin-form-grid">
                                <div class="admin-input-group">
                                    <label for="nombre">Nombre del Evento *</label>
                                    <input type="text" id="nombre" name="nombre" class="admin-input-field" value="${eventoEditar != null ? eventoEditar.nombre : ''}" required>
                                </div>
                                <div class="admin-input-group">
                                    <label for="universidad">Institución Universitaria *</label>
                                    <select id="universidad" name="universidad" class="admin-input-field" required>
                                        <option value="UTS" ${eventoEditar != null && eventoEditar.universidad == 'UTS' ? 'selected' : ''}>UTS - Unidades Tecnológicas de Santander</option>
                                        <option value="UIS" ${eventoEditar != null && eventoEditar.universidad == 'UIS' ? 'selected' : ''}>UIS - Universidad Industrial de Santander</option>
                                        <option value="UNAB" ${eventoEditar != null && eventoEditar.universidad == 'UNAB' ? 'selected' : ''}>UNAB - Universidad Autónoma de Bucaramanga</option>
                                        <option value="UDES" ${eventoEditar != null && eventoEditar.universidad == 'UDES' ? 'selected' : ''}>UDES - Universidad de Santander</option>
                                        <option value="ASCUN" ${eventoEditar != null && eventoEditar.universidad == 'ASCUN' ? 'selected' : ''}>ASCUN - Asociación Colombiana de Universidades</option>
                                    </select>
                                </div>
                                <div class="admin-input-group">
                                    <label for="categoria">Categoría *</label>
                                    <select id="categoria" name="categoria" class="admin-input-field" required>
                                        <option value="Tecnología" ${eventoEditar != null && eventoEditar.categoria == 'Tecnología' ? 'selected' : ''}>Tecnología</option>
                                        <option value="Conferencias" ${eventoEditar != null && eventoEditar.categoria == 'Conferencias' ? 'selected' : ''}>Conferencias</option>
                                        <option value="Emprendimiento" ${eventoEditar != null && eventoEditar.categoria == 'Emprendimiento' ? 'selected' : ''}>Emprendimiento</option>
                                        <option value="Deportivos" ${eventoEditar != null && eventoEditar.categoria == 'Deportivos' ? 'selected' : ''}>Deportivos</option>
                                        <option value="Talleres" ${eventoEditar != null && eventoEditar.categoria == 'Talleres' ? 'selected' : ''}>Talleres</option>
                                    </select>
                                </div>
                                <div class="admin-input-group">
                                    <label for="lugar">Lugar / Sede *</label>
                                    <input type="text" id="lugar" name="lugar" class="admin-input-field" value="${eventoEditar != null ? eventoEditar.lugar : ''}" required>
                                </div>
                                <div class="admin-input-group">
                                    <label for="direccion">Dirección Bucaramanga *</label>
                                    <input type="text" id="direccion" name="direccion" class="admin-input-field" value="${eventoEditar != null ? eventoEditar.direccion : ''}" required>
                                </div>
                                <div class="admin-input-group">
                                    <label for="recompensaDuts">Recompensa (DUTS) *</label>
                                    <input type="number" id="recompensaDuts" name="recompensaDuts" class="admin-input-field" step="10" min="10" value="${eventoEditar != null ? eventoEditar.recompensaDuts : '1000'}" required>
                                </div>
                                <div class="admin-input-group">
                                    <label for="cupos">Cupos Disponibles *</label>
                                    <input type="number" id="cupos" name="cupos" class="admin-input-field" min="1" value="${eventoEditar != null ? eventoEditar.cupos : '100'}" required>
                                </div>
                                <div class="admin-input-group">
                                    <label for="imagenUrl">Imagen Asociada (assets/images/) *</label>
                                    <select id="imagenUrl" name="imagenUrl" class="admin-input-field">
                                        <option value="evento_tecnologia.jpg" ${eventoEditar != null && eventoEditar.imagenUrl == 'evento_tecnologia.jpg' ? 'selected' : ''}>evento_tecnologia.jpg (Tecnología)</option>
                                        <option value="evento_conferencia.jpg" ${eventoEditar != null && eventoEditar.imagenUrl == 'evento_conferencia.jpg' ? 'selected' : ''}>evento_conferencia.jpg (Conferencias)</option>
                                        <option value="evento_emprendimiento.jpg" ${eventoEditar != null && eventoEditar.imagenUrl == 'evento_emprendimiento.jpg' ? 'selected' : ''}>evento_emprendimiento.jpg (Emprendimiento)</option>
                                        <option value="evento_deportes.jpg" ${eventoEditar != null && eventoEditar.imagenUrl == 'evento_deportes.jpg' ? 'selected' : ''}>evento_deportes.jpg (Deportivos)</option>
                                        <option value="evento_robotica.jpg" ${eventoEditar != null && eventoEditar.imagenUrl == 'evento_robotica.jpg' ? 'selected' : ''}>evento_robotica.jpg (Robótica)</option>
                                        <option value="evento-rally.jpg" ${eventoEditar != null && eventoEditar.imagenUrl == 'evento-rally.jpg' ? 'selected' : ''}>evento-rally.jpg (Rally)</option>
                                    </select>
                                </div>
                                <div class="admin-input-group">
                                    <label for="estado">Estado *</label>
                                    <select id="estado" name="estado" class="admin-input-field">
                                        <option value="ACTIVO" ${eventoEditar != null && eventoEditar.estado == 'ACTIVO' ? 'selected' : ''}>ACTIVO</option>
                                        <option value="INACTIVO" ${eventoEditar != null && eventoEditar.estado == 'INACTIVO' ? 'selected' : ''}>INACTIVO</option>
                                        <option value="FINALIZADO" ${eventoEditar != null && eventoEditar.estado == 'FINALIZADO' ? 'selected' : ''}>FINALIZADO</option>
                                    </select>
                                </div>
                            </div>

                            <div class="admin-input-group" style="margin-bottom: 18px;">
                                <label for="descripcion">Descripción Completa del Evento *</label>
                                <textarea id="descripcion" name="descripcion" class="admin-input-field" rows="3" required>${eventoEditar != null ? eventoEditar.descripcion : ''}</textarea>
                            </div>

                            <div style="display: flex; gap: 10px;">
                                <button type="submit" class="btn-register-event" style="width: auto; padding: 10px 22px;">
                                    <c:choose>
                                        <c:when test="${not empty eventoEditar}">Guardar Cambios</c:when>
                                        <c:otherwise>Publicar Evento Institucional</c:otherwise>
                                    </c:choose>
                                </button>
                                <c:if test="${not empty eventoEditar}">
                                    <a href="${pageContext.request.contextPath}/eventos" class="btn-clear-catalog" style="padding: 10px 18px;">Cancelar Edición</a>
                                </c:if>
                            </div>
                        </form>

                        <div style="margin-top: 30px;">
                            <h4 style="font-size: 14px; font-weight: 800; color: var(--text-main); margin-bottom: 12px;">Gestión de Todos los Eventos en Base de Datos</h4>
                            <div style="overflow-x: auto;">
                                <table class="styled-table-admin">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Institución</th>
                                            <th>Nombre</th>
                                            <th>Categoría</th>
                                            <th>Lugar</th>
                                            <th>Recompensa</th>
                                            <th>Cupos</th>
                                            <th>Estado</th>
                                            <th style="text-align: right;">Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${todosEventosAdmin != null ? todosEventosAdmin : eventos}" var="e">
                                            <tr>
                                                <td>#<c:out value="${e.id}"/></td>
                                                <td><span class="uni-badge-card uni-badge-${e.universidad.toLowerCase()}"><c:out value="${e.universidad}"/></span></td>
                                                <td><strong><c:out value="${e.nombre}"/></strong></td>
                                                <td><c:out value="${e.categoria}"/></td>
                                                <td><c:out value="${e.lugar}"/></td>
                                                <td style="color: #16a34a; font-weight: 700;">+<fmt:formatNumber value="${e.recompensaDuts}" minFractionDigits="0"/> DUTS</td>
                                                <td><c:out value="${e.cupos}"/></td>
                                                <td>
                                                    <span class="${e.estado == 'ACTIVO' ? 'badge-status-activo' : 'badge-status-inactivo'}">
                                                        <c:out value="${e.estado}"/>
                                                    </span>
                                                </td>
                                                <td style="text-align: right;">
                                                    <a href="${pageContext.request.contextPath}/eventos?editId=${e.id}" style="color: var(--uts-green); font-weight: 700; text-decoration: none; margin-right: 12px;">Editar</a>
                                                    <form action="${pageContext.request.contextPath}/eventos" method="POST" style="display: inline;">
                                                        <input type="hidden" name="action" value="eliminar">
                                                        <input type="hidden" name="id" value="${e.id}">
                                                        <button type="submit" style="background: none; border: none; color: #dc2626; font-weight: 700; cursor: pointer;">Eliminar</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:if>

                <div class="institutional-note-banner">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="var(--uts-green)" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    <div>
                        <strong>Acreditación Automática de DUTS:</strong>
                        Al inscribirte y asistir a cada evento institucional en Bucaramanga, los puntos DUTS son abonados directamente a tu billetera para circular en la plataforma universitaria.
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
        <a href="${pageContext.request.contextPath}/eventos" class="mobile-nav-item active" title="Eventos y Recompensas">
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
