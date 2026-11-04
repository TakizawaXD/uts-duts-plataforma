<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, viewport-fit=cover">
    <title>Extracto y Facturas Oficiales DUTS - Unidades Tecnológicas de Santander</title>
    
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
            --income-color: #16a34a;
            --income-bg: #f0fdf4;
            --income-border: #bbf7d0;
            --expense-color: #dc2626;
            --expense-bg: #fef2f2;
            --expense-border: #fecaca;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
            --card-shadow-hover: 0 10px 15px -3px rgba(0, 0, 0, 0.08), 0 4px 6px -4px rgba(0, 0, 0, 0.04);
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

        .statement-header-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 26px;
            gap: 20px;
            flex-wrap: wrap;
        }
        .statement-title-box h1 {
            font-size: 26px;
            font-weight: 800;
            color: var(--uts-green-dark);
            letter-spacing: -0.5px;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .statement-title-box p {
            font-size: 14px;
            color: var(--text-muted);
        }
        .header-actions-group {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .btn-action-pdf {
            background: linear-gradient(135deg, #b91c1c 0%, #991b1b 100%);
            color: white;
            border: none;
            padding: 10px 18px;
            font-size: 13.5px;
            font-weight: 700;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(185, 28, 28, 0.25);
            transition: all 0.2s;
        }
        .btn-action-pdf:hover {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(185, 28, 28, 0.35);
        }
        .btn-action-transfer {
            background: linear-gradient(135deg, var(--uts-green) 0%, var(--uts-green-dark) 100%);
            color: white;
            border: none;
            padding: 10px 18px;
            font-size: 13.5px;
            font-weight: 700;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(47, 92, 53, 0.25);
            transition: all 0.2s;
        }
        .btn-action-transfer:hover {
            background: linear-gradient(135deg, var(--uts-green-light) 0%, var(--uts-green) 100%);
            transform: translateY(-1px);
        }

        .kpi-grid-4 {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 28px;
        }
        @media (max-width: 1024px) {
            .kpi-grid-4 { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 600px) {
            .kpi-grid-4 { grid-template-columns: 1fr; }
        }

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
        .kpi-card.highlight-wallet {
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
        .highlight-wallet .kpi-label { color: rgba(255,255,255,0.75); }
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
        .highlight-wallet .kpi-icon-badge {
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
        .highlight-wallet .kpi-value { color: #ffffff; }
        .kpi-value-currency { font-size: 14px; font-weight: 700; margin-left: 3px; color: var(--text-muted); }
        .highlight-wallet .kpi-value-currency { color: rgba(255,255,255,0.8); }
        .kpi-subtext { font-size: 11.5px; color: var(--text-muted); }
        .highlight-wallet .kpi-subtext { color: rgba(255,255,255,0.7); }

        .text-income { color: var(--income-color) !important; }
        .text-expense { color: var(--expense-color) !important; }

        .statement-card {
            background: var(--white);
            border: 1px solid var(--border-light);
            border-radius: 16px;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .table-toolbar {
            padding: 18px 24px;
            border-bottom: 1px solid var(--border-light);
            background: #ffffff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }
        .filter-tabs {
            display: flex;
            background: #f1f5f9;
            padding: 4px;
            border-radius: 10px;
            gap: 4px;
        }
        .tab-btn {
            font-size: 12.5px;
            font-weight: 700;
            padding: 7px 16px;
            border-radius: 7px;
            text-decoration: none;
            color: var(--text-muted);
            transition: all 0.2s;
        }
        .tab-btn:hover { color: var(--text-main); }
        .tab-btn.active {
            background: var(--white);
            color: var(--uts-green);
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }

        .search-filter-form {
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
            max-width: 450px;
        }
        .search-input-wrap {
            position: relative;
            flex: 1;
            display: flex;
            align-items: center;
        }
        .search-icon {
            position: absolute;
            left: 12px;
            color: #94a3b8;
            pointer-events: none;
        }
        .search-field {
            width: 100%;
            padding: 9px 14px 9px 38px;
            border: 1.5px solid var(--border-light);
            border-radius: 8px;
            font-size: 13px;
            background: #f8fafc;
            color: var(--text-main);
            transition: all 0.2s;
        }
        .search-field:focus {
            outline: none;
            background: #ffffff;
            border-color: var(--uts-green-light);
            box-shadow: 0 0 0 3px rgba(140, 184, 43, 0.2);
        }
        .btn-filter-submit {
            background: var(--uts-green);
            color: white;
            border: none;
            padding: 9px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-filter-submit:hover { background: var(--uts-green-dark); }
        .btn-filter-clear {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            padding: 8px 10px;
            border-radius: 6px;
            background: #f1f5f9;
        }
        .btn-filter-clear:hover { background: #e2e8f0; }

        .table-responsive { width: 100%; overflow-x: auto; }
        .fintech-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13.5px;
            text-align: left;
        }
        .fintech-table th {
            background: #f8fafc;
            color: var(--text-muted);
            font-size: 11.5px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            padding: 14px 20px;
            border-bottom: 1.5px solid var(--border-light);
        }
        .fintech-table td {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-light);
            vertical-align: middle;
            transition: background 0.15s;
        }
        .fintech-table tr:hover td {
            background: #fbfcfe;
        }

        .ref-code-box {
            display: flex;
            flex-direction: column;
            gap: 3px;
        }
        .ref-code {
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
            font-size: 12px;
            font-weight: 700;
            color: #334155;
            background: #f1f5f9;
            padding: 3px 7px;
            border-radius: 5px;
            display: inline-block;
            border: 1px solid #e2e8f0;
            width: fit-content;
        }
        .ref-time {
            font-size: 11px;
            color: var(--text-muted);
        }

        .badge-type {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 11.5px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }
        .badge-type.ingreso {
            background: #f0fdf4;
            color: #15803d;
            border: 1.5px solid #86efac;
        }
        .badge-type.egreso {
            background: #fef2f2;
            color: #dc2626;
            border: 1.5px solid #fca5a5;
        }

        .desc-cell-title {
            font-weight: 700;
            color: var(--text-main);
            font-size: 13.5px;
            margin-bottom: 2px;
        }
        .desc-cell-sub {
            font-size: 11.5px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .amount-cell {
            font-size: 15px;
            font-weight: 800;
            text-align: right;
            white-space: nowrap;
        }
        .amount-cell.income { color: var(--income-color); }
        .amount-cell.expense { color: var(--expense-color); }

        .btn-download-factura {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
            padding: 6px 13px;
            border-radius: 7px;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s;
            white-space: nowrap;
        }
        .btn-download-factura:hover {
            background: #dc2626;
            color: #ffffff;
            border-color: #dc2626;
            box-shadow: 0 2px 6px rgba(220, 38, 38, 0.25);
        }

        .empty-ledger-state {
            padding: 60px 20px;
            text-align: center;
            color: var(--text-muted);
        }
        .empty-icon {
            width: 54px;
            height: 54px;
            border-radius: 50%;
            background: #f1f5f9;
            color: #94a3b8;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 14px;
        }
        .empty-title {
            font-size: 16px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 6px;
        }

        .institutional-footer-note {
            background: #f8fafc;
            border: 1px solid var(--border-light);
            border-radius: 12px;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            margin-top: 20px;
            color: var(--text-muted);
            font-size: 12.5px;
            line-height: 1.4;
        }
        .footer-note-icon {
            color: var(--uts-green);
            flex-shrink: 0;
        }

        @media print {
            .sidebar, .top-navbar, .header-actions-group, .table-toolbar, .btn-download-factura {
                display: none !important;
            }
            body, .content-area, .container {
                padding: 0 !important;
                margin: 0 !important;
                background: white !important;
            }
            .statement-card { border: none !important; box-shadow: none !important; }
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
                display: none !important;
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

            .stats-kpi-grid {
                grid-template-columns: repeat(2, 1fr) !important;
                gap: 10px !important;
            }
            .kpi-card {
                padding: 14px 12px !important;
                border-radius: 14px !important;
            }
            .kpi-val {
                font-size: 16px !important;
            }
            .statement-card {
                border-radius: 18px !important;
            }
            .statement-header {
                flex-direction: column !important;
                align-items: flex-start !important;
                gap: 14px !important;
                padding: 16px 14px !important;
            }
            .header-actions-group {
                width: 100% !important;
                flex-direction: column !important;
            }
            .header-actions-group a {
                width: 100% !important;
                justify-content: center !important;
                padding: 11px 14px !important;
                font-size: 13px !important;
            }
            .table-toolbar {
                padding: 12px 14px !important;
                flex-direction: column !important;
                align-items: stretch !important;
                gap: 10px !important;
            }
            .filter-form-wrap {
                flex-direction: column !important;
                gap: 8px !important;
            }
            .search-box-wrap {
                min-width: 100% !important;
            }
            .filter-select {
                width: 100% !important;
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
                        <a href="${pageContext.request.contextPath}/eventos">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            </span>
                            <span>Eventos y Recompensas</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/movimientos" class="active">
                            <span class="nav-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                            </span>
                            <span>Historial y Facturas</span>
                            <span class="active-pip"></span>
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

                <div class="statement-header-bar">
                    <div class="statement-title-box">
                        <h1>
                            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="var(--uts-green)" stroke-width="2.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                            Extracto Oficial y Facturación DUTS
                        </h1>
                        <p>Libro mayor institucional de ingresos, egresos y comprobantes fiscales de tu cuenta universitaria UTS</p>
                    </div>
                    <div class="header-actions-group">
                        <a href="${pageContext.request.contextPath}/factura/pdf" target="_blank" class="btn-action-pdf" title="Descargar extracto oficial consolidado en formato PDF">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
                            <span>Descargar Extracto (PDF)</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/transferencias" class="btn-action-transfer">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                            <span>Nueva Transferencia</span>
                        </a>
                    </div>
                </div>

                <div class="kpi-grid-4">
                    <div class="kpi-card highlight-wallet">
                        <div class="kpi-header">
                            <span class="kpi-label">Saldo Disponible</span>
                            <div class="kpi-icon-badge">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="2" y="4" width="20" height="16" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg>
                            </div>
                        </div>
                        <div>
                            <div class="kpi-value">
                                <fmt:formatNumber value="${saldo}" minFractionDigits="2" maxFractionDigits="2"/>
                                <span class="kpi-value-currency">DUTS</span>
                            </div>
                            <div class="kpi-subtext">Cuenta institucional activa</div>
                        </div>
                    </div>

                    <div class="kpi-card">
                        <div class="kpi-header">
                            <span class="kpi-label">Total Recibido</span>
                            <div class="kpi-icon-badge" style="background: #f0fdf4; color: #16a34a;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="19" x2="12" y2="5"></line><polyline points="5 12 12 5 19 12"></polyline></svg>
                            </div>
                        </div>
                        <div>
                            <div class="kpi-value text-income">
                                +<fmt:formatNumber value="${totalIngresos}" minFractionDigits="2" maxFractionDigits="2"/>
                                <span class="kpi-value-currency">DUTS</span>
                            </div>
                            <div class="kpi-subtext">Bonos, eventos y recibidos</div>
                        </div>
                    </div>

                    <div class="kpi-card">
                        <div class="kpi-header">
                            <span class="kpi-label">Total Enviado</span>
                            <div class="kpi-icon-badge" style="background: #fef2f2; color: #dc2626;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"></line><polyline points="19 12 12 19 5 12"></polyline></svg>
                            </div>
                        </div>
                        <div>
                            <div class="kpi-value text-expense">
                                -<fmt:formatNumber value="${totalEgresos}" minFractionDigits="2" maxFractionDigits="2"/>
                                <span class="kpi-value-currency">DUTS</span>
                            </div>
                            <div class="kpi-subtext">Transferencias a compañeros</div>
                        </div>
                    </div>

                    <div class="kpi-card">
                        <div class="kpi-header">
                            <span class="kpi-label">Movimientos</span>
                            <div class="kpi-icon-badge" style="background: #f8fafc; color: var(--uts-green);">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                            </div>
                        </div>
                        <div>
                            <div class="kpi-value">
                                <c:out value="${totalMovimientos}"/>
                                <span class="kpi-value-currency">REG</span>
                            </div>
                            <div class="kpi-subtext">Auditoría inmutable en BD</div>
                        </div>
                    </div>
                </div>

                <div class="statement-card">
                    <div class="table-toolbar">
                        <div class="filter-tabs">
                            <a href="${pageContext.request.contextPath}/movimientos?tipo=TODOS&buscar=${filtroBuscar}" class="tab-btn ${filtroTipo == 'TODOS' ? 'active' : ''}">Todos (${totalMovimientos})</a>
                            <a href="${pageContext.request.contextPath}/movimientos?tipo=INGRESO&buscar=${filtroBuscar}" class="tab-btn ${filtroTipo == 'INGRESO' ? 'active' : ''}">Recibidos</a>
                            <a href="${pageContext.request.contextPath}/movimientos?tipo=EGRESO&buscar=${filtroBuscar}" class="tab-btn ${filtroTipo == 'EGRESO' ? 'active' : ''}">Enviados</a>
                        </div>

                        <form action="${pageContext.request.contextPath}/movimientos" method="GET" class="search-filter-form">
                            <input type="hidden" name="tipo" value="${filtroTipo}">
                            <div class="search-input-wrap">
                                <span class="search-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                                </span>
                                <input type="text" name="buscar" value="${filtroBuscar}" placeholder="Filtrar por concepto o código de referencia..." class="search-field">
                            </div>
                            <button type="submit" class="btn-filter-submit">Filtrar</button>
                            <c:if test="${not empty filtroBuscar or filtroTipo != 'TODOS'}">
                                <a href="${pageContext.request.contextPath}/movimientos" class="btn-filter-clear">Limpiar</a>
                            </c:if>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <c:choose>
                            <c:when test="${not empty movimientos}">
                                <table class="fintech-table">
                                    <thead>
                                        <tr>
                                            <th>Referencia y Comprobante</th>
                                            <th>Tipo</th>
                                            <th>Descripción / Motivo Institucional</th>
                                            <th style="text-align: right;">Monto</th>
                                            <th style="text-align: center;">Factura Oficial</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${movimientos}" var="m">
                                            <tr>
                                                <td>
                                                    <div class="ref-code-box">
                                                        <span class="ref-code"><c:out value="${m.referencia}"/></span>
                                                        <span class="ref-time">
                                                            <fmt:formatDate value="${m.fechaHora}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                        </span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${m.tipo == 'INGRESO'}">
                                                            <span class="badge-type ingreso">
                                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="17" y1="7" x2="7" y2="17"></line><polyline points="17 17 7 17 7 7"></polyline></svg>
                                                                RECIBIDO
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-type egreso">
                                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="7" y1="17" x2="17" y2="7"></line><polyline points="7 7 17 7 17 17"></polyline></svg>
                                                                ENVIADO
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="desc-cell-title"><c:out value="${m.descripcion}"/></div>
                                                    <div class="desc-cell-sub">
                                                        <span>Registro validado en base de datos</span>
                                                        <span>&bull;</span>
                                                        <span>Folio #<c:out value="${m.id}"/></span>
                                                    </div>
                                                </td>
                                                <td class="amount-cell ${m.tipo == 'INGRESO' ? 'income' : 'expense'}">
                                                    <c:choose>
                                                        <c:when test="${m.tipo == 'INGRESO'}">
                                                            +<fmt:formatNumber value="${m.monto}" minFractionDigits="2" maxFractionDigits="2"/> DUTS
                                                        </c:when>
                                                        <c:otherwise>
                                                            -<fmt:formatNumber value="${m.monto}" minFractionDigits="2" maxFractionDigits="2"/> DUTS
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align: center;">
                                                    <a href="${pageContext.request.contextPath}/factura/pdf?id=${m.id}" target="_blank" class="btn-download-factura" title="Generar y descargar factura oficial en PDF de esta transacción">
                                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                                                        <span>Factura PDF</span>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-ledger-state">
                                    <div class="empty-icon">
                                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                    </div>
                                    <div class="empty-title">No se encontraron movimientos con los filtros aplicados</div>
                                    <p>Intenta restablecer la búsqueda o realizar una transferencia institucional para generar transacciones.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="institutional-footer-note">
                    <svg class="footer-note-icon" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    <div>
                        <strong>Certificación y Validez Fiscal Universitaria UTS:</strong>
                        Todas las facturas electrónicas y extractos generados en formato PDF cuentan con el sello de integridad institucional, código hash SHA-256 inmutable y respaldo del libro mayor de la plataforma DUTS.
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
        <a href="${pageContext.request.contextPath}/movimientos" class="mobile-nav-item active" title="Historial y Facturas">
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
