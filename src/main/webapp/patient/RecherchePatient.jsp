<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recherche Patient</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">
<div class="container mx-auto px-4 py-6">
    <!-- En-tête -->
    <header class="mb-8">
        <div class="flex justify-between items-center mb-4">
            <div>
                <h1 class="text-2xl font-bold text-gray-800">Recherche de Patient</h1>
            </div>
            <a href="${pageContext.request.contextPath}/Home-Infirmier"
               class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">
                ← Retour
            </a>
        </div>
    </header>
    <%
        String csrfToken = (String) session.getAttribute("csrfToken");
    %>
    <!-- Section de recherche -->
    <div class="bg-white rounded-lg shadow p-6 mb-6">
        <form action="${pageContext.request.contextPath}/RecherchePatient" method="post">
            <input  type="hidden" name="csrfToken" value="<%= csrfToken%>">

            <div class="mb-4">
                <label for="searchTerm" class="block text-gray-700 font-medium mb-2">
                    Rechercher par nom, prénom ou numéro de sécurité sociale
                </label>
                <input type="text" id="searchTerm" name="searchTerm"
                       placeholder="Ex: Dupont, Jean, ou 1234567890123"
                       class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                       required>
            </div>
            <button type="submit"
                    class="bg-blue-500 text-white px-6 py-2 rounded hover:bg-blue-600">
                Rechercher
            </button>
        </form>

        <!-- Messages d'alerte -->
        <c:if test="${not empty error}">
            <div class="mt-4 p-3 bg-red-100 text-red-700 rounded">
                    ${error}
            </div>
        </c:if>

        <c:if test="${not empty message}">
            <div class="mt-4 p-3 bg-blue-100 text-blue-700 rounded">
                    ${message}
            </div>
        </c:if>
    </div>

    <!-- Résultats de recherche -->
    <c:if test="${not empty patients}">
        <div class="bg-white rounded-lg shadow mb-6">
            <div class="px-6 py-4 border-b border-gray-200">
                <h2 class="text-lg font-bold text-gray-800">Résultats de la recherche</h2>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full">
                    <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-sm font-medium text-gray-700">Nom</th>
                        <th class="px-6 py-3 text-left text-sm font-medium text-gray-700">Prénom</th>
                        <th class="px-6 py-3 text-left text-sm font-medium text-gray-700">Date de naissance</th>
                        <th class="px-6 py-3 text-left text-sm font-medium text-gray-700">N° Sécurité Sociale</th>
                        <th class="px-6 py-3 text-left text-sm font-medium text-gray-700">Action</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                    <c:forEach var="patient" items="${patients}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 text-sm text-gray-900">${patient.nom}</td>
                            <td class="px-6 py-4 text-sm text-gray-900">${patient.prenom}</td>
                            <td class="px-6 py-4 text-sm text-gray-900">${patient.dateDeNaissance}</td>
                            <td class="px-6 py-4 text-sm text-gray-900 font-mono">${patient.NSecuriteSociale}</td>
                            <td class="px-6 py-4">
                                <a href="${pageContext.request.contextPath}/update-vitals?patientId=${patient.id}"
                                   class="bg-green-500 text-white px-3 py-1 rounded text-sm hover:bg-green-600">
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
    <div class="bg-white rounded-lg shadow p-6 text-center">
        <p class="text-gray-600 mb-4">Patient non trouvé ?</p>
        <a href="${pageContext.request.contextPath}/NouveauPatient"
           class="bg-gray-500 text-white px-6 py-2 rounded hover:bg-gray-600">
            Créer un nouveau dossier patient
        </a>
    </div>
</div>
</body>
</html>