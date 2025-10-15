<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Médecin Généraliste - Système Médical</title>
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
        * { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-background">
<!-- Navbar --><c:if test="${not empty error}">
    <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg text-sm text-red-800">
            ${error}
    </div>
</c:if>
<nav class="bg-gradient-to-r from-primary to-primary shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="flex items-center">
                <h1 class="text-xl font-bold text-primary-foreground">Dashboard Médecin Généraliste</h1>
            </div>
            <div class="flex items-center space-x-4">
                    <span class="text-primary-foreground">
                        <svg class="inline h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                        Dr. ${sessionScope.loggedUser.nom}
                    </span>
                <a href="${pageContext.request.contextPath}/Logout"
                   class="bg-primary-foreground text-primary px-4 py-2 rounded-lg hover:bg-muted transition font-semibold">
                    Déconnexion
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <!-- Patients en attente -->
        <div class="bg-primary-foreground rounded-xl shadow-lg p-6">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-xl font-bold text-foreground flex items-center">
                    <svg class="h-6 w-6 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"/>
                    </svg>
                    Patients en attente
                </h2>
                <span class="bg-primary text-primary-foreground px-3 py-1 rounded-full text-sm font-medium">
                    ${fn:length(consultationsRecentes)}
                </span>
            </div>

            <c:choose>
                <c:when test="${not empty consultationsRecentes}">
                    <div class="space-y-4">
                        <c:forEach items="${consultationsRecentes}" var="consultation">
                            <div class="border border-border rounded-lg p-4 hover:shadow-md transition">
                                <div class="flex justify-between items-start">
                                    <div>
                                        <h3 class="font-semibold text-foreground">
                                                ${consultation.patient.nom} ${consultation.patient.prenom}
                                        </h3>
                                        <p class="text-sm text-muted-foreground">
                                                ${consultation.patient.dateDeNaissance} • ${consultation.patient.NSecuriteSociale}
                                        </p>
                                        <c:if test="${not empty consultation.motif}">
                                            <p class="text-sm text-primary mt-1">
                                                <span class="font-medium">Motif:</span> ${consultation.motif}
                                            </p>
                                        </c:if>
                                    </div>
                                    <!-- Version sobre -->
                                    <div class="flex items-center space-x-3">
                                        <c:choose>
                                            <c:when test="${consultation.patient.status == 'TERMINE'}">
            <span class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium bg-green-100 text-green-800 border border-green-200">
                TERMINÉ
            </span>
                                                <a href="${pageContext.request.contextPath}/historique-consultations?patientId=${consultation.patient.id}"
                                                   class="inline-flex items-center gap-2 px-4 py-2 rounded-md text-sm font-medium bg-blue-100 text-blue-700
                      hover:bg-blue-200 transition-colors duration-150">
                                                    Détails
                                                </a>
                                            </c:when>
                                            <c:otherwise>
            <span class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800 border border-yellow-200">
                EN ATTENTE
            </span>
                                                <a href="${pageContext.request.contextPath}/medecin/creer-consultation?patientId=${consultation.patient.id}"
                                                   class="inline-flex items-center gap-2 px-4 py-2 rounded-md text-sm font-medium bg-green-100 text-green-700
                      hover:bg-green-200 transition-colors duration-150">
                                                    Consulter
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <c:if test="${not empty consultation.patient.signesVitaux}">
                                    <div class="mt-3 pt-3 border-t border-border">
                                        <div class="grid grid-cols-2 gap-2 text-xs">
                                            <c:if test="${not empty consultation.patient.signesVitaux.tensiondiastolique}">
                                                <div class="flex items-center">
                                                    <span class="text-muted-foreground mr-1">TA:</span>
                                                    <span class="font-medium">${consultation.patient.signesVitaux.tensiondiastolique}</span>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty consultation.patient.signesVitaux.temperature}">
                                                <div class="flex items-center">
                                                    <span class="text-muted-foreground mr-1">Temp:</span>
                                                    <span class="font-medium">${consultation.patient.signesVitaux.temperature}°C</span>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty consultation.patient.signesVitaux.tensionsystolique}">
                                                <div class="flex items-center">
                                                    <span class="text-muted-foreground mr-1">TS:</span>
                                                    <span class="font-medium">${consultation.patient.signesVitaux.tensionsystolique}</span>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty consultation.patient.signesVitaux.frequencerespiratoire}">
                                                <div class="flex items-center">
                                                    <span class="text-muted-foreground mr-1">FR:</span>
                                                    <span class="font-medium">${consultation.patient.signesVitaux.frequencerespiratoire}/min</span>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty consultation.patient.signesVitaux.saturation}">
                                                <div class="flex items-center">
                                                    <span class="text-muted-foreground mr-1">O²:</span>
                                                    <span class="font-medium">${consultation.patient.signesVitaux.saturation}%</span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>

                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-8 text-muted-foreground">
                        <svg class="mx-auto h-12 w-12 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                        </svg>
                        <p>Aucun patient en attente de consultation</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Consultations récentes -->
        <div class="bg-primary-foreground rounded-xl shadow-lg p-6">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-xl font-bold text-foreground flex items-center">
                    <svg class="h-6 w-6 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                    </svg>
                    Consultations récentes
                </h2>
                <a href="${pageContext.request.contextPath}/Toutes_Consultations"
                   class="text-primary hover:text-primary/80 text-sm font-medium">
                    Voir tout
                </a>
            </div>

            <c:choose>
                <c:when test="${not empty consultationsRecentes}">
                    <div class="space-y-4">
                        <c:forEach items="${consultationsRecentes}" var="consultation">
                            <div class="border border-border rounded-lg p-4">
                                <div class="flex justify-between items-start mb-2">
                                    <div>
                                        <h3 class="font-semibold text-foreground">${consultation.patient.nom}</h3>
                                        <p class="text-sm text-muted-foreground">${consultation.dateConsultation}</p>
                                    </div>
                                    <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium
                                            ${consultation.statut == 'TERMINEE' ? 'bg-green-100 text-green-800' :
                                              consultation.statut == 'EN_COURS' ? 'bg-blue-100 text-blue-800' :
                                              'bg-orange-100 text-orange-800'}">
                                            ${consultation.statut}
                                    </span>
                                </div>
<%--                                <c:if test="${not empty consultation.diagnostic}">--%>
<%--                                    <p class="text-sm text-foreground line-clamp-2">${consultation.diagnostic}</p>--%>
<%--                                </c:if>--%>
<%--                                <div class="flex justify-between items-center mt-3">--%>
<%--                                    <c:if test="${consultation.actesTechniques > 0}">--%>
<%--                                            <span class="text-xs text-muted-foreground">--%>
<%--                                                ${consultation.actesTechniques} acte(s) technique(s)--%>
<%--                                            </span>--%>
<%--                                    </c:if>--%>

                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-8 text-muted-foreground">
                        <svg class="mx-auto h-12 w-12 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                        </svg>
                        <p>Aucune consultation récente</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Actions rapides -->
    <div class="mt-8 bg-primary-foreground rounded-xl shadow-lg p-6">
        <h2 class="text-xl font-bold text-foreground mb-6 flex items-center">
            <svg class="h-6 w-6 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
            </svg>
            Actions rapides
        </h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <a href="${pageContext.request.contextPath}/medecin/patients-attente"
               class="flex items-center p-4 border border-border rounded-lg hover:border-primary hover:shadow-md transition">
                <div class="bg-primary/10 p-3 rounded-full mr-4">
                    <svg class="h-6 w-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"/>
                    </svg>
                </div>
                <div>
                    <h3 class="font-semibold text-foreground">Voir tous les patients</h3>
                    <p class="text-sm text-muted-foreground">Liste complète des patients en attente</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/medecin/historique-consultations"
               class="flex items-center p-4 border border-border rounded-lg hover:border-primary hover:shadow-md transition">
                <div class="bg-primary/10 p-3 rounded-full mr-4">
                    <svg class="h-6 w-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                    </svg>
                </div>
                <div>
                    <h3 class="font-semibold text-foreground">Historique</h3>
                    <p class="text-sm text-muted-foreground">Consultations passées</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/medecin/rapports"
               class="flex items-center p-4 border border-border rounded-lg hover:border-primary hover:shadow-md transition">
                <div class="bg-primary/10 p-3 rounded-full mr-4">
                    <svg class="h-6 w-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                    </svg>
                </div>
                <div>
                    <h3 class="font-semibold text-foreground">Rapports</h3>
                    <p class="text-sm text-muted-foreground">Statistiques et analyses</p>
                </div>
            </a>
        </div>
    </div>
</div>
</body>
</html>