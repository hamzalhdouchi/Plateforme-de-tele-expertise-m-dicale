<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
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
</head>
<body class="bg-background text-foreground font-sans antialiased">
<div class="min-h-screen">
    <div class="container mx-auto px-4 py-6 max-w-7xl">
        <!-- Header -->
        <header class="mb-8">
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
                        <div class="h-8 w-8 rounded-full bg-primary flex items-center justify-center text-primary-foreground text-sm font-bold">
                            <c:choose>
                                <c:when test="${not empty sessionScope.loggedUser.prenom}">
                                    ${sessionScope.loggedUser.prenom.charAt(0)}
                                </c:when>
                                <c:otherwise>
                                    ID
                                </c:otherwise>
                            </c:choose>
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

            <!-- Navigation principale -->
            <nav class="flex space-x-4">
                <a href="${pageContext.request.contextPath}/RecherchePatient"
                   class="bg-primary text-primary-foreground px-6 py-3 rounded-lg font-medium hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all flex items-center space-x-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                    </svg>
                    <span>Rechercher / Enregistrer Patient</span>
                </a>
                <a href="listPatients.jsp"
                   class="bg-white text-primary border border-primary px-6 py-3 rounded-lg font-medium hover:bg-primary hover:text-primary-foreground focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all flex items-center space-x-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                    </svg>
                    <span>Liste des Patients</span>
                </a>
            </nav>
        </header>



        <!-- Fonctionnalités principales -->
        <div class="mb-8">
            <h2 class="text-xl font-bold mb-6">Fonctionnalités principales</h2>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
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

                <div class="bg-white rounded-lg border border-border p-6 hover:shadow-md transition-shadow">
                    <div class="h-12 w-12 bg-primary/10 rounded-lg flex items-center justify-center mb-4">
                        <svg class="w-6 h-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                        </svg>
                    </div>
                    <h3 class="font-bold text-lg mb-2">Dossiers Médicaux</h3>
                    <p class="text-muted-foreground text-sm mb-4">Gérez et consultez les dossiers médicaux complets des patients.</p>
                    <a href="#" class="text-primary font-medium text-sm hover:underline flex items-center space-x-1">
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
                <h2 class="text-xl font-bold">Patients récents</h2>
                <a href="#" class="text-primary text-sm font-medium hover:underline">Voir tout</a>
            </div>

            <div class="overflow-x-auto">
                <table class="min-w-full">
                    <thead class="bg-muted">
                    <tr>
                        <th class="px-6 py-3 text-left text-sm font-medium">Patient</th>
                        <th class="px-6 py-3 text-left text-sm font-medium">Heure d'arrivée</th>
                        <th class="px-6 py-3 text-left text-sm font-medium">Statut</th>
                        <th class="px-6 py-3 text-left text-sm font-medium">Priorité</th>
                        <th class="px-6 py-3 text-left text-sm font-medium">Actions</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-border">
                    <c:forEach var="patient" items="${ps}" varStatus="status">
                        <tr class="hover:bg-muted/50 transition-colors">
                            <td class="px-6 py-4">
                                <div class="flex items-center space-x-3">
                                    <div class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 font-medium">
                                            ${patient.initiales}
                                    </div>
                                    <div>
                                        <div class="font-medium">${patient.prenom} ${patient.nom}</div>
                                        <div class="text-sm text-muted-foreground">ID: ${patient.id} • ${patient.age} ans</div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4">
                                <div class="text-sm font-medium">
                                    <c:choose>
                                        <c:when test="${status.index == 0}">08:45</c:when>
                                        <c:when test="${status.index == 1}">09:20</c:when>
                                        <c:when test="${status.index == 2}">10:05</c:when>
                                        <c:otherwise>--:--</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="text-sm text-muted-foreground">Aujourd'hui</div>
                            </td>
                            <td class="px-6 py-4">
                            <span class="
                                <c:choose>
                                    <c:when test="${status.index == 0}">bg-green-100 text-green-800</c:when>
                                    <c:when test="${status.index == 1}">bg-yellow-100 text-yellow-800</c:when>
                                    <c:when test="${status.index == 2}">bg-red-100 text-red-800</c:when>
                                    <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                </c:choose>
                                text-xs px-2 py-1 rounded-full font-medium">
                                <c:choose>
                                    <c:when test="${status.index == 0}">En attente</c:when>
                                    <c:when test="${status.index == 1}">En cours</c:when>
                                    <c:when test="${status.index == 2}">Urgent</c:when>
                                    <c:otherwise>Inconnu</c:otherwise>
                                </c:choose>
                            </span>
                            </td>
                            <td class="px-6 py-4">
                            <span class="
                                <c:choose>
                                    <c:when test="${status.index == 0}">bg-gray-100 text-gray-800</c:when>
                                    <c:when test="${status.index == 1}">bg-orange-100 text-orange-800</c:when>
                                    <c:when test="${status.index == 2}">bg-red-100 text-red-800</c:when>
                                    <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                </c:choose>
                                text-xs px-2 py-1 rounded-full font-medium">
                                <c:choose>
                                    <c:when test="${status.index == 0}">Normale</c:when>
                                    <c:when test="${status.index == 1}">Élevée</c:when>
                                    <c:when test="${status.index == 2}">Critique</c:when>
                                    <c:otherwise>Normale</c:otherwise>
                                </c:choose>
                            </span>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex space-x-2">
                                    <a href="voirPatient?id=${patient.id}" class="text-primary hover:text-primary/80 font-medium text-sm">
                                        Voir
                                    </a>
                                    <a href="signesVitaux?id=${patient.id}" class="text-primary hover:text-primary/80 font-medium text-sm">
                                        Signes vitaux
                                    </a>
                                </div>
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