<%@ page import="tele_expertise.enums.RoleUtilisateur" %>
<%@ page import="tele_expertise.entity.DemandeExpertise" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%

    if (session == null || session.getAttribute("loggedUser") == null || session.getAttribute("role") != RoleUtilisateur.SPECIALISTE) {
        request.setAttribute("error", "Session expired");
        request.getRequestDispatcher("Login.jsp").forward(request, response);

    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Spécialiste - Digital Clinic</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: 'oklch(0.55 0.15 240)',
                        'primary-foreground': 'oklch(0.99 0 0)',
                        secondary: 'oklch(0.65 0.12 200)',
                        background: 'oklch(0.99 0.005 240)',
                        foreground: 'oklch(0.25 0.015 240)',
                        muted: 'oklch(0.96 0.01 240)',
                        'muted-foreground': 'oklch(0.55 0.015 240)',
                        border: 'oklch(0.90 0.01 240)',
                        input: 'oklch(0.95 0.01 240)',
                    }
                }
            }
        }
    </script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

        * {
            font-family: 'Inter', sans-serif;
        }

        .card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .card:hover {
            transform: translateY(-2px);
        }

        .badge-en-attente {
            background-color: oklch(0.97 0.02 85);
            color: oklch(0.55 0.15 85);
        }

        .badge-terminee {
            background-color: oklch(0.97 0.02 160);
            color: oklch(0.55 0.15 160);
        }

        .badge-urgente {
            background-color: oklch(0.97 0.02 25);
            color: oklch(0.55 0.15 25);
        }

        .badge-normale {
            background-color: oklch(0.97 0.02 240);
            color: oklch(0.55 0.15 240);
        }

        .badge-non-urgente {
            background-color: oklch(0.96 0.01 240);
            color: oklch(0.55 0.015 240);
        }
    </style>
</head>
<body class="bg-background text-foreground">

<!-- Navbar -->
<nav class="bg-primary shadow-sm border-b border-border">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="flex items-center">
                <svg class="h-8 w-8 text-primary-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                </svg>
                <h1 class="ml-3 text-xl font-semibold text-primary-foreground">Digital Clinic</h1>
            </div>

            <div class="flex items-center space-x-4">
        <span class="text-primary-foreground text-sm">
          <svg class="inline h-4 w-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
          </svg>
          Dr. ${sessionScope.loggedUser.nom} ${sessionScope.loggedUser.prenom}
        </span>
                <a href="${pageContext.request.contextPath}/Logout"
                   class="bg-primary-foreground text-primary px-4 py-2 rounded-lg hover:opacity-90 transition text-sm font-medium">
                    Déconnexion
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Messages -->
    <c:if test="${not empty sessionScope.success}">
        <div class="bg-green-50 border border-green-200 text-green-800 px-4 py-3 rounded-lg mb-6 flex items-center">
            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
            </svg>
                ${sessionScope.success}
        </div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-lg mb-6 flex items-center">
            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
                ${sessionScope.error}
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <!-- Profile Info -->
    <div class="bg-white rounded-xl border border-border p-6 mb-8">
        <div class="flex items-center justify-between">
            <div class="flex items-center">
                <div class="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center">
                    <c:choose>
                        <c:when test="${not empty specialiste.prenom and not empty specialiste.nom}">
              <span class="text-primary font-bold text-2xl">
                      ${specialiste.prenom.substring(0,1)}${specialiste.nom.substring(0,1)}
              </span>
                        </c:when>
                        <c:otherwise>
                            <span class="text-primary font-bold text-2xl">SP</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="ml-4">
                    <h2 class="text-2xl font-bold text-foreground">Dr. ${specialiste.nom} ${specialiste.prenom}</h2>
                    <p class="text-muted-foreground">
                        <c:choose>
                            <c:when test="${not empty specialiste.specialite}">
                                ${specialiste.specialite.nom}
                            </c:when>
                            <c:otherwise>
                                Spécialiste
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p class="text-sm text-muted-foreground mt-1">
                        Tarif: <span class="font-semibold text-primary">
              <c:choose>
                  <c:when test="${not empty specialiste.tarif}">
                      ${specialiste.tarif}
                  </c:when>
                  <c:otherwise>
                      0.00
                  </c:otherwise>
              </c:choose> DH
            </span> par consultation
                    </p>
                </div>
            </div>
            <div class="text-right">
                <c:choose>
                    <c:when test="${specialiste.disponible}">
            <span class="inline-flex items-center px-3 py-1 text-sm font-medium text-green-800 bg-green-100 rounded-full">
              <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                <circle cx="10" cy="10" r="5"/>
              </svg>
              Disponible
            </span>
                    </c:when>
                    <c:otherwise>
            <span class="inline-flex items-center px-3 py-1 text-sm font-medium text-muted-foreground bg-muted rounded-full">
              Indisponible
            </span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Statistiques -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <div class="bg-primary rounded-xl p-6 text-primary-foreground shadow-sm">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-primary-foreground/80 text-sm font-medium">Total demandes</p>
                    <p class="text-3xl font-bold mt-2">
                        <c:choose>
                            <c:when test="${not empty totalDemandes}">${totalDemandes}</c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <svg class="h-12 w-12 text-primary-foreground/30" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
            </div>
        </div>

        <div class="bg-white rounded-xl p-6 border border-border shadow-sm">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-muted-foreground text-sm font-medium">En attente</p>
                    <p class="text-3xl font-bold text-amber-600 mt-2">
                        <c:choose>
                            <c:when test="${not empty enAttenteCount}">${enAttenteCount}</c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <svg class="h-12 w-12 text-amber-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
        </div>

        <div class="bg-white rounded-xl p-6 border border-border shadow-sm">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-muted-foreground text-sm font-medium">Terminées</p>
                    <p class="text-3xl font-bold text-green-600 mt-2">
                        <c:choose>
                            <c:when test="${not empty termineesCount}">${termineesCount}</c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <svg class="h-12 w-12 text-green-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
        </div>

        <div class="bg-white rounded-xl p-6 border border-border shadow-sm">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-muted-foreground text-sm font-medium">Créneaux libres</p>
                    <p class="text-3xl font-bold text-primary mt-2">
                        <c:choose>
                            <c:when test="${not empty creneauxLibres}">${creneauxLibres}</c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <svg class="h-12 w-12 text-primary/30" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                </svg>
            </div>
        </div>
    </div>

    <!-- Actions rapides -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <a href="${pageContext.request.contextPath}/specialiste/demandes"
           class="card bg-white rounded-xl p-6 border border-border hover:border-primary transition-all">
            <div class="flex items-center">
                <div class="bg-primary/10 rounded-lg p-3">
                    <svg class="h-8 w-8 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                    </svg>
                </div>
                <div class="ml-4">
                    <h3 class="text-lg font-semibold text-foreground">Demandes d'expertise</h3>
                    <p class="text-sm text-muted-foreground mt-1">Consulter et répondre</p>
                </div>
            </div>
        </a>

        <a href="${pageContext.request.contextPath}/specialiste/creneaux"
           class="card bg-white rounded-xl p-6 border border-border hover:border-primary transition-all">
            <div class="flex items-center">
                <div class="bg-primary/10 rounded-lg p-3">
                    <svg class="h-8 w-8 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                    </svg>
                </div>
                <div class="ml-4">
                    <h3 class="text-lg font-semibold text-foreground">Mes créneaux</h3>
                    <p class="text-sm text-muted-foreground mt-1">Gérer ma disponibilité</p>
                </div>
            </div>
        </a>

        <a href="${pageContext.request.contextPath}/specialiste/profil"
           class="card bg-white rounded-xl p-6 border border-border hover:border-primary transition-all">
            <div class="flex items-center">
                <div class="bg-primary/10 rounded-lg p-3">
                    <svg class="h-8 w-8 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                    </svg>
                </div>
                <div class="ml-4">
                    <h3 class="text-lg font-semibold text-foreground">Mon profil</h3>
                    <p class="text-sm text-muted-foreground mt-1">Modifier mes informations</p>
                </div>
            </div>
        </a>
    </div>

    <!-- Filtres -->
    <div class="bg-white rounded-xl border border-border p-6 mb-6">
        <div class="flex items-center justify-between">
            <h2 class="text-xl font-semibold text-foreground">Demandes d'expertise récentes</h2>
            <div class="flex space-x-2">
                <a href="?filter=all"
                   class="px-4 py-2 rounded-lg text-sm font-medium ${empty param.filter or param.filter eq 'all' ? 'bg-primary text-primary-foreground' : 'bg-muted text-muted-foreground'} hover:opacity-90 transition">
                    Toutes
                </a>
                <a href="?filter=EN_ATTENTE"
                   class="px-4 py-2 rounded-lg text-sm font-medium ${param.filter eq 'EN_ATTENTE' ? 'bg-primary text-primary-foreground' : 'bg-muted text-muted-foreground'} hover:opacity-90 transition">
                    En attente
                </a>
                <a href="?filter=TERMINEE"
                   class="px-4 py-2 rounded-lg text-sm font-medium ${param.filter eq 'TERMINEE' ? 'bg-primary text-primary-foreground' : 'bg-muted text-muted-foreground'} hover:opacity-90 transition">
                    Terminées
                </a>
            </div>
        </div>
    </div>

    <!-- Liste des demandes -->
    <div class="bg-white rounded-xl border border-border overflow-hidden">
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-border">
                <thead class="bg-muted">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">
                        Patient
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">
                        Date demande
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">
                        Créneau
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">
                        Priorité
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">
                        Statut
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">
                        Actions
                    </th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-border">
                <c:forEach items="${demandes}" var="demande">
                    <tr class="hover:bg-muted/50 transition">
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex items-center">
                                <div class="flex-shrink-0 h-10 w-10 bg-primary/10 rounded-full flex items-center justify-center">
                                    <svg class="h-6 w-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                    </svg>
                                </div>
                                <div class="ml-4">
                                    <div class="text-sm font-medium text-foreground">
                                        Patient #${demande.consultation.patient.id}
                                    </div>
                                    <div class="text-sm text-muted-foreground">
                                            ${demande.consultation.motif}
                                    </div>
                                </div>
                            </div>
                        </td>
                        <!-- Date demande column -->
<%--                        <td class="px-6 py-4 whitespace-nowrap text-sm text-muted-foreground">--%>
<%--                            <c:choose>--%>
<%--                                <c:when test="${not empty demande.dateDemande}">--%>
<%--                                    <%=--%>
<%--                                    ((org.medical.teleexpertisemedical.entity.DemandeExpertise)pageContext.getAttribute("demande"))--%>
<%--                                            .getDateDemande()--%>
<%--                                            .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))--%>
<%--                                    %>--%>
<%--                                </c:when>--%>
<%--                                <c:otherwise>-</c:otherwise>--%>
<%--                            </c:choose>--%>
<%--                        </td>--%>

<%--                        <!-- Créneau column -->--%>
<%--                        <td class="px-6 py-4 whitespace-nowrap text-sm text-muted-foreground">--%>
<%--                            <c:choose>--%>
<%--                                <c:when test="${not empty demande.creneau and not empty demande.creneau.dateHeure}">--%>
<%--                                    <%=--%>
<%--                                    ((DemandeExpertise)pageContext.("demande"))--%>
<%--                                            .getCreneau()--%>
<%--                                            .getDateHeure()--%>
<%--                                            .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))--%>
<%--                                    %>--%>
<%--                                </c:when>--%>
<%--                                <c:otherwise>-</c:otherwise>--%>
<%--                            </c:choose>--%>
<%--                        </td>--%>

                        <td class="px-6 py-4 whitespace-nowrap">
                            <c:choose>
                                <c:when test="${demande.priorite eq 'URGENTE'}">
                  <span class="badge-urgente px-3 py-1 inline-flex text-xs leading-5 font-medium rounded-full">
                    🔴 Urgente
                  </span>
                                </c:when>
                                <c:when test="${demande.priorite eq 'NORMALE'}">
                  <span class="badge-normale px-3 py-1 inline-flex text-xs leading-5 font-medium rounded-full">
                    🔵 Normale
                  </span>
                                </c:when>
                                <c:otherwise>
                  <span class="badge-non-urgente px-3 py-1 inline-flex text-xs leading-5 font-medium rounded-full">
                    ⚪ Non urgente
                  </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <c:choose>
                                <c:when test="${demande.statut eq 'EN_ATTENTE'}">
                  <span class="badge-en-attente px-3 py-1 inline-flex text-xs leading-5 font-medium rounded-full">
                    En attente
                  </span>
                                </c:when>
                                <c:otherwise>
                  <span class="badge-terminee px-3 py-1 inline-flex text-xs leading-5 font-medium rounded-full">
                    Terminée
                  </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                            <c:choose>
                                <c:when test="${demande.statut eq 'EN_ATTENTE'}">
                                    <a href="${pageContext.request.contextPath}/specialiste/repondre-expertise?demandeId=${demande.id}"
                                       class="text-primary hover:opacity-80 inline-flex items-center font-medium">
                                        <svg class="h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                        </svg>
                                        Répondre
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/specialiste/voir-expertise?demandeId=${demande.id}"
                                       class="text-muted-foreground hover:text-foreground inline-flex items-center">
                                        <svg class="h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                        </svg>
                                        Voir
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty demandes}">
                    <tr>
                        <td colspan="6" class="px-6 py-12 text-center text-muted-foreground">
                            <svg class="mx-auto h-12 w-12 text-muted-foreground/50" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"/>
                            </svg>
                            <p class="mt-2">Aucune demande d'expertise pour le moment</p>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>