<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recherche Patient - Digital Clinic</title>
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
    <div class="container mx-auto px-4 py-6 max-w-6xl">
        <!-- En-tête -->
        <header class="mb-8">
            <div class="flex justify-between items-center mb-4">
                <div class="flex items-center space-x-3">
                    <svg class="w-8 h-8 text-primary" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M2 17L12 22L22 17" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M2 12L12 17L22 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    <div>
                        <h1 class="text-2xl font-bold">Digital Clinic</h1>
                        <p class="text-sm text-muted-foreground">Recherche de Patient</p>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/Home-Infirmier"
                   class="bg-primary text-primary-foreground px-4 py-2 rounded-lg font-medium hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all">
                    ← Retour
                </a>
            </div>
        </header>

        <%
            String csrfToken = (String) session.getAttribute("csrfToken");
        %>

        <!-- Section de recherche -->
        <div class="bg-white rounded-lg shadow-sm border border-border p-6 mb-6">
            <form action="${pageContext.request.contextPath}/RecherchePatient" method="post">
                <input type="hidden" name="csrfToken" value="<%= csrfToken%>">

                <div class="mb-4">
                    <label for="searchTerm" class="block text-sm font-medium mb-2">
                        Rechercher par nom, prénom ou numéro de sécurité sociale
                    </label>
                    <input
                            type="text"
                            id="searchTerm"
                            name="searchTerm"
                            placeholder="Ex: Dupont, Jean, ou 1234567890123"
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            required
                    >
                </div>
                <button
                        type="submit"
                        class="bg-primary text-primary-foreground px-6 py-3 rounded-lg font-medium hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all"
                >
                    Rechercher
                </button>
            </form>

            <!-- Messages d'alerte -->
            <c:if test="${not empty error}">
                <div class="mt-4 p-4 bg-red-50 border border-red-200 rounded-lg text-sm text-red-800">
                        ${error}
                </div>
            </c:if>

            <c:if test="${not empty message}">
                <div class="mt-4 p-4 bg-blue-50 border border-blue-200 rounded-lg text-sm text-blue-800">
                        ${message}
                </div>
            </c:if>
        </div>

        <!-- Résultats de recherche -->
        <c:if test="${not empty patients}">
            <div class="bg-white rounded-lg shadow-sm border border-border mb-6">
                <div class="px-6 py-4 border-b border-border">
                    <h2 class="text-lg font-bold">Résultats de la recherche</h2>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-muted">
                        <tr>
                            <th class="px-6 py-3 text-left text-sm font-medium">Nom</th>
                            <th class="px-6 py-3 text-left text-sm font-medium">Prénom</th>
                            <th class="px-6 py-3 text-left text-sm font-medium">Date de naissance</th>
                            <th class="px-6 py-3 text-left text-sm font-medium">N° Sécurité Sociale</th>
                            <th class="px-6 py-3 text-left text-sm font-medium">Action</th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-border">
                        <c:forEach var="patient" items="${patients}">
                            <tr class="hover:bg-muted/50 transition-colors">
                                <td class="px-6 py-4 text-sm">${patient.nom}</td>
                                <td class="px-6 py-4 text-sm">${patient.prenom}</td>
                                <td class="px-6 py-4 text-sm">${patient.dateDeNaissance}</td>
                                <td class="px-6 py-4 text-sm font-mono">${patient.NSecuriteSociale}</td>
                                <td class="px-6 py-4">
                                    <a href="${pageContext.request.contextPath}/update-vitals?patientId=${patient.id}"
                                       class="bg-primary text-primary-foreground px-4 py-2 rounded-lg text-sm font-medium hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all">
                                        Sélectionner
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <!-- Section création nouveau patient -->
        <div class="bg-white rounded-lg shadow-sm border border-border p-6 text-center">
            <p class="text-muted-foreground mb-4">Patient non trouvé ?</p>
            <a href="${pageContext.request.contextPath}/NouveauPatient"
               class="bg-secondary text-primary-foreground px-6 py-3 rounded-lg font-medium hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-secondary focus:ring-offset-2 transition-all">
                Créer un nouveau dossier patient
            </a>
        </div>
    </div>
</div>
</body>
</html>