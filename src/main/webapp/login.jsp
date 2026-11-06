<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String xfProto = request.getHeader("X-Forwarded-Proto");
    String xfHost = request.getHeader("X-Forwarded-Host");
    String host = request.getHeader("Host");
    if (host == null || host.isEmpty()) {
        host = request.getServerName();
    }
    String scheme = (xfProto != null && !xfProto.isEmpty()) ? xfProto : request.getScheme();
    String serverName = (xfHost != null && !xfHost.isEmpty()) ? xfHost : host;

    if (serverName.contains("onrender.com")) {
        scheme = "https";
        if (serverName.contains(":")) {
            serverName = serverName.split(":")[0];
        }
    } else if (serverName.contains(":")) {
        if (serverName.endsWith(":80") || serverName.endsWith(":443")) {
            serverName = serverName.split(":")[0];
        }
    } else if (request.getServerPort() != 80 && request.getServerPort() != 443 && !serverName.contains(":")) {
        serverName = serverName + ":" + request.getServerPort();
    }
    
    String cPath = request.getContextPath();
    String appBaseUrl = scheme + "://" + serverName + cPath;
    String ogImageUrl = appBaseUrl + "/public/banner.png";
    request.setAttribute("ogAppBaseUrl", appBaseUrl);
    request.setAttribute("ogImageUrl", ogImageUrl);
%>
<!DOCTYPE html>
<html lang="es-CO">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, viewport-fit=cover">
    <title>DUTS UTS • Ecosistema de Méritos y Vida Universitaria</title>
    <meta name="description" content="Portal oficial del Ecosistema de Méritos Estudiantiles, Vida Universitaria y Billetera Digital DUTS de las Unidades Tecnológicas de Santander UTS. Acreditada en Alta Calidad.">
    
    <!-- Metadatos de Previsualización en Redes y Compartidos (Open Graph / WhatsApp / Facebook / Twitter) -->
    <meta property="og:type" content="website">
    <meta property="og:site_name" content="Unidades Tecnológicas de Santander - UTS">
    <meta property="og:url" content="${ogAppBaseUrl}/index">
    <meta property="og:title" content="DUTS UTS • Ecosistema de Méritos y Vida Universitaria">
    <meta property="og:description" content="Ecosistema oficial de méritos estudiantiles, vida universitaria y recompensas de las Unidades Tecnológicas de Santander. Acumula los 70.000 DUTS requeridos para tu grado profesional.">
    <meta property="og:image" content="${ogImageUrl}">
    <meta property="og:image:url" content="${ogImageUrl}">
    <meta property="og:image:secure_url" content="${ogImageUrl}">
    <meta property="og:image:type" content="image/png">
    <meta property="og:image:width" content="726">
    <meta property="og:image:height" content="402">
    <meta property="og:image:alt" content="Banner Oficial DUTS UTS - Ecosistema de Méritos y Vida Universitaria">
    <link rel="image_src" href="${ogImageUrl}">
    
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="DUTS UTS • Ecosistema de Méritos y Vida Universitaria">
    <meta name="twitter:description" content="Ecosistema oficial de méritos estudiantiles, vida universitaria y recompensas de las Unidades Tecnológicas de Santander. Acumula los 70.000 DUTS requeridos para tu grado profesional.">
    <meta name="twitter:image" content="${ogImageUrl}">
    <meta name="twitter:image:alt" content="Banner Oficial DUTS UTS - Ecosistema de Méritos y Vida Universitaria">
    
    <meta name="theme-color" content="#0f2e1b">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/images/favicon.svg">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/assets/images/favicon.svg">
    <link rel="manifest" href="${pageContext.request.contextPath}/manifest.json">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800;900&family=Raleway:wght@400;500;600;700;800;900&family=Source+Sans+3:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --uts-verde-oscuro: #0f2e1b;
            --uts-verde-medio: #153c23;
            --uts-verde-escudo: #27522d;
            --uts-verde-hover: #32693a;
            --uts-verde-limon: #9ecc3b;
            --uts-verde-glow: #a6d83a;
            --uts-morado-acred: #69338b;
            --uts-morado-glow: #8442ae;
            --uts-papel: #f8f8f4;
            --uts-arena: #e7e7dc;
            --uts-blanco: #ffffff;
            --uts-tinta: #1e293b;
            --uts-gris: #52606d;
            --uts-gris-claro: #94a3b8;
            --uts-borde: #e2e8f0;
            --uts-sombra-tarjeta: 0 16px 40px -10px rgba(15, 46, 27, 0.22), 0 4px 12px rgba(0, 0, 0, 0.06);
            --uts-radio-base: 4px;
            --uts-radio-card: 8px;
            --uts-radio-pill: 9999px;
            --uts-fuente-titulos: 'Raleway', sans-serif;
            --uts-fuente-cuerpo: 'Source Sans 3', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html, body {
            font-family: var(--uts-fuente-cuerpo);
            color: var(--uts-tinta);
            background-color: var(--uts-papel);
            min-height: 100vh;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        .uts-barra-gov {
            background-color: var(--uts-verde-oscuro);
            color: #d1fae5;
            font-size: 13px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            position: relative;
            z-index: 60;
        }

        .uts-barra-gov__interior {
            max-width: 1320px;
            margin: 0 auto;
            padding: 6px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }

        .uts-barra-gov__logo img {
            height: 22px;
            width: auto;
            display: block;
            filter: drop-shadow(0 1px 2px rgba(0,0,0,0.3));
        }

        .uts-barra-gov__menu {
            display: flex;
            align-items: center;
            gap: 18px;
            list-style: none;
        }

        .uts-barra-gov__enlace {
            color: #e2e8f0;
            font-size: 12.5px;
            font-weight: 500;
            transition: color 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .uts-barra-gov__enlace:hover {
            color: var(--uts-verde-limon);
        }

        .uts-barra-gov__utiles {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .uts-idioma-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.25);
            padding: 2px 8px;
            border-radius: var(--uts-radio-base);
            font-size: 11.5px;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: 0.5px;
            cursor: pointer;
        }

        .uts-buscar-btn {
            background: none;
            border: none;
            color: #ffffff;
            cursor: pointer;
            display: flex;
            align-items: center;
            padding: 4px;
            transition: transform 0.2s, color 0.2s;
        }

        .uts-buscar-btn:hover {
            color: var(--uts-verde-limon);
            transform: scale(1.1);
        }

        .uts-encabezado-oficial {
            background-color: var(--uts-blanco);
            border-bottom: 1px solid var(--uts-borde);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
            position: sticky;
            top: 0;
            z-index: 50;
        }

        .uts-encabezado-oficial__interior {
            max-width: 1320px;
            margin: 0 auto;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
        }

        .uts-logo-marca {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
        }

        .uts-logo-img {
            height: 48px;
            width: auto;
            display: block;
            object-fit: contain;
        }

        .uts-menu-principal {
            display: flex;
            align-items: center;
            gap: 24px;
            list-style: none;
        }

        .uts-menu-principal__enlace {
            font-family: var(--uts-fuente-titulos);
            font-size: 14.5px;
            font-weight: 700;
            color: var(--uts-tinta);
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 0;
            position: relative;
            transition: color 0.2s;
        }

        .uts-menu-principal__enlace:hover {
            color: var(--uts-verde-escudo);
        }

        .uts-menu-principal__enlace::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background-color: var(--uts-verde-limon);
            transition: width 0.25s ease;
        }

        .uts-menu-principal__enlace:hover::after {
            width: 100%;
        }

        .uts-menu-acciones {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .uts-badge-duts-header {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(158, 204, 59, 0.15);
            border: 1px solid rgba(158, 204, 59, 0.45);
            color: #1e4522;
            padding: 6px 12px;
            border-radius: var(--uts-radio-base);
            font-family: var(--uts-fuente-titulos);
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.3px;
        }

        .uts-btn-inscripciones {
            background-color: var(--uts-verde-escudo);
            color: #ffffff;
            font-family: var(--uts-fuente-titulos);
            font-size: 13.5px;
            font-weight: 800;
            padding: 9px 20px;
            border-radius: var(--uts-radio-base);
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
            box-shadow: 0 2px 6px rgba(39, 82, 45, 0.25);
        }

        .uts-btn-inscripciones:hover {
            background-color: var(--uts-verde-hover);
            transform: translateY(-1px);
            box-shadow: 0 4px 10px rgba(39, 82, 45, 0.35);
        }

        .uts-accesos-rapidos {
            background-color: var(--uts-papel);
            border-bottom: 1px solid var(--uts-arena);
            padding: 8px 0;
            z-index: 40;
        }

        .uts-accesos-rapidos__interior {
            max-width: 1320px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .uts-accesos-rapidos__rotulo {
            font-family: var(--uts-fuente-titulos);
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--uts-gris);
            line-height: 1.15;
            display: flex;
            flex-direction: column;
            border-right: 2px solid var(--uts-arena);
            padding-right: 14px;
            flex-shrink: 0;
        }

        .uts-accesos-rapidos__lista {
            display: flex;
            align-items: center;
            gap: 8px;
            list-style: none;
            overflow-x: auto;
            scrollbar-width: none;
            padding: 4px 0;
            flex: 1;
        }

        .uts-accesos-rapidos__lista::-webkit-scrollbar {
            display: none;
        }

        .uts-acceso-item {
            flex-shrink: 0;
        }

        .uts-acceso-ficha {
            background-color: var(--uts-blanco);
            border: 1px solid var(--uts-borde);
            border-radius: var(--uts-radio-base);
            padding: 6px 12px;
            display: inline-flex;
            align-items: center;
            gap: 9px;
            transition: all 0.2s ease;
            cursor: pointer;
            text-decoration: none;
        }

        .uts-acceso-ficha:hover {
            border-color: var(--uts-verde-escudo);
            transform: translateY(-1.5px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }

        .uts-acceso-ficha svg {
            color: var(--uts-verde-escudo);
            flex-shrink: 0;
        }

        .uts-acceso-textos {
            display: flex;
            flex-direction: column;
        }

        .uts-acceso-nombre {
            font-family: var(--uts-fuente-titulos);
            font-size: 12px;
            font-weight: 800;
            color: var(--uts-tinta);
            line-height: 1.2;
            white-space: nowrap;
        }

        .uts-acceso-desc {
            font-size: 10.5px;
            color: var(--uts-gris);
            line-height: 1.2;
            white-space: nowrap;
        }

        .uts-acceso-ficha--duts {
            background: linear-gradient(135deg, #10321a 0%, #1f502b 100%);
            border-color: var(--uts-verde-limon);
            box-shadow: 0 2px 8px rgba(15, 46, 27, 0.2);
        }

        .uts-acceso-ficha--duts .uts-acceso-nombre {
            color: var(--uts-verde-limon);
        }

        .uts-acceso-ficha--duts .uts-acceso-desc {
            color: #e2e8f0;
        }

        .uts-acceso-ficha--duts svg {
            color: var(--uts-verde-limon);
        }

        .uts-acceso-ficha--portal {
            background-color: var(--uts-verde-escudo);
            border-color: var(--uts-verde-escudo);
        }

        .uts-acceso-ficha--portal .uts-acceso-nombre {
            color: #ffffff;
        }

        .uts-acceso-ficha--portal .uts-acceso-desc {
            color: #cbd5e1;
        }

        .uts-acceso-ficha--portal svg {
            color: var(--uts-verde-limon);
        }

        .uts-hero-principal {
            position: relative;
            min-height: 580px;
            background-color: var(--uts-verde-oscuro);
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            display: flex;
            align-items: center;
            transition: background-image 0.8s ease-in-out;
            overflow: hidden;
        }

        .uts-hero-velo {
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, 
                rgba(12, 36, 21, 0.88) 0%, 
                rgba(12, 36, 21, 0.74) 48%, 
                rgba(12, 36, 21, 0.42) 80%, 
                rgba(12, 36, 21, 0.22) 100%);
            z-index: 1;
            pointer-events: none;
        }

        .uts-sello-acreditacion-banner {
            position: absolute;
            top: 24px;
            right: 48px;
            width: 140px;
            height: auto;
            z-index: 2;
            opacity: 0.92;
            filter: drop-shadow(0 8px 24px rgba(0, 0, 0, 0.45));
            animation: flotarSello 6s ease-in-out infinite;
            pointer-events: none;
        }

        @keyframes flotarSello {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }

        .uts-hero-grid {
            max-width: 1320px;
            width: 100%;
            margin: 0 auto;
            padding: 40px 20px 48px;
            position: relative;
            z-index: 5;
            display: grid;
            grid-template-columns: 1.25fr 0.85fr;
            gap: 40px;
            align-items: center;
        }

        .uts-hero-info {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .uts-insignia-acreditacion {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background-color: var(--uts-morado-acred);
            color: #ffffff;
            font-family: var(--uts-fuente-titulos);
            font-size: 11.5px;
            font-weight: 800;
            letter-spacing: 0.4px;
            padding: 5px 14px;
            border-radius: var(--uts-radio-pill);
            width: fit-content;
            box-shadow: 0 4px 12px rgba(105, 51, 139, 0.4);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .uts-hero-titulo {
            font-family: var(--uts-fuente-titulos);
            font-size: 42px;
            font-weight: 900;
            color: #ffffff;
            line-height: 1.15;
            letter-spacing: -0.02em;
        }

        .uts-hero-titulo .uts-limon {
            color: var(--uts-verde-limon);
            text-shadow: 0 0 20px rgba(158, 204, 59, 0.35);
        }

        .uts-hero-bajada {
            font-size: 15.5px;
            line-height: 1.6;
            color: #f1f5f9;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.7);
        }

        .uts-hero-bajada strong {
            color: var(--uts-verde-limon);
            font-weight: 700;
        }

        .uts-duts-descripcion-destacada {
            background: rgba(15, 46, 27, 0.55);
            border-left: 3.5px solid var(--uts-verde-limon);
            padding: 12px 16px;
            border-radius: 0 10px 10px 0;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            border-right: 1px solid rgba(255, 255, 255, 0.08);
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.25);
        }

        .uts-hero-banner-card {
            position: relative;
            border-radius: 14px;
            overflow: hidden;
            background: #06180c;
            border: 1.5px solid rgba(158, 204, 59, 0.45);
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.45), 0 0 24px rgba(158, 204, 59, 0.15);
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
            margin: 4px 0 6px;
        }

        .uts-hero-banner-card:hover {
            transform: translateY(-2px);
            border-color: var(--uts-verde-limon);
            box-shadow: 0 16px 40px rgba(0, 0, 0, 0.55), 0 0 32px rgba(158, 204, 59, 0.25);
        }

        .uts-hero-banner-wrapper {
            position: relative;
            width: 100%;
            aspect-ratio: 16 / 9;
            overflow: hidden;
            background-color: #041007;
        }

        .uts-hero-banner-media {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform 0.4s ease;
        }

        .uts-hero-banner-card:hover .uts-hero-banner-media {
            transform: scale(1.02);
        }

        .uts-hero-banner-tag {
            position: absolute;
            bottom: 10px;
            left: 10px;
            background: rgba(15, 46, 27, 0.88);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            color: #ffffff;
            border: 1px solid rgba(158, 204, 59, 0.4);
            padding: 5px 12px;
            border-radius: var(--uts-radio-pill);
            font-size: 11px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.35);
        }

        .uts-hero-banner-tag svg {
            color: var(--uts-verde-limon);
        }

        .uts-hero-banner-zoom-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(15, 46, 27, 0.85);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.25);
            padding: 5px 12px;
            border-radius: var(--uts-radio-pill);
            font-size: 11px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            text-decoration: none;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.35);
        }

        .uts-hero-banner-zoom-btn:hover {
            background: var(--uts-verde-escudo);
            border-color: var(--uts-verde-limon);
            color: #ffffff;
            transform: translateY(-1px);
        }

        .uts-hero-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 4px;
        }

        .uts-hero-pill-item {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.18);
            padding: 5px 12px;
            border-radius: var(--uts-radio-pill);
            font-size: 12px;
            color: #f1f5f9;
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
        }

        .uts-hero-pill-item strong {
            color: var(--uts-verde-limon);
        }

        .uts-pill-dot {
            color: var(--uts-verde-limon);
            font-size: 8px;
        }

        .uts-hero-acciones {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-top: 6px;
        }

        .uts-btn-hero-principal {
            background-color: var(--uts-verde-escudo);
            color: #ffffff;
            font-family: var(--uts-fuente-titulos);
            font-size: 14px;
            font-weight: 800;
            padding: 12px 24px;
            border-radius: var(--uts-radio-base);
            border: 1px solid var(--uts-verde-escudo);
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.3);
            text-decoration: none;
        }

        .uts-btn-hero-principal:hover {
            background-color: var(--uts-verde-hover);
            border-color: var(--uts-verde-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.4);
        }

        .uts-btn-hero-fantasma {
            background-color: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            font-family: var(--uts-fuente-titulos);
            font-size: 14px;
            font-weight: 700;
            padding: 12px 22px;
            border-radius: var(--uts-radio-base);
            border: 1px solid rgba(255, 255, 255, 0.4);
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s ease;
            backdrop-filter: blur(6px);
            text-decoration: none;
        }

        .uts-btn-hero-fantasma:hover {
            background-color: rgba(255, 255, 255, 0.2);
            border-color: #ffffff;
            transform: translateY(-2px);
        }

        .uts-hero-controles {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 14px;
        }

        .uts-slider-btn {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            border: 1px solid rgba(255, 255, 255, 0.3);
            background: rgba(0, 0, 0, 0.3);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
        }

        .uts-slider-btn:hover {
            background: var(--uts-verde-escudo);
            border-color: var(--uts-verde-limon);
            transform: scale(1.05);
        }

        .uts-slider-dots {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .uts-slider-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.35);
            border: none;
            cursor: pointer;
            transition: all 0.25s;
        }

        .uts-slider-dot.activo {
            width: 28px;
            border-radius: 6px;
            background: var(--uts-verde-limon);
            box-shadow: 0 0 10px rgba(158, 204, 59, 0.5);
        }

        .uts-slider-pausa {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            border: 1px solid rgba(255, 255, 255, 0.25);
            background: transparent;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: color 0.2s;
        }

        .uts-slider-pausa:hover {
            color: var(--uts-verde-limon);
        }

        .uts-hero-login-card {
            background-color: var(--uts-blanco);
            border-radius: var(--uts-radio-card);
            border: 1px solid rgba(255, 255, 255, 0.8);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.45);
            padding: 32px 28px;
            position: relative;
            backdrop-filter: blur(8px);
        }

        .uts-card-segura-badge {
            position: absolute;
            top: -12px;
            right: 20px;
            background: linear-gradient(135deg, var(--uts-verde-oscuro) 0%, var(--uts-verde-escudo) 100%);
            color: #ffffff;
            font-family: var(--uts-fuente-titulos);
            font-size: 10.5px;
            font-weight: 800;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            padding: 4px 12px;
            border-radius: var(--uts-radio-pill);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .uts-card-header {
            margin-bottom: 20px;
        }

        .uts-card-titulo {
            font-family: var(--uts-fuente-titulos);
            font-size: 22px;
            font-weight: 800;
            color: var(--uts-tinta);
            letter-spacing: -0.01em;
            margin-bottom: 4px;
        }

        .uts-card-subtitulo {
            font-size: 13px;
            color: var(--uts-gris);
        }

        .uts-btn-sso {
            width: 100%;
            background: linear-gradient(135deg, var(--uts-verde-escudo) 0%, var(--uts-verde-oscuro) 100%);
            color: #ffffff;
            border: none;
            padding: 12px 16px;
            border-radius: var(--uts-radio-base);
            font-family: var(--uts-fuente-titulos);
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(39, 82, 45, 0.25);
            margin-bottom: 16px;
        }

        .uts-btn-sso:hover {
            background: linear-gradient(135deg, var(--uts-verde-hover) 0%, var(--uts-verde-medio) 100%);
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(39, 82, 45, 0.35);
        }

        .uts-divider-or {
            display: flex;
            align-items: center;
            text-align: center;
            color: var(--uts-gris-claro);
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            margin-bottom: 18px;
        }

        .uts-divider-or::before, .uts-divider-or::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid var(--uts-borde);
        }

        .uts-divider-or:not(:empty)::before { margin-right: 10px; }
        .uts-divider-or:not(:empty)::after { margin-left: 10px; }

        .uts-form-group {
            margin-bottom: 16px;
        }

        .uts-form-label {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            font-weight: 700;
            color: #334155;
            margin-bottom: 5px;
            font-family: var(--uts-fuente-titulos);
        }

        .uts-input-wrap {
            position: relative;
            display: flex;
            align-items: center;
        }

        .uts-input-icon {
            position: absolute;
            left: 12px;
            color: var(--uts-gris-claro);
            display: flex;
            align-items: center;
            pointer-events: none;
        }

        .uts-input-field {
            width: 100%;
            padding: 11px 12px 11px 38px;
            border: 1.5px solid var(--uts-borde);
            border-radius: var(--uts-radio-base);
            font-size: 14px;
            color: var(--uts-tinta);
            background-color: #ffffff;
            transition: all 0.2s ease;
        }

        .uts-input-field:focus {
            outline: none;
            border-color: var(--uts-verde-escudo);
            box-shadow: 0 0 0 3px rgba(39, 82, 45, 0.12);
        }

        .uts-toggle-pass {
            position: absolute;
            right: 10px;
            background: none;
            border: none;
            color: var(--uts-gris-claro);
            cursor: pointer;
            padding: 4px;
            display: flex;
            align-items: center;
        }

        .uts-toggle-pass:hover {
            color: var(--uts-verde-escudo);
        }

        .uts-link-olvido {
            font-size: 11.5px;
            color: var(--uts-verde-escudo);
            font-weight: 600;
            text-decoration: none;
            background: none;
            border: none;
            cursor: pointer;
            padding: 0;
            font-family: inherit;
        }

        .uts-link-olvido:hover {
            text-decoration: underline;
        }

        /* Modal Institucional de Recuperación */
        .uts-modal-recuperar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 9999;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 16px;
        }

        .uts-modal-recuperar__backdrop {
            position: absolute;
            inset: 0;
            background: rgba(15, 46, 27, 0.65);
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
        }

        .uts-modal-recuperar__dialog {
            position: relative;
            background: #ffffff;
            border-radius: var(--uts-radio-card);
            box-shadow: 0 24px 60px rgba(0, 0, 0, 0.28);
            width: 100%;
            max-width: 480px;
            padding: 28px 24px;
            z-index: 2;
            animation: utsModalEntrada 0.25s cubic-bezier(0.16, 1, 0.3, 1);
            border-top: 4px solid var(--uts-verde-escudo);
        }

        @keyframes utsModalEntrada {
            from { opacity: 0; transform: scale(0.95) translateY(12px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }

        .uts-modal-recuperar__header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
            gap: 12px;
        }

        .uts-modal-badge {
            display: inline-block;
            background: rgba(39, 82, 45, 0.1);
            color: var(--uts-verde-escudo);
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            padding: 3px 8px;
            border-radius: var(--uts-radio-pill);
            margin-bottom: 6px;
            letter-spacing: 0.5px;
        }

        .uts-modal-title {
            font-family: var(--uts-fuente-titulos);
            font-size: 20px;
            font-weight: 800;
            color: var(--uts-verde-oscuro);
            line-height: 1.2;
        }

        .uts-modal-subtitle {
            font-size: 12.5px;
            color: var(--uts-gris);
            margin-top: 4px;
        }

        .uts-modal-close {
            background: none;
            border: none;
            font-size: 26px;
            color: var(--uts-gris-claro);
            cursor: pointer;
            line-height: 1;
            padding: 4px;
            border-radius: var(--uts-radio-base);
            transition: color 0.15s, background-color 0.15s;
        }

        .uts-modal-close:hover {
            color: var(--uts-tinta);
            background: rgba(0,0,0,0.05);
        }

        .uts-modal-alerta {
            padding: 12px 14px;
            border-radius: var(--uts-radio-base);
            font-size: 13px;
            margin-bottom: 18px;
            line-height: 1.4;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .uts-modal-alerta--error {
            background-color: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .uts-modal-alerta--exito {
            background-color: #f0fdf4;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .uts-modal-recuperar__actions {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 12px;
            margin-top: 20px;
            padding-top: 14px;
            border-top: 1px solid var(--uts-borde);
        }

        .uts-modal-btn-cancel {
            background: transparent;
            border: 1px solid var(--uts-borde);
            color: var(--uts-gris);
            font-size: 13.5px;
            font-weight: 600;
            padding: 10px 18px;
            border-radius: var(--uts-radio-base);
            cursor: pointer;
            transition: all 0.15s;
        }

        .uts-modal-btn-cancel:hover {
            background: var(--uts-papel);
            color: var(--uts-tinta);
        }

        .uts-btn-submit {
            background-color: var(--uts-verde-escudo);
            color: #ffffff;
            border: none;
            width: 100%;
            padding: 12px;
            border-radius: var(--uts-radio-base);
            font-family: var(--uts-fuente-titulos);
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(39, 82, 45, 0.25);
            margin-top: 6px;
            margin-bottom: 16px;
        }

        .uts-btn-submit:hover {
            background-color: var(--uts-verde-hover);
            transform: translateY(-1.5px);
            box-shadow: 0 6px 18px rgba(39, 82, 45, 0.35);
        }

        .uts-registro-card-callout {
            background-color: var(--uts-papel);
            border: 1px solid var(--uts-borde);
            border-radius: var(--uts-radio-base);
            padding: 10px 12px;
            text-align: center;
            margin-bottom: 12px;
        }

        .uts-registro-card-callout span {
            font-size: 12px;
            color: var(--uts-gris);
            display: block;
            margin-bottom: 3px;
        }

        .uts-registro-link {
            font-family: var(--uts-fuente-titulos);
            font-size: 12.5px;
            font-weight: 800;
            color: var(--uts-verde-escudo);
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .uts-registro-link:hover {
            text-decoration: underline;
        }

        .uts-alerta {
            padding: 10px 14px;
            border-radius: var(--uts-radio-base);
            font-size: 13px;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .uts-alerta--error {
            background-color: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        .uts-alerta--exito {
            background-color: #f0fdf4;
            color: #15803d;
            border: 1px solid #bbf7d0;
        }

        .uts-de-interes-bar {
            background-color: #ffffff;
            border-top: 1px solid var(--uts-borde);
            border-bottom: 1px solid var(--uts-borde);
            padding: 12px 0;
            position: relative;
            z-index: 20;
        }

        .uts-de-interes-bar__interior {
            max-width: 1320px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
        }

        .uts-de-interes-left {
            display: flex;
            align-items: center;
            gap: 18px;
            flex-wrap: wrap;
        }

        .uts-de-interes-etiqueta {
            font-family: var(--uts-fuente-titulos);
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--uts-gris);
            border-right: 2px solid var(--uts-arena);
            padding-right: 14px;
        }

        .uts-redes-lista {
            display: flex;
            align-items: center;
            gap: 10px;
            list-style: none;
        }

        .uts-red-enlace {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--uts-verde-escudo);
            transition: all 0.2s;
        }

        .uts-red-enlace:hover {
            color: #0b1a10;
            transform: scale(1.15);
        }

        .uts-de-interes-links {
            display: flex;
            align-items: center;
            gap: 16px;
            list-style: none;
            flex-wrap: wrap;
        }

        .uts-de-interes-links a {
            font-size: 13px;
            font-weight: 600;
            color: var(--uts-verde-escudo);
            transition: color 0.2s;
        }

        .uts-de-interes-links a:hover {
            color: #0b1a10;
            text-decoration: underline;
        }

        .uts-chat-ayuda-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #ffffff;
            border: 1px solid var(--uts-borde);
            padding: 6px 14px;
            border-radius: var(--uts-radio-pill);
            font-family: var(--uts-fuente-titulos);
            font-size: 12.5px;
            font-weight: 700;
            color: var(--uts-verde-escudo);
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            cursor: pointer;
            transition: all 0.2s;
        }

        .uts-chat-ayuda-pill:hover {
            border-color: var(--uts-verde-escudo);
            background-color: var(--uts-papel);
            transform: translateY(-1px);
        }

        .uts-seccion-ecosistema {
            padding: 56px 20px;
            background-color: var(--uts-papel);
        }

        .uts-seccion-ecosistema__interior {
            max-width: 1320px;
            margin: 0 auto;
        }

        .uts-cabecera-bloque {
            text-align: center;
            margin-bottom: 40px;
        }

        .uts-rotulo-pilar {
            display: inline-block;
            background-color: rgba(158, 204, 59, 0.2);
            color: #1e4522;
            border: 1px solid rgba(158, 204, 59, 0.5);
            font-family: var(--uts-fuente-titulos);
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            padding: 4px 12px;
            border-radius: var(--uts-radio-pill);
            margin-bottom: 10px;
        }

        .uts-titulo-bloque {
            font-family: var(--uts-fuente-titulos);
            font-size: 32px;
            font-weight: 800;
            color: var(--uts-verde-oscuro);
            letter-spacing: -0.01em;
            margin-bottom: 8px;
        }

        .uts-bajada-bloque {
            font-size: 15px;
            color: var(--uts-gris);
            max-width: 680px;
            margin: 0 auto;
            line-height: 1.5;
        }

        /* Banner Oficial de Presentación DUTS */
        .uts-banner-showcase-container {
            margin-bottom: 36px;
        }

        .uts-banner-showcase-card {
            background: #ffffff;
            border-radius: var(--uts-radio-card);
            border: 1.5px solid var(--uts-borde);
            box-shadow: var(--uts-sombra-tarjeta);
            overflow: hidden;
            display: grid;
            grid-template-columns: 1.2fr 0.8fr;
            transition: all 0.3s ease;
        }

        .uts-banner-showcase-card:hover {
            box-shadow: 0 24px 50px -12px rgba(15, 46, 27, 0.28);
            border-color: rgba(39, 82, 45, 0.3);
        }

        .uts-banner-showcase-media {
            position: relative;
            background: #06180c;
            overflow: hidden;
            min-height: 340px;
        }

        .uts-banner-showcase-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform 0.4s ease;
        }

        .uts-banner-showcase-card:hover .uts-banner-showcase-img {
            transform: scale(1.025);
        }

        .uts-banner-tag-floating {
            position: absolute;
            bottom: 14px;
            left: 14px;
            background: rgba(15, 46, 27, 0.85);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            color: #ffffff;
            border: 1px solid rgba(158, 204, 59, 0.4);
            padding: 6px 12px;
            border-radius: var(--uts-radio-pill);
            font-size: 11.5px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .uts-banner-tag-floating svg {
            color: var(--uts-verde-limon);
        }

        .uts-banner-showcase-content {
            padding: 36px 32px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .uts-banner-mini-badge {
            display: inline-block;
            background: rgba(39, 82, 45, 0.1);
            color: var(--uts-verde-escudo);
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
            padding: 4px 10px;
            border-radius: var(--uts-radio-pill);
            margin-bottom: 12px;
            letter-spacing: 0.5px;
            align-self: flex-start;
        }

        .uts-banner-showcase-title {
            font-family: var(--uts-fuente-titulos);
            font-size: 26px;
            font-weight: 900;
            color: var(--uts-verde-oscuro);
            line-height: 1.2;
            margin-bottom: 12px;
        }

        .uts-banner-showcase-text {
            font-size: 14.5px;
            color: var(--uts-gris);
            line-height: 1.55;
            margin-bottom: 18px;
        }

        .uts-banner-features-mini {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 24px;
        }

        .uts-banner-feature-item {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            font-size: 13.5px;
            color: #334155;
            line-height: 1.4;
        }

        .uts-feature-bullet {
            color: var(--uts-verde-escudo);
            font-weight: 900;
            font-size: 14px;
            flex-shrink: 0;
            margin-top: 1px;
        }

        .uts-banner-showcase-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .uts-btn-banner-login {
            background-color: var(--uts-verde-escudo);
            color: #ffffff;
            font-family: var(--uts-fuente-titulos);
            font-size: 13.5px;
            font-weight: 800;
            padding: 10px 18px;
            border-radius: var(--uts-radio-base);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
            box-shadow: 0 4px 12px rgba(39, 82, 45, 0.2);
            text-decoration: none;
        }

        .uts-btn-banner-login:hover {
            background-color: var(--uts-verde-hover);
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(39, 82, 45, 0.3);
            color: #ffffff;
        }

        .uts-btn-banner-registro {
            background-color: transparent;
            color: var(--uts-verde-escudo);
            border: 1.5px solid var(--uts-verde-escudo);
            font-family: var(--uts-fuente-titulos);
            font-size: 13.5px;
            font-weight: 700;
            padding: 10px 18px;
            border-radius: var(--uts-radio-base);
            display: inline-flex;
            align-items: center;
            transition: all 0.2s;
            text-decoration: none;
        }

        .uts-btn-banner-registro:hover {
            background-color: rgba(39, 82, 45, 0.08);
            border-color: var(--uts-verde-hover);
        }

        @media (max-width: 900px) {
            .uts-banner-showcase-card {
                grid-template-columns: 1fr;
            }

            .uts-banner-showcase-media {
                min-height: 240px;
                max-height: 320px;
            }

            .uts-banner-showcase-content {
                padding: 24px 20px;
            }

            .uts-banner-showcase-title {
                font-size: 22px;
            }
        }

        .uts-grid-beneficios {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 22px;
            margin-bottom: 40px;
        }

        .uts-card-beneficio {
            background-color: #ffffff;
            border: 1px solid var(--uts-borde);
            border-radius: var(--uts-radio-base);
            padding: 24px 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.25s ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            border-top: 3px solid transparent;
        }

        .uts-card-beneficio:hover {
            transform: translateY(-4px);
            border-top-color: var(--uts-verde-limon);
            box-shadow: 0 12px 24px rgba(15, 46, 27, 0.1);
        }

        .uts-card-beneficio__icono {
            width: 44px;
            height: 44px;
            border-radius: var(--uts-radio-base);
            background-color: rgba(39, 82, 45, 0.08);
            color: var(--uts-verde-escudo);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
        }

        .uts-card-beneficio__titulo {
            font-family: var(--uts-fuente-titulos);
            font-size: 16px;
            font-weight: 800;
            color: var(--uts-verde-oscuro);
            margin-bottom: 8px;
        }

        .uts-card-beneficio__texto {
            font-size: 13px;
            line-height: 1.5;
            color: var(--uts-gris);
            margin-bottom: 16px;
        }

        .uts-card-beneficio__enlace {
            font-family: var(--uts-fuente-titulos);
            font-size: 12.5px;
            font-weight: 700;
            color: var(--uts-verde-escudo);
            display: inline-flex;
            align-items: center;
            gap: 5px;
            text-decoration: none;
            transition: gap 0.2s;
        }

        .uts-card-beneficio__enlace:hover {
            gap: 8px;
            color: #0b1a10;
        }

        .uts-franja-cifras {
            background: linear-gradient(135deg, var(--uts-verde-oscuro) 0%, #153c23 100%);
            border-radius: var(--uts-radio-card);
            padding: 32px 24px;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            color: #ffffff;
            box-shadow: 0 12px 30px rgba(15, 46, 27, 0.2);
            text-align: center;
        }

        .uts-cifra-item h3 {
            font-family: var(--uts-fuente-titulos);
            font-size: 36px;
            font-weight: 900;
            color: var(--uts-verde-limon);
            line-height: 1;
            margin-bottom: 6px;
        }

        .uts-cifra-item p {
            font-size: 13px;
            color: #cbd5e1;
            font-weight: 500;
        }

        .uts-pie-pagina {
            background-color: #0b2214;
            color: #94a3b8;
            font-size: 13px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .uts-pie-pagina__interior {
            max-width: 1320px;
            margin: 0 auto;
            padding: 48px 20px 28px;
        }

        .uts-pie-grid {
            display: grid;
            grid-template-columns: 1.4fr 1fr 1fr 1fr;
            gap: 36px;
            margin-bottom: 36px;
        }

        .uts-pie-col h4 {
            font-family: var(--uts-fuente-titulos);
            font-size: 14px;
            font-weight: 800;
            color: #ffffff;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 14px;
            border-bottom: 2px solid var(--uts-verde-limon);
            padding-bottom: 6px;
            width: fit-content;
        }

        .uts-pie-col p {
            line-height: 1.6;
            margin-bottom: 10px;
        }

        .uts-pie-col ul {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .uts-pie-col ul a {
            color: #cbd5e1;
            transition: color 0.2s;
        }

        .uts-pie-col ul a:hover {
            color: var(--uts-verde-limon);
        }

        .uts-pie-copy {
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            padding-top: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            flex-wrap: wrap;
            gap: 12px;
        }

        @media (max-width: 1100px) {
            .uts-hero-grid {
                grid-template-columns: 1fr;
                gap: 36px;
            }
            .uts-hero-login-card {
                max-width: 520px;
                margin: 0 auto;
                width: 100%;
            }
            .uts-grid-beneficios {
                grid-template-columns: repeat(2, 1fr);
            }
            .uts-franja-cifras {
                grid-template-columns: repeat(2, 1fr);
            }
            .uts-pie-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 860px) {
            .uts-barra-gov__menu,
            .uts-menu-principal {
                display: none;
            }
            .uts-hero-titulo {
                font-size: 32px;
            }
            .uts-grid-beneficios {
                grid-template-columns: 1fr;
            }
            .uts-franja-cifras {
                grid-template-columns: 1fr;
            }
            .uts-pie-grid {
                grid-template-columns: 1fr;
            }
            .uts-sello-acreditacion-banner {
                width: 90px;
                right: 16px;
                top: 16px;
            }
        }

        @media (max-width: 768px) {
            body {
                -webkit-tap-highlight-color: transparent;
                background-color: #0b1e12;
            }

            .uts-barra-gov {
                font-size: 11px;
            }
            .uts-barra-gov__interior {
                padding: 4px 14px;
            }
            .uts-barra-gov__logo img {
                height: 16px;
            }

            .uts-encabezado-oficial {
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            }
            .uts-encabezado-oficial__interior {
                padding: 8px 14px;
                gap: 12px;
            }
            .uts-logo-img {
                height: 36px;
            }
            .uts-badge-duts-header {
                font-size: 10.5px;
                padding: 4px 8px;
            }
            .uts-btn-inscripciones {
                font-size: 11.5px;
                padding: 6px 12px;
            }

            .uts-accesos-rapidos {
                padding: 6px 0;
                background: #f1f3ee;
            }
            .uts-accesos-rapidos__interior {
                padding: 0 12px;
                gap: 8px;
            }
            .uts-accesos-rapidos__rotulo {
                display: none; 
            }
            .uts-accesos-rapidos__lista {
                gap: 6px;
                padding: 2px 0;
            }
            .uts-acceso-ficha {
                padding: 5px 10px;
                gap: 6px;
                border-radius: 20px; 
            }
            .uts-acceso-nombre {
                font-size: 11px;
            }
            .uts-acceso-desc {
                display: none; 
            }

            .uts-hero-principal {
                min-height: auto;
                padding: 0;
                background-attachment: scroll;
            }
            .uts-hero-grid {
                padding: 14px 12px 28px;
                gap: 16px;
                display: flex;
                flex-direction: column;
            }
            
            .uts-hero-info {
                background: rgba(15, 46, 27, 0.85);
                border: 1px solid rgba(158, 204, 59, 0.35);
                border-radius: 18px;
                padding: 16px 16px 14px;
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.35);
                gap: 10px;
            }
            .uts-sello-acreditacion-banner {
                width: 65px;
                top: 8px;
                right: 8px;
                opacity: 0.95;
            }
            .uts-insignia-acreditacion {
                font-size: 10px;
                padding: 3px 10px;
            }
            .uts-hero-titulo {
                font-size: 22px;
                line-height: 1.2;
            }
            .uts-hero-bajada {
                font-size: 13.5px;
                line-height: 1.5;
                display: block;
                overflow: visible;
                color: #f1f5f9;
            }
            .uts-duts-descripcion-destacada {
                padding: 10px 12px;
                background: rgba(15, 46, 27, 0.7);
            }
            .uts-hero-banner-card {
                margin: 4px 0 8px;
                border-radius: 10px;
            }
            .uts-hero-banner-wrapper {
                aspect-ratio: 16 / 9;
            }
            .uts-hero-pill-item {
                font-size: 11px;
                padding: 4px 9px;
            }
            .uts-hero-acciones {
                display: flex;
                gap: 8px;
                margin-top: 4px;
            }
            .uts-btn-hero-principal {
                padding: 8px 14px;
                font-size: 12px;
                border-radius: 8px;
                flex: 1;
                justify-content: center;
            }
            .uts-btn-hero-fantasma {
                padding: 8px 12px;
                font-size: 12px;
                border-radius: 8px;
            }
            .uts-hero-controles {
                margin-top: 6px;
                justify-content: center;
                gap: 8px;
            }
            .uts-slider-btn {
                width: 28px;
                height: 28px;
            }
            .uts-slider-pausa {
                width: 28px;
                height: 28px;
            }

            .uts-hero-login-card {
                background: #ffffff;
                border-radius: 24px;
                box-shadow: 0 16px 40px rgba(0, 0, 0, 0.45);
                padding: 22px 18px 20px;
                border: 1px solid rgba(255, 255, 255, 0.9);
                margin: 0;
                width: 100%;
                max-width: 100%;
            }

            .uts-mobile-app-handle {
                display: block;
                width: 44px;
                height: 5px;
                background: #cbd5e1;
                border-radius: 99px;
                margin: -6px auto 14px;
            }

            .uts-card-segura-badge {
                font-size: 9.5px;
                padding: 3px 10px;
                top: -10px;
                right: 18px;
            }
            .uts-card-header {
                margin-bottom: 14px;
            }
            .uts-card-titulo {
                font-size: 20px;
                margin-bottom: 2px;
            }
            .uts-card-subtitulo {
                font-size: 12px;
            }

            .uts-btn-sso {
                padding: 13px 16px;
                font-size: 13px;
                border-radius: 12px;
                min-height: 46px;
            }
            .uts-btn-sso:active {
                transform: scale(0.98);
            }
            .uts-divider-or {
                margin-bottom: 14px;
                font-size: 10.5px;
            }
            .uts-form-group {
                margin-bottom: 14px;
            }
            .uts-input-field {
                padding: 12px 12px 12px 38px;
                font-size: 15px; 
                border-radius: 10px;
                min-height: 46px;
            }
            .uts-toggle-pass {
                right: 10px;
                width: 36px;
                height: 36px;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .uts-btn-submit {
                padding: 13px;
                font-size: 14.5px;
                border-radius: 12px;
                min-height: 48px;
                margin-top: 6px;
                margin-bottom: 14px;
            }
            .uts-btn-submit:active {
                transform: scale(0.98);
            }

            .uts-mobile-app-shortcuts {
                display: block;
                margin-top: 16px;
                padding-top: 14px;
                border-top: 1px dashed #e2e8f0;
            }
            .uts-shortcuts-title {
                display: block;
                font-family: var(--uts-fuente-titulos);
                font-size: 11px;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: 0.6px;
                color: var(--uts-gris);
                margin-bottom: 10px;
                text-align: center;
            }
            .uts-shortcuts-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 8px;
            }
            .uts-shortcut-btn {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 5px;
                text-decoration: none;
                padding: 8px 4px;
                border-radius: 12px;
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                transition: transform 0.15s, background-color 0.15s;
            }
            .uts-shortcut-btn:active {
                transform: scale(0.94);
                background: #ecfdf5;
            }
            .uts-shortcut-icon {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background: #e8f5e9;
                color: var(--uts-verde-escudo);
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .uts-shortcut-label {
                font-size: 10.5px;
                font-weight: 700;
                color: var(--uts-tinta);
                text-align: center;
            }

            .uts-de-interes-bar {
                padding: 10px 0;
            }
            .uts-de-interes-bar__interior {
                padding: 0 14px;
                justify-content: center;
            }
            .uts-seccion-ecosistema {
                padding: 32px 14px;
            }
            .uts-titulo-bloque {
                font-size: 22px;
            }
            .uts-pie-pagina__interior {
                padding: 28px 16px 20px;
            }
        }

        @media (min-width: 769px) {
            .uts-mobile-app-handle,
            .uts-mobile-app-shortcuts {
                display: none !important;
            }
        }
    </style>
</head>
<body>

    <div class="uts-barra-gov" role="navigation" aria-label="Portal de Gobierno y Canales Oficiales">
        <div class="uts-barra-gov__interior">
            <div class="uts-barra-gov__logo">
                <a href="https://www.gov.co/" target="_blank" rel="noopener" title="Ir al Portal Único del Estado Colombiano GOV.CO">
                    <img src="${pageContext.request.contextPath}/assets/images/gov-co.png" alt="GOV.CO - Portal Oficial del Estado Colombiano">
                </a>
            </div>

            <ul class="uts-barra-gov__menu">
                <li><a href="https://www.uts.edu.co/estudiantes/" class="uts-barra-gov__enlace" target="_blank" rel="noopener">Estudiantes</a></li>
                <li><a href="https://www.uts.edu.co/docentes/" class="uts-barra-gov__enlace" target="_blank" rel="noopener">Docentes</a></li>
                <li><a href="https://www.uts.edu.co/graduados/" class="uts-barra-gov__enlace" target="_blank" rel="noopener">Graduados</a></li>
                <li><a href="https://www.uts.edu.co/administrativos/" class="uts-barra-gov__enlace" target="_blank" rel="noopener">Administrativos ▾</a></li>
                <li><a href="https://www.uts.edu.co/transparencia/" class="uts-barra-gov__enlace" target="_blank" rel="noopener">Transparencia ▾</a></li>
                <li><a href="https://www.uts.edu.co/atencion-al-ciudadano/" class="uts-barra-gov__enlace" target="_blank" rel="noopener">Atención</a></li>
                <li><a href="https://www.uts.edu.co/participa/" class="uts-barra-gov__enlace" target="_blank" rel="noopener">Participa</a></li>
                <li><a href="https://www.uts.edu.co/tramites-y-servicios/" class="uts-barra-gov__enlace" target="_blank" rel="noopener">Servicios ▾</a></li>
                <li><a href="https://www.uts.edu.co/directorio-institucional/" class="uts-barra-gov__enlace" target="_blank" rel="noopener">Directorio</a></li>
            </ul>

            <div class="uts-barra-gov__utiles">
                <div class="uts-idioma-pill" title="Idioma oficial Español">
                    <span>ES</span>
                    <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"></polyline></svg>
                </div>
                <button type="button" class="uts-buscar-btn" aria-label="Buscar en el portal UTS" onclick="window.open('https://www.uts.edu.co/?s=', '_blank')">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                </button>
            </div>
        </div>
    </div>

    <header class="uts-encabezado-oficial">
        <div class="uts-encabezado-oficial__interior">
            <a href="${pageContext.request.contextPath}/index" class="uts-logo-marca" title="Universitaria Tecnológica de Santander - Inicio">
                <img src="${pageContext.request.contextPath}/assets/images/logo-uts.svg" alt="Universitaria Tecnológica de Santander • ¡Lo hacemos posible!" class="uts-logo-img" onerror="this.src='${pageContext.request.contextPath}/assets/images/logouts.png';">
            </a>

            <ul class="uts-menu-principal">
                <li><a href="https://www.uts.edu.co/mision-vision/" target="_blank" rel="noopener" class="uts-menu-principal__enlace">Nosotros ▾</a></li>
                <li><a href="https://www.uts.edu.co/oferta-academica/" target="_blank" rel="noopener" class="uts-menu-principal__enlace">Oferta académica</a></li>
                <li><a href="https://www.uts.edu.co/admisiones/" target="_blank" rel="noopener" class="uts-menu-principal__enlace">Admisiones ▾</a></li>
                <li><a href="https://www.uts.edu.co/investigacion/" target="_blank" rel="noopener" class="uts-menu-principal__enlace">Investigación</a></li>
                <li><a href="https://www.uts.edu.co/extension/" target="_blank" rel="noopener" class="uts-menu-principal__enlace">Extensión</a></li>
                <li><a href="https://www.uts.edu.co/ori/" target="_blank" rel="noopener" class="uts-menu-principal__enlace">Internacionalización</a></li>
            </ul>

            <div class="uts-menu-acciones">
                <span class="uts-badge-duts-header">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor"><circle cx="12" cy="12" r="10"></circle></svg>
                    DUTS UTS • 2026
                </span>
                <a href="https://www.uts.edu.co/inscripcion-presencial/" target="_blank" rel="noopener" class="uts-btn-inscripciones">
                    Inscripciones
                </a>
            </div>
        </div>
    </header>

    <nav class="uts-accesos-rapidos" aria-label="Accesos rápidos a servicios institucionales">
        <div class="uts-accesos-rapidos__interior">
            <div class="uts-accesos-rapidos__rotulo">
                <span>Acceso</span>
                <span>Rápido</span>
            </div>

            <ul class="uts-accesos-rapidos__lista">
                <li class="uts-acceso-item">
                    <a href="https://estudiante.uts.edu.co/uts/hermesoft/vortal/iniciarSesion.jsp" target="_blank" rel="noopener" class="uts-acceso-ficha" title="Matrículas, notas y liquidaciones">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="4" width="20" height="13" rx="2"></rect><path d="M8 21h8M12 17v4"></path></svg>
                        <div class="uts-acceso-textos">
                            <span class="uts-acceso-nombre">Sistema Académico</span>
                            <span class="uts-acceso-desc">Matrículas y notas</span>
                        </div>
                    </a>
                </li>

                <li class="uts-acceso-item">
                    <a href="https://atena.uts.edu.co/login/index.php" target="_blank" rel="noopener" class="uts-acceso-ficha" title="Campus virtual Moodle">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4.5A2.5 2.5 0 0 1 6.5 2H20v18H6.5A2.5 2.5 0 0 0 4 22z"></path><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path></svg>
                        <div class="uts-acceso-textos">
                            <span class="uts-acceso-nombre">Atena</span>
                            <span class="uts-acceso-desc">Campus virtual</span>
                        </div>
                    </a>
                </li>

                <li class="uts-acceso-item">
                    <a href="https://gdeco.uts.edu.co/pagosuts/info.php" target="_blank" rel="noopener" class="uts-acceso-ficha" title="Descarga de recibos y liquidaciones">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"></rect><line x1="2" y1="10" x2="22" y2="10"></line></svg>
                        <div class="uts-acceso-textos">
                            <span class="uts-acceso-nombre">Recibos de Pago</span>
                            <span class="uts-acceso-desc">Inscripciones y certificados</span>
                        </div>
                    </a>
                </li>

                <li class="uts-acceso-item">
                    <a href="https://www.utsvirtual.edu.co/sitio/" target="_blank" rel="noopener" class="uts-acceso-ficha" title="Educación virtual de pregrado y posgrado">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="2" y1="12" x2="22" y2="12"></line><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path></svg>
                        <div class="uts-acceso-textos">
                            <span class="uts-acceso-nombre">UTS Virtual</span>
                            <span class="uts-acceso-desc">Oferta educativa en línea</span>
                        </div>
                    </a>
                </li>

                <li class="uts-acceso-item">
                    <a href="https://www.uts.edu.co/calendario-academico/" target="_blank" rel="noopener" class="uts-acceso-ficha" title="Fechas y cronogramas institucionales">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                        <div class="uts-acceso-textos">
                            <span class="uts-acceso-nombre">Calendario Académico</span>
                            <span class="uts-acceso-desc">Fechas de procesos</span>
                        </div>
                    </a>
                </li>

                <li class="uts-acceso-item">
                    <a href="#login-card" class="uts-acceso-ficha uts-acceso-ficha--duts" title="Billetera de Recompensas y Requisito de Grado 70k">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        <div class="uts-acceso-textos">
                            <span class="uts-acceso-nombre">Billetera DUTS</span>
                            <span class="uts-acceso-desc">Requisito Grado (70k)</span>
                        </div>
                    </a>
                </li>

                <li class="uts-acceso-item">
                    <a href="https://www.uts.edu.co/portal-academico/" target="_blank" rel="noopener" class="uts-acceso-ficha uts-acceso-ficha--portal" title="Todos los servicios del portal">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                        <div class="uts-acceso-textos">
                            <span class="uts-acceso-nombre">Portal Académico</span>
                            <span class="uts-acceso-desc">Todos los servicios</span>
                        </div>
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <section class="uts-hero-principal" id="utsHeroBanner" style="background-image: url('${pageContext.request.contextPath}/public/banner.png');">
        <div class="uts-hero-velo"></div>

        <img src="${pageContext.request.contextPath}/assets/images/sello-acreditacion.svg" 
             alt="Sello Acreditada en Alta Calidad UV UTS - Resolución MEN" 
             class="uts-sello-acreditacion-banner" 
             onerror="this.style.display='none';">

        <div class="uts-hero-grid">
            <div class="uts-hero-info">
                <div class="uts-insignia-acreditacion" id="slideBadge">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                    <span>★ Acreditados en Alta Calidad • Ecosistema DUTS UTS</span>
                </div>

                <h1 class="uts-hero-titulo" id="slideTitle">
                    Ecosistema DUTS <br>
                    <span class="uts-limon">Méritos y Vida Universitaria</span>
                </h1>

                <!-- PREVISUALIZACIÓN DEL BANNER OFICIAL DUTS -->
                <div class="uts-hero-banner-card">
                    <div class="uts-hero-banner-wrapper">
                        <img src="${pageContext.request.contextPath}/public/banner.png" 
                             alt="Banner Oficial de Presentación DUTS - Ecosistema de Méritos y Vida Universitaria UTS" 
                             class="uts-hero-banner-media"
                             id="utsHeroBannerMedia"
                             loading="eager">
                        <div class="uts-hero-banner-tag">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            <span>Previsualización Oficial DUTS UTS</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/public/banner.png" 
                           target="_blank" 
                           rel="noopener" 
                           class="uts-hero-banner-zoom-btn"
                           title="Abrir imagen completa en alta resolución">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line><line x1="11" y1="8" x2="11" y2="14"></line><line x1="8" y1="11" x2="14" y2="11"></line></svg>
                            <span>Ver Banner</span>
                        </a>
                    </div>
                </div>

                <!-- DESCRIPCIÓN COMPLETA DEL ECOSISTEMA DUTS -->
                <div class="uts-duts-descripcion-destacada">
                    <p class="uts-hero-bajada" id="slideDescription">
                        <strong>¿Qué es DUTS?</strong> Es el ecosistema digital oficial de méritos académicos, participación estudiantil y recompensas de las <strong>Unidades Tecnológicas de Santander</strong>. Acumula puntos al participar activamente en semilleros de investigación, monitorías, eventos deportivos, culturales y retos de innovación. Realiza transferencias seguras e inmediatas entre compañeros uteístas y cumple la meta institucional de <strong>70.000 DUTS</strong> requerida para habilitar tu grado profesional.
                    </p>
                </div>

                <div class="uts-hero-pills">
                    <div class="uts-hero-pill-item">
                        <span class="uts-pill-dot">●</span>
                        <span>Meta de Grado: <strong>70.000 DUTS</strong></span>
                    </div>
                    <div class="uts-hero-pill-item">
                        <span class="uts-pill-dot">●</span>
                        <span>Transferencias Entre Uteístas</span>
                    </div>
                    <div class="uts-hero-pill-item">
                        <span class="uts-pill-dot">●</span>
                        <span>Semilleros &amp; Investigación</span>
                    </div>
                </div>

                <div class="uts-hero-acciones">
                    <a href="#login-card" class="uts-btn-hero-principal" id="slideBtnAction" onclick="document.getElementById('usuario').focus();">
                        <span>Ingresar a mi Billetera DUTS</span>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                    </a>

                    <a href="${pageContext.request.contextPath}/registro" class="uts-btn-hero-fantasma">
                        <span>Crear Cuenta (+500 DUTS)</span>
                    </a>
                </div>

                <div class="uts-hero-controles">
                    <button type="button" class="uts-slider-btn" id="heroPrevBtn" aria-label="Diapositiva anterior">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
                    </button>

                    <div class="uts-slider-dots">
                        <button type="button" class="uts-slider-dot activo" data-slide="0" aria-label="Diapositiva 1"></button>
                        <button type="button" class="uts-slider-dot" data-slide="1" aria-label="Diapositiva 2"></button>
                        <button type="button" class="uts-slider-dot" data-slide="2" aria-label="Diapositiva 3"></button>
                        <button type="button" class="uts-slider-dot" data-slide="3" aria-label="Diapositiva 4"></button>
                    </div>

                    <button type="button" class="uts-slider-btn" id="heroNextBtn" aria-label="Diapositiva siguiente">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </button>

                    <button type="button" class="uts-slider-pausa" id="heroPauseBtn" aria-label="Pausar o reanudar carrusel" title="Pausar rotación">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor" id="pauseIcon"><rect x="6" y="4" width="4" height="16"></rect><rect x="14" y="4" width="4" height="16"></rect></svg>
                    </button>
                </div>
            </div>

            <div class="uts-hero-login-card" id="login-card">
                <div class="uts-mobile-app-handle" aria-hidden="true"></div>

                <span class="uts-card-segura-badge">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                    Portal Seguro UTS
                </span>

                <div class="uts-card-header">
                    <h2 class="uts-card-titulo">Acceso a tu Cuenta</h2>
                    <p class="uts-card-subtitulo">Estudiantes, docentes y personal institucional UTS</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="uts-alerta uts-alerta--error">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        <span><c:out value="${error}" /></span>
                    </div>
                </c:if>
                <c:if test="${not empty exito}">
                    <div class="uts-alerta uts-alerta--exito">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        <span><c:out value="${exito}" /></span>
                    </div>
                </c:if>

                <button type="button" class="uts-btn-sso" onclick="document.getElementById('usuario').focus();">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                    <span>Ingresar con Correo Institucional UTS</span>
                </button>

                <div class="uts-divider-or">o mediante usuario y contraseña</div>

                <form action="${pageContext.request.contextPath}/index" method="POST" autocomplete="on">
                    <div class="uts-form-group">
                        <label for="usuario" class="uts-form-label">
                            <span>Usuario o Código Estudiantil</span>
                        </label>
                        <div class="uts-input-wrap">
                            <span class="uts-input-icon">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                            </span>
                            <input type="text" id="usuario" name="usuario" class="uts-input-field" required 
                                   placeholder="Ingresa tu usuario o código" 
                                   value="<c:out value='${param.usuario}'/>">
                        </div>
                    </div>

                    <div class="uts-form-group">
                        <label for="clave" class="uts-form-label">
                            <span>Contraseña Institucional</span>
                            <button type="button" class="uts-link-olvido" onclick="abrirModalRecuperar();">¿Olvidó su clave?</button>
                        </label>
                        <div class="uts-input-wrap">
                            <span class="uts-input-icon">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                            </span>
                            <input type="password" id="clave" name="clave" class="uts-input-field" required placeholder="••••••••">
                            <button type="button" class="uts-toggle-pass" id="btnTogglePassword" aria-label="Mostrar u ocultar contraseña">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="uts-btn-submit">
                        <span>Ingresar a la Plataforma</span>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                    </button>
                </form>

                <div class="uts-registro-card-callout">
                    <span>¿Aún no tienes cuenta activa en el sistema DUTS?</span>
                    <a href="${pageContext.request.contextPath}/registro" class="uts-registro-link">
                        <span>Crear cuenta nueva / Registrarse como Uteísta</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                </div>

                <div class="uts-mobile-app-shortcuts">
                    <span class="uts-shortcuts-title">Accesos Rápidos Institucionales</span>
                    <div class="uts-shortcuts-grid">
                        <a href="https://estudiante.uts.edu.co/uts/hermesoft/vortal/iniciarSesion.jsp" target="_blank" rel="noopener" class="uts-shortcut-btn">
                            <span class="uts-shortcut-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="4" width="20" height="13" rx="2"></rect><path d="M8 21h8M12 17v4"></path></svg>
                            </span>
                            <span class="uts-shortcut-label">Académico</span>
                        </a>
                        <a href="https://atena.uts.edu.co/login/index.php" target="_blank" rel="noopener" class="uts-shortcut-btn">
                            <span class="uts-shortcut-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4.5A2.5 2.5 0 0 1 6.5 2H20v18H6.5A2.5 2.5 0 0 0 4 22z"></path><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path></svg>
                            </span>
                            <span class="uts-shortcut-label">Atena</span>
                        </a>
                        <a href="https://gdeco.uts.edu.co/pagosuts/info.php" target="_blank" rel="noopener" class="uts-shortcut-btn">
                            <span class="uts-shortcut-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"></rect><line x1="2" y1="10" x2="22" y2="10"></line></svg>
                            </span>
                            <span class="uts-shortcut-label">Recibos</span>
                        </a>
                        <a href="https://www.uts.edu.co/directorio-institucional/" target="_blank" rel="noopener" class="uts-shortcut-btn">
                            <span class="uts-shortcut-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
                            </span>
                            <span class="uts-shortcut-label">Contacto</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <nav class="uts-de-interes-bar" aria-label="Enlaces de interés">
        <div class="uts-de-interes-bar__interior">
            <div class="uts-de-interes-left">
                <span class="uts-de-interes-etiqueta">De Interés</span>

                <ul class="uts-redes-lista">
                    <li>
                        <a href="https://www.facebook.com/UnidadesTecnologicasdeSantanderUTS/" target="_blank" rel="noopener" class="uts-red-enlace" title="Facebook UTS">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.5 2 2 6.5 2 12c0 5 3.7 9.1 8.4 9.9v-7H7.9V12h2.5V9.8c0-2.5 1.5-3.9 3.8-3.9 1.1 0 2.2.2 2.2.2v2.5h-1.3c-1.2 0-1.6.8-1.6 1.6V12h2.8l-.4 2.9h-2.3v7C18.3 21.1 22 17 22 12c0-5.5-4.5-10-10-10z"></path></svg>
                        </a>
                    </li>
                    <li>
                        <a href="https://x.com/Unidades_UTS" target="_blank" rel="noopener" class="uts-red-enlace" title="X / Twitter UTS">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M13.982 10.622 20.54 3h-1.554l-5.693 6.618L8.745 3H3.5l6.876 10.007L3.5 21h1.554l6.012-6.989L15.868 21h5.245l-7.131-10.378Zm-2.128 2.474-.697-.997-5.543-7.93H8l4.474 6.4.697.996 5.815 8.318h-2.387l-4.745-6.787Z"></path></svg>
                        </a>
                    </li>
                    <li>
                        <a href="https://www.youtube.com/channel/UC-rIi4OnN0R10Wp-cPiLcpQ" target="_blank" rel="noopener" class="uts-red-enlace" title="YouTube UTS">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M21.8,8.001c0,0-0.195-1.378-0.795-1.985c-0.76-0.797-1.613-0.801-2.004-0.847c-2.799-0.202-6.997-0.202-6.997-0.202 h-0.009c0,0-4.198,0-6.997,0.202C4.608,5.216,3.756,5.22,2.995,6.016C2.395,6.623,2.2,8.001,2.2,8.001S2,9.62,2,11.238v1.517 c0,1.618,0.2,3.237,0.2,3.237s0.195,1.378,0.795,1.985c0.761,0.797,1.76,0.771,2.205,0.855c1.6,0.153,6.8,0.201,6.8,0.201 s4.203-0.006,7.001-0.209c0.391-0.047,1.243-0.051,2.004-0.847c0.6-0.607,0.795-1.985,0.795-1.985s0.2-1.618,0.2-3.237v-1.517 C22,9.62,21.8,8.001,21.8,8.001z M9.935,14.594l-0.001-5.62l5.404,2.82L9.935,14.594z"></path></svg>
                        </a>
                    </li>
                    <li>
                        <a href="https://www.instagram.com/unidades_uts/" target="_blank" rel="noopener" class="uts-red-enlace" title="Instagram UTS">
                            <svg width="17" height="17" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"></path></svg>
                        </a>
                    </li>
                    <li>
                        <a href="https://www.linkedin.com/school/unidades-tecnol-gicas-de-santander/" target="_blank" rel="noopener" class="uts-red-enlace" title="LinkedIn UTS">
                            <svg width="17" height="17" viewBox="0 0 24 24" fill="currentColor"><path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"></path></svg>
                        </a>
                    </li>
                </ul>

                <ul class="uts-de-interes-links">
                    <li><a href="https://www.uts.edu.co/politica-de-gratuidad/" target="_blank" rel="noopener">Política de gratuidad</a></li>
                    <li><a href="https://www.uts.edu.co/bienestar/" target="_blank" rel="noopener">Bienestar institucional</a></li>
                    <li><a href="https://fondoemprender.uts.edu.co/" target="_blank" rel="noopener">Fondo Emprender</a></li>
                    <li><a href="https://www.uts.edu.co/cotizaciones/" target="_blank" rel="noopener">Cotizaciones</a></li>
                </ul>
            </div>

            <button type="button" class="uts-chat-ayuda-pill" onclick="alert('Mesa de Ayuda UTS DUTS:\nCorreo: duts@correo.uts.edu.co\nPBX: +57 (607) 6917700 Ext. 1000\nHorario: Lunes a Viernes 8:00 AM - 6:00 PM');">
                <span>¿Necesitas ayuda?</span>
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
            </button>
        </div>
    </nav>

    <section class="uts-seccion-ecosistema" id="ecosistema">
        <div class="uts-seccion-ecosistema__interior">
            <div class="uts-cabecera-bloque">
                <span class="uts-rotulo-pilar">Innovación Académica Institucional</span>
                <h2 class="uts-titulo-bloque">Ecosistema de Méritos &amp; Vida Universitaria UTS</h2>
                <p class="uts-bajada-bloque">
                    Una plataforma pionera desarrollada por las Unidades Tecnológicas de Santander para incentivar la participación estudiantil, certificar méritos académicos y gestionar tu billetera digital institucional.
                </p>
            </div>

            <!-- BANNER OFICIAL DE PRESENTACIÓN DUTS -->
            <div class="uts-banner-showcase-container">
                <div class="uts-banner-showcase-card">
                    <div class="uts-banner-showcase-media">
                        <img src="${pageContext.request.contextPath}/public/banner.png" 
                             alt="Ecosistema de Méritos y Vida Universitaria DUTS UTS" 
                             class="uts-banner-showcase-img"
                             loading="lazy">
                        <div class="uts-banner-tag-floating">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            <span>Ecosistema Oficial DUTS • Meta 70.000 DUTS</span>
                        </div>
                    </div>
                    <div class="uts-banner-showcase-content">
                        <span class="uts-banner-mini-badge">Previsualización del Ecosistema</span>
                        <h3 class="uts-banner-showcase-title">¿Cómo Funciona el Ecosistema DUTS UTS?</h3>
                        <p class="uts-banner-showcase-text">
                            <strong>DUTS</strong> es el ecosistema institucional de méritos académicos, vida estudiantil y reconocimiento de las <strong>Unidades Tecnológicas de Santander</strong>. Permite a los estudiantes acumular puntos participando en semilleros, conferencias, eventos deportivos y retos de innovación hasta alcanzar la meta obligatoria de <strong>70.000 DUTS</strong> para obtener el grado profesional.
                        </p>
                        <div class="uts-banner-features-mini">
                            <div class="uts-banner-feature-item">
                                <span class="uts-feature-bullet">✓</span>
                                <span>Billetera móvil con saldo y transferencias inmediatas entre estudiantes</span>
                            </div>
                            <div class="uts-banner-feature-item">
                                <span class="uts-feature-bullet">✓</span>
                                <span>Certificación automática de méritos extracurriculares e investigación</span>
                            </div>
                            <div class="uts-banner-feature-item">
                                <span class="uts-feature-bullet">✓</span>
                                <span>Comprobantes oficiales de movimientos en PDF con validación criptográfica</span>
                            </div>
                        </div>
                        <div class="uts-banner-showcase-actions">
                            <a href="#login-card" class="uts-btn-banner-login" onclick="document.getElementById('usuario').focus();">
                                <span>Ingresar a mi Billetera DUTS</span>
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
                            </a>
                            <a href="${pageContext.request.contextPath}/registro" class="uts-btn-banner-registro">
                                <span>Crear Cuenta (+500 DUTS)</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="uts-grid-beneficios">
                <div class="uts-card-beneficio">
                    <div>
                        <div class="uts-card-beneficio__icono">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="7"></circle><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline></svg>
                        </div>
                        <h3 class="uts-card-beneficio__titulo">Requisito Obligatorio (70k)</h3>
                        <p class="uts-card-beneficio__texto">
                            Acumula 70.000 DUTS asistiendo a conferencias, foros y actividades extracurriculares certificadas para habilitar tu grado académico.
                        </p>
                    </div>
                    <a href="#login-card" class="uts-card-beneficio__enlace">
                        Consultar avance
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                </div>

                <div class="uts-card-beneficio">
                    <div>
                        <div class="uts-card-beneficio__icono">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                        </div>
                        <h3 class="uts-card-beneficio__titulo">Semilleros de Investigación</h3>
                        <p class="uts-card-beneficio__texto">
                            Participa en grupos del Centro de Investigaciones UTS y recibe abonos automáticos de hasta +2.500 DUTS directos en tu saldo.
                        </p>
                    </div>
                    <a href="https://www.uts.edu.co/investigacion/" target="_blank" rel="noopener" class="uts-card-beneficio__enlace">
                        Ver convocatorias
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                </div>

                <div class="uts-card-beneficio">
                    <div>
                        <div class="uts-card-beneficio__icono">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="4" width="22" height="16" rx="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg>
                        </div>
                        <h3 class="uts-card-beneficio__titulo">Transferencias Inmediatas</h3>
                        <p class="uts-card-beneficio__texto">
                            Envía y recibe puntos con tus compañeros de facultad de forma rápida, segura e instantánea mediante tu código de estudiante.
                        </p>
                    </div>
                    <a href="#login-card" class="uts-card-beneficio__enlace">
                        Acceder a billetera
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                </div>

                <div class="uts-card-beneficio">
                    <div>
                        <div class="uts-card-beneficio__icono">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                        </div>
                        <h3 class="uts-card-beneficio__titulo">Extractos Electrónicos PDF</h3>
                        <p class="uts-card-beneficio__texto">
                            Genera y descarga tus certificados oficiales de saldo y movimientos con validación digital y firma de la institución.
                        </p>
                    </div>
                    <a href="#login-card" class="uts-card-beneficio__enlace">
                        Descargar reporte
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                </div>
            </div>

            <div class="uts-franja-cifras">
                <div class="uts-cifra-item">
                    <h3>62+</h3>
                    <p>Años formando profesionales en Santander</p>
                </div>
                <div class="uts-cifra-item">
                    <h3>70.000</h3>
                    <p>DUTS de meta para certificar tu grado</p>
                </div>
                <div class="uts-cifra-item">
                    <h3>5 Sedes</h3>
                    <p>Bucaramanga, Barrancabermeja, Vélez, Piedecuesta y Virtual</p>
                </div>
                <div class="uts-cifra-item">
                    <h3>100%</h3>
                    <p>Acreditación Institucional en Alta Calidad</p>
                </div>
            </div>
        </div>
    </section>

    <footer class="uts-pie-pagina">
        <div class="uts-pie-pagina__interior">
            <div class="uts-pie-grid">
                <div class="uts-pie-col">
                    <h4>Institución Universitaria</h4>
                    <p>
                        <strong>Unidades Tecnológicas de Santander (UTS)</strong><br>
                        Acreditada en Alta Calidad por el Ministerio de Educación Nacional según Resolución MEN 000237.<br>
                        Personería Jurídica 4038 de 1963.
                    </p>
                    <p style="color: var(--uts-verde-limon); font-weight: 700;">
                        ¡Lo hacemos posible! • Sistema DUTS 2026
                    </p>
                </div>

                <div class="uts-pie-col">
                    <h4>Sede Bucaramanga</h4>
                    <p>
                        Calle de los Estudiantes #9-82, Ciudadela Real de Minas.<br>
                        Bucaramanga, Santander, Colombia.<br>
                        <strong>PBX:</strong> +57 (607) 6917700<br>
                        <strong>Atención:</strong> Lunes a Viernes 7:30 a.m. - 12:00 m. / 1:30 p.m. - 6:00 p.m.
                    </p>
                </div>

                <div class="uts-pie-col">
                    <h4>Sedes Regionales</h4>
                    <ul>
                        <li><a href="https://www.uts.edu.co/regionales/" target="_blank" rel="noopener">Barrancabermeja</a></li>
                        <li><a href="https://www.uts.edu.co/regionales/" target="_blank" rel="noopener">Piedecuesta</a></li>
                        <li><a href="https://www.uts.edu.co/regionales/" target="_blank" rel="noopener">Vélez</a></li>
                        <li><a href="https://www.utsvirtual.edu.co/sitio/" target="_blank" rel="noopener">Campus Virtual</a></li>
                    </ul>
                </div>

                <div class="uts-pie-col">
                    <h4>Atención &amp; Enlaces</h4>
                    <ul>
                        <li><a href="mailto:duts@correo.uts.edu.co">Soporte DUTS: duts@correo.uts.edu.co</a></li>
                        <li><a href="https://www.uts.edu.co/atencion-al-ciudadano/" target="_blank" rel="noopener">PQRSDF Institucional</a></li>
                        <li><a href="https://www.uts.edu.co/politica-de-sostenibilidad/" target="_blank" rel="noopener">Política de Privacidad</a></li>
                        <li><a href="https://www.uts.edu.co/transparencia/" target="_blank" rel="noopener">Transparencia y Acceso a la Información</a></li>
                    </ul>
                </div>
            </div>

            <div class="uts-pie-copy">
                <div>
                    © 2026 <strong>Universitaria Tecnológica de Santander – UTS</strong>. Todos los derechos reservados.
                </div>
                <div>
                    Institución sujeta a inspección y vigilancia por el Ministerio de Educación Nacional.
                </div>
            </div>
        </div>
    </footer>

    <script>
        (function() {
            const slidesData = [
                {
                    bg: '${pageContext.request.contextPath}/public/banner.png',
                    badge: '★ Ecosistema Oficial DUTS UTS',
                    title: 'Ecosistema DUTS <br><span class="uts-limon">Méritos y Vida Universitaria</span>',
                    desc: '<strong>¿Qué es DUTS?</strong> Es el ecosistema digital oficial de méritos académicos, participación estudiantil y recompensas de las <strong>Unidades Tecnológicas de Santander</strong>. Acumula puntos en semilleros, conferencias, eventos deportivos y retos de innovación. Realiza transferencias seguras entre uteístas y cumple la meta de <strong>70.000 DUTS</strong> requerida para habilitar tu grado profesional.',
                    btnText: 'Ingresar a mi Billetera DUTS'
                },
                {
                    bg: '${pageContext.request.contextPath}/assets/images/banner-inscripciones.jpg',
                    badge: '★ Convocatorias 2026-II Abiertas',
                    title: 'Inscripciones Abiertas <br><span class="uts-limon">Periodo 2026 - 2027</span>',
                    desc: 'Inscríbete a los programas de pregrado con Política de Gratuidad. Participa en los semilleros del Centro de Investigaciones y recibe abonos de méritos DUTS en tu billetera digital.',
                    btnText: 'Conocer Convocatorias'
                },
                {
                    bg: '${pageContext.request.contextPath}/assets/images/uts_campus_estudiantes.png',
                    badge: '★ Semilleros de Investigación I+D+i',
                    title: 'Vida Universitaria <br><span class="uts-limon">&amp; Méritos Académicos</span>',
                    desc: 'Participa en foros, talleres de innovación tecnológica y monitorías para acumular puntos institucionales con certificación oficial para tu hoja de vida.',
                    btnText: 'Inscribir Semillero'
                },
                {
                    bg: '${pageContext.request.contextPath}/assets/images/uts_campus_plazoleta.png',
                    badge: '★ Instalaciones y Tecnología UTS',
                    title: 'Campus Bucaramanga, <br><span class="uts-limon">Regionales &amp; UTS Virtual</span>',
                    desc: 'Laboratorios modernos, plazoleta central y salas digitales de cómputo para potenciar tu formación técnica y universitaria con altos estándares de calidad.',
                    btnText: 'Explorar Sedes'
                }
            ];

            const heroBanner = document.getElementById('utsHeroBanner');
            const slideBadge = document.getElementById('slideBadge');
            const slideTitle = document.getElementById('slideTitle');
            const slideDesc = document.getElementById('slideDescription');
            const slideBtnAction = document.getElementById('slideBtnAction');
            const dots = document.querySelectorAll('.uts-slider-dot');
            const prevBtn = document.getElementById('heroPrevBtn');
            const nextBtn = document.getElementById('heroNextBtn');
            const pauseBtn = document.getElementById('heroPauseBtn');
            const pauseIcon = document.getElementById('pauseIcon');

            let currentIndex = 0;
            let timer = null;
            let isPaused = false;
            const SLIDE_INTERVAL = 6000;

            function showSlide(index) {
                if (index < 0) index = slidesData.length - 1;
                if (index >= slidesData.length) index = 0;
                currentIndex = index;

                const data = slidesData[currentIndex];

                heroBanner.style.backgroundImage = "url('" + data.bg + "')";

                slideBadge.innerHTML = '<svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg> ' + data.badge;
                slideTitle.innerHTML = data.title;
                slideDesc.innerHTML = data.desc;
                slideBtnAction.querySelector('span').textContent = data.btnText;

                dots.forEach((dot, idx) => {
                    if (idx === currentIndex) {
                        dot.classList.add('activo');
                    } else {
                        dot.classList.remove('activo');
                    }
                });
            }

            function startTimer() {
                clearInterval(timer);
                timer = setInterval(() => {
                    if (!isPaused) {
                        showSlide(currentIndex + 1);
                    }
                }, SLIDE_INTERVAL);
            }

            dots.forEach((dot, idx) => {
                dot.addEventListener('click', () => {
                    showSlide(idx);
                    startTimer();
                });
            });

            if (prevBtn) {
                prevBtn.addEventListener('click', () => {
                    showSlide(currentIndex - 1);
                    startTimer();
                });
            }

            if (nextBtn) {
                nextBtn.addEventListener('click', () => {
                    showSlide(currentIndex + 1);
                    startTimer();
                });
            }

            if (pauseBtn) {
                pauseBtn.addEventListener('click', () => {
                    isPaused = !isPaused;
                    if (isPaused) {
                        pauseIcon.innerHTML = '<polygon points="5 3 19 12 5 21 5 3"></polygon>';
                        pauseBtn.title = 'Reanudar rotación';
                    } else {
                        pauseIcon.innerHTML = '<rect x="6" y="4" width="4" height="16"></rect><rect x="14" y="4" width="4" height="16"></rect>';
                        pauseBtn.title = 'Pausar rotación';
                    }
                });
            }

            heroBanner.addEventListener('mouseenter', () => { isPaused = true; });
            heroBanner.addEventListener('mouseleave', () => { isPaused = false; });

            const togglePassBtn = document.getElementById('btnTogglePassword');
            const passInput = document.getElementById('clave');
            if (togglePassBtn && passInput) {
                togglePassBtn.addEventListener('click', () => {
                    const isPass = passInput.type === 'password';
                    passInput.type = isPass ? 'text' : 'password';
                    togglePassBtn.innerHTML = isPass ? 
                        '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>' : 
                        '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>';
                });
            }

            showSlide(0);
            startTimer();
        })();

        // Funciones del Modal Institucional de Recuperación
        function abrirModalRecuperar() {
            const modal = document.getElementById('modalRecuperar');
            const alertBox = document.getElementById('recuperarAlerta');
            if (modal) {
                modal.style.display = 'flex';
                if (alertBox) alertBox.style.display = 'none';
                // Copiar usuario del formulario si ya había escrito algo
                const usuarioActual = document.getElementById('usuario');
                const usuarioRecuperar = document.getElementById('recuperarUsuario');
                if (usuarioActual && usuarioRecuperar && usuarioActual.value) {
                    usuarioRecuperar.value = usuarioActual.value.trim();
                }
                setTimeout(() => {
                    const primerInput = usuarioRecuperar && usuarioRecuperar.value ? 
                        document.getElementById('recuperarCorreo') : usuarioRecuperar;
                    if (primerInput) primerInput.focus();
                }, 100);
            }
        }

        function cerrarModalRecuperar() {
            const modal = document.getElementById('modalRecuperar');
            if (modal) {
                modal.style.display = 'none';
            }
        }

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                cerrarModalRecuperar();
            }
        });

        async function enviarRecuperacion(e) {
            e.preventDefault();
            const btn = document.getElementById('btnSubmitRecuperar');
            const alertBox = document.getElementById('recuperarAlerta');
            const usuario = document.getElementById('recuperarUsuario').value.trim();
            const correo = document.getElementById('recuperarCorreo').value.trim();
            const nuevaClave = document.getElementById('recuperarNuevaClave').value;
            const confirmarClave = document.getElementById('recuperarConfirmarClave').value;

            if (nuevaClave !== confirmarClave) {
                alertBox.className = 'uts-modal-alerta uts-modal-alerta--error';
                alertBox.innerText = 'Las contraseñas no coinciden. Por favor verifícalas.';
                alertBox.style.display = 'flex';
                return;
            }

            if (nuevaClave.length < 8) {
                alertBox.className = 'uts-modal-alerta uts-modal-alerta--error';
                alertBox.innerText = 'La contraseña debe tener como mínimo 8 caracteres.';
                alertBox.style.display = 'flex';
                return;
            }

            const textoOriginal = btn.innerHTML;
            btn.disabled = true;
            btn.innerHTML = '<span>Verificando con UTS...</span>';
            alertBox.style.display = 'none';

            try {
                const params = new URLSearchParams();
                params.append('usuario', usuario);
                params.append('correo', correo);
                params.append('nuevaClave', nuevaClave);
                params.append('confirmarClave', confirmarClave);

                const response = await fetch('${pageContext.request.contextPath}/recuperar-clave', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                    body: params.toString()
                });

                const data = await response.json();

                if (response.ok && data.status === 'success') {
                    alertBox.className = 'uts-modal-alerta uts-modal-alerta--exito';
                    alertBox.innerText = data.message;
                    alertBox.style.display = 'flex';

                    // Actualizar el campo de login principal
                    const inputLoginUsuario = document.getElementById('usuario');
                    const inputLoginClave = document.getElementById('clave');
                    if (inputLoginUsuario) inputLoginUsuario.value = usuario;
                    if (inputLoginClave) inputLoginClave.value = '';

                    setTimeout(() => {
                        cerrarModalRecuperar();
                        if (inputLoginClave) inputLoginClave.focus();
                    }, 2200);
                } else {
                    alertBox.className = 'uts-modal-alerta uts-modal-alerta--error';
                    alertBox.innerText = data.message || 'No se pudo restablecer la contraseña. Verifica tus datos.';
                    alertBox.style.display = 'flex';
                }
            } catch (err) {
                alertBox.className = 'uts-modal-alerta uts-modal-alerta--error';
                alertBox.innerText = 'Error de conexión con el servidor. Intenta de nuevo.';
                alertBox.style.display = 'flex';
            } finally {
                btn.disabled = false;
                btn.innerHTML = textoOriginal;
            }
        }
    </script>

    <!-- MODAL INSTITUCIONAL: RECUPERACIÓN DE CONTRASEÑA -->
    <div id="modalRecuperar" class="uts-modal-recuperar" style="display:none;" role="dialog" aria-modal="true" aria-labelledby="modalTitulo">
        <div class="uts-modal-recuperar__backdrop" onclick="cerrarModalRecuperar();"></div>
        <div class="uts-modal-recuperar__dialog">
            <div class="uts-modal-recuperar__header">
                <div class="uts-modal-recuperar__title-box">
                    <span class="uts-modal-badge">Seguridad Institucional UTS</span>
                    <h2 id="modalTitulo" class="uts-modal-title">Restablecer Contraseña</h2>
                    <p class="uts-modal-subtitle">Ecosistema de Méritos DUTS • Unidades Tecnológicas de Santander</p>
                </div>
                <button type="button" class="uts-modal-close" onclick="cerrarModalRecuperar();" aria-label="Cerrar">&times;</button>
            </div>

            <div id="recuperarAlerta" class="uts-modal-alerta" style="display:none;"></div>

            <form id="formRecuperar" onsubmit="enviarRecuperacion(event);" class="uts-modal-form">
                <div class="uts-form-group">
                    <label for="recuperarUsuario" class="uts-form-label">
                        <span>Usuario o Código Estudiantil</span>
                    </label>
                    <div class="uts-input-wrap">
                        <span class="uts-input-icon">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        </span>
                        <input type="text" id="recuperarUsuario" name="usuario" class="uts-input-field" required placeholder="Ej: estudiante o 1098765432">
                    </div>
                </div>

                <div class="uts-form-group">
                    <label for="recuperarCorreo" class="uts-form-label">
                        <span>Correo Institucional Registrado</span>
                    </label>
                    <div class="uts-input-wrap">
                        <span class="uts-input-icon">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                        </span>
                        <input type="email" id="recuperarCorreo" name="correo" class="uts-input-field" required placeholder="tu.correo@correo.uts.edu.co">
                    </div>
                </div>

                <div class="uts-form-group">
                    <label for="recuperarNuevaClave" class="uts-form-label">
                        <span>Nueva Contraseña</span>
                    </label>
                    <div class="uts-input-wrap">
                        <span class="uts-input-icon">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                        </span>
                        <input type="password" id="recuperarNuevaClave" name="nuevaClave" class="uts-input-field" required minlength="8" placeholder="Mínimo 8 caracteres">
                    </div>
                </div>

                <div class="uts-form-group">
                    <label for="recuperarConfirmarClave" class="uts-form-label">
                        <span>Confirmar Nueva Contraseña</span>
                    </label>
                    <div class="uts-input-wrap">
                        <span class="uts-input-icon">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        </span>
                        <input type="password" id="recuperarConfirmarClave" name="confirmarClave" class="uts-input-field" required minlength="8" placeholder="Repite tu nueva contraseña">
                    </div>
                </div>

                <div class="uts-modal-recuperar__actions">
                    <button type="button" class="uts-modal-btn-cancel" onclick="cerrarModalRecuperar();">Cancelar</button>
                    <button type="submit" id="btnSubmitRecuperar" class="uts-btn-submit" style="margin-top:0; margin-bottom:0; width:auto; padding: 11px 22px;">
                        <span>Restablecer Contraseña</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
