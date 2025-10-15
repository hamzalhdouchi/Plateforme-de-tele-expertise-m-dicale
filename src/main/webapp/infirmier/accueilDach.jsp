<%@ page import="tele_expertise.entity.Utilisateur" %>
<%@ page import="tele_expertise.enums.RoleUtilisateur" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%
    if (session == null || session.getAttribute("loggedUser") == null || session.getAttribute("role") != RoleUtilisateur.INFIRMIER) {
        request.setAttribute("error", "Session expired");
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Infirmier - Digital Clinic</title>
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
        .badge-waiting {
            background-color: #FEF3C7;
            color: #92400E;
        }
        .badge-done {
            background-color: #D1FAE5;
            color: #065F46;
        }
    </style>
</head>
<body class="bg-background text-foreground font-sans antialiased">

<div class="min-h-screen">
    <div class="container mx-auto px-4 py-6 max-w-7xl">
        <!-- Header -->
        <header class="mb-8">
<c:if test="${not empty error}">
    <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg text-sm text-red-800">
            ${error}
    </div>
</c:if>
            <c:if test="${not empty message}">
                <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg text-sm text-green-800">
                        ${message}
                </div>
            </c:if>
            <div class="flex justify-between items-center mb-6">
                <div class="flex items-center space-x-3">
                    <svg class="w-8 h-8 text-primary" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M2 17L12 22L22 17" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M2 12L12 17L22 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    <div>
                        <h1 class="text-2xl font-bold">Digital Clinic</h1>
                        <p class="text-sm text-muted-foreground">Module Infirmier - Accueil Patient</p>
                    </div>
                </div>

                <div class="flex items-center space-x-4">
                    <div class="flex items-center space-x-3 bg-white rounded-lg border border-border px-4 py-2">
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
                        <div class="text-sm">
                            <c:choose>
                                <c:when test="${not empty sessionScope.loggedUser.nom and not empty sessionScope.loggedUser.prenom}">
                                    <div class="font-medium">${sessionScope.loggedUser.prenom} ${sessionScope.loggedUser.nom}</div>
                                    <div class="text-muted-foreground">Infirmier</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="font-medium">Utilisateur</div>
                                    <div class="text-muted-foreground">Connecté</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            </nav>
        </header>

        <!-- Fonctionnalités principales -->
        <div class="mb-8">
            <h2 class="text-xl font-bold mb-6">Fonctionnalités principales</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="bg-white rounded-lg border border-border p-6 hover:shadow-md transition-shadow">
                    <div class="h-12 w-12 bg-primary/10 rounded-lg flex items-center justify-center mb-4">
                        <svg class="w-6 h-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/>
                        </svg>
                    </div>
                    <h3 class="font-bold text-lg mb-2">Nouveau Patient</h3>
                    <p class="text-muted-foreground text-sm mb-4">Enregistrez un nouveau patient dans le système avec ses informations personnelles et signes vitaux.</p>
                    <a href="${pageContext.request.contextPath}/NouveauPatient"
                       class="text-primary font-medium text-sm hover:underline flex items-center space-x-1">
                        <span>Accéder</span>
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                        </svg>
                    </a>
                </div>
                <div class="bg-white rounded-lg border border-border p-6 hover:shadow-md transition-shadow">
                    <div class="h-12 w-12 bg-primary/10 rounded-lg flex items-center justify-center mb-4">
                        <svg class="w-6 h-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                        </svg>
                    </div>
                    <h3 class="font-bold text-lg mb-2">Recherche Patient</h3>
                    <p class="text-muted-foreground text-sm mb-4">Trouvez rapidement un patient par nom, prénom ou numéro de sécurité sociale.</p>
                    <a href="${pageContext.request.contextPath}/RecherchePatient"
                       class="text-primary font-medium text-sm hover:underline flex items-center space-x-1">
                        <span>Accéder</span>
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                        </svg>
                    </a>
                </div>
            </div>
        </div>

        <!-- Patients récents -->
        <div class="bg-white rounded-lg border border-border">
            <div class="px-6 py-4 border-b border-border flex justify-between items-center">
                <h2 class="text-xl font-bold">Patients</h2>
            </div>

            <!-- Debugging Output -->
            <c:if test="${empty ps}">
                <div class="px-6 py-4 text-red-600">
                    Aucune donnée de patient disponible. Vérifiez que la liste patient est correctement définie.
                </div>
            </c:if>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Patient
                        </th>
                        <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Informations
                        </th>
                        <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Heure d'arrivée
                        </th>
                        <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Signes vitaux
                        </th>
                        <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Statut
                        </th>
                        <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Actions
                        </th>
                    </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                    <c:forEach items="${ps}" var="patient">
                        <tr class="transition hover:bg-gray-50">
                            <!-- Colonne Patient -->
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0 h-12 w-12 bg-primary/10 rounded-full flex items-center justify-center">
                                <span class="text-primary font-bold text-lg">
                                    <c:choose>
                                        <c:when test="${not empty patient.prenom and not empty patient.nom}">
                                            ${fn:substring(patient.prenom, 0, 1)}${fn:substring(patient.nom, 0, 1)}
                                        </c:when>
                                        <c:otherwise>
                                            ?
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                                    </div>
                                    <div class="ml-4">
                                        <div class="text-sm font-bold text-gray-900">
                                                ${patient.nom} ${patient.prenom}
                                        </div>
                                        <div class="text-xs text-gray-500">
                                            Né(e) le ${patient.dateDeNaissance}
                                        </div>
                                    </div>
                                </div>
                            </td>

                            <!-- Colonne Informations -->
                            <td class="px-6 py-4">
                                <div class="text-sm">
                                    <div class="text-gray-900 font-medium">
                                        SS: ${patient.NSecuriteSociale}
                                    </div>
                                    <c:if test="${not empty patient.telephone}">
                                        <div class="text-gray-500 flex items-center mt-1">
                                            <svg class="h-4 w-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                      d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                                            </svg>
                                                ${patient.telephone}
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty patient.adresse}">
                                        <div class="text-gray-500 text-xs mt-1">
                                            Adresse: ${patient.adresse}
                                        </div>
                                    </c:if>
                                </div>
                            </td>

                            <!-- Colonne Heure d'arrivée -->
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center text-sm text-gray-900">
                                    <svg class="h-5 w-5 text-gray-400 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                    <c:if test="${not empty patient.dateCreation}">
                                        ${fn:substring(patient.dateCreation.toLocalTime().toString(), 0, 5)}
                                    </c:if>
                                </div>
                            </td>

                            <!-- Colonne Signes vitaux -->
                            <td class="px-6 py-4 text-sm">
                                <c:if test="${not empty patient.signesVitaux}">
                                    <div class="grid grid-cols-2 gap-2 text-xs">
                                        <c:if test="${not empty patient.signesVitaux.tensiondiastolique}">
                                            <div class="bg-blue-50 px-2 py-1 rounded border border-blue-100">
                                                <span class="text-blue-700 font-semibold">TA:</span>
                                                <span class="text-gray-900">${patient.signesVitaux.tensiondiastolique}</span>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty patient.signesVitaux.tensionsystolique}">
                                            <div class="bg-blue-50 px-2 py-1 rounded border border-blue-100">
                                                <span class="text-blue-700 font-semibold">TS:</span>
                                                <span class="text-gray-900">${patient.signesVitaux.tensionsystolique}</span>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty patient.signesVitaux.temperature}">
                                            <div class="bg-orange-50 px-2 py-1 rounded border border-orange-100">
                                                <span class="text-orange-700 font-semibold">T°:</span>
                                                <span class="text-gray-900">${patient.signesVitaux.temperature}°C</span>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty patient.signesVitaux.frequencerespiratoire}">
                                            <div class="bg-green-50 px-2 py-1 rounded border border-green-100">
                                                <span class="text-green-700 font-semibold">FR:</span>
                                                <span class="text-gray-900">${patient.signesVitaux.frequencerespiratoire}/min</span>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty patient.signesVitaux.saturation}">
                                            <div class="bg-purple-50 px-2 py-1 rounded border border-purple-100">
                                                <span class="text-purple-700 font-semibold">O²:</span>
                                                <span class="text-gray-900">${patient.signesVitaux.saturation}%</span>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:if>
                                <c:if test="${empty patient.signesVitaux}">
                                    <span class="text-gray-400 text-xs italic">Aucun signe vital</span>
                                </c:if>
                            </td>

                            <!-- Colonne Statut -->
                            <td class="px-6 py-4 whitespace-nowrap">
                                <c:choose>
                                    <c:when test="${patient.status == 'EN_ATTENTE'}">
                                <span class="badge-waiting px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full items-center">
                                    <svg class="h-4 w-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"/>
                                    </svg>
                                    En attente
                                </span>
                                    </c:when>
                                    <c:otherwise>
                                <span class="badge-done px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full items-center">
                                    <svg class="h-4 w-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                    </svg>
                                    Consulté
                                </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                <c:if test="${patient.status == 'EN_ATTENTE'}">

                                <a href="${pageContext.request.contextPath}/infirmier/creer-consultation?patientId=${patient.id}"
                                   class="inline-flex items-center px-3 py-2 bg-primary text-primary-foreground rounded-lg hover:bg-primary/90 transition-colors text-sm font-medium">
                                    <svg class="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M9 12h.01M15 12h.01"/>
                                    </svg>
                                    Nouvelle Consultation
                                </a>
                                </c:if>
                            </td>

                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pied de page -->
        <footer class="mt-8 pt-6 border-t border-border text-center text-muted-foreground text-sm">
            <p>© 2024 Digital Clinic - Système de gestion des patients</p>
            <p class="mt-1">Module Infirmier - Version 2.1.0</p>
        </footer>
    </div>
</div>
</body>
</html>