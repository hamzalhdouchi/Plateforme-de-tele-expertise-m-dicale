<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
 <!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouveau Patient</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">
<div class="container mx-auto px-4 py-6 max-w-4xl">
    <!-- En-tête -->
    <header class="mb-8">
        <div class="flex justify-between items-center mb-4">
            <div>
                <h1 class="text-2xl font-bold text-gray-800">Enregistrement d'un Nouveau Patient</h1>
            </div>
            <a href="${pageContext.request.contextPath}/RecherchePatient"
               class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">
                ← Retour
            </a>
        </div>
    </header>

    <!-- Message d'erreur -->
    <c:if test="${not empty error}">
        <div class="mb-6 p-4 bg-red-100 text-red-700 rounded-lg">
                ${error}
        </div>
    </c:if>

    <c:if test="${not empty message}">
        <div class="mb-6 p-4 bg-green-100 text-green-700 rounded-lg">
                ${message}
        </div>
    </c:if>
    <%
        String csrfToken = (String) session.getAttribute("csrfToken");
    %>
    <!-- Formulaire -->
    <form action="${pageContext.request.contextPath}/NouveauPatient" method="post" class="space-y-8">

        <!-- Informations Personnelles -->
        <div class="bg-white rounded-lg shadow p-6">
            <h2 class="text-lg font-bold text-gray-800 mb-4 border-b pb-2">Informations Personnelles</h2>
            <input  type="hidden" name="csrfToken" value="<%= csrfToken%>">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label for="nom" class="block text-gray-700 font-medium mb-2">Nom *</label>
                    <input type="text" id="nom" name="nom" required
                           class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label for="prenom" class="block text-gray-700 font-medium mb-2">Prénom *</label>
                    <input type="text" id="prenom" name="prenom" required
                           class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label for="dateNaissance" class="block text-gray-700 font-medium mb-2">Date de naissance *</label>
                    <input type="date" id="dateNaissance" name="dateNaissance" required
                           class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label for="numeroSecuriteSociale" class="block text-gray-700 font-medium mb-2">N° Sécurité Sociale *</label>
                    <input type="text" id="numeroSecuriteSociale" name="numeroSecuriteSociale"
                            placeholder="1234567890123" required
                           class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label for="telephone" class="block text-gray-700 font-medium mb-2">Téléphone</label>
                    <input type="tel" id="telephone" name="telephone" placeholder="0612345678"
                           class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label for="adresse" class="block text-gray-700 font-medium mb-2">Adresse</label>
                    <input type="text" id="adresse" name="adresse" placeholder="123 Rue de la Santé"
                           class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
            </div>
        </div>

        <!-- Signes Vitaux -->
        <div class="bg-white rounded-lg shadow p-6">
            <h2 class="text-lg font-bold text-gray-800 mb-4 border-b pb-2">Signes Vitaux *</h2>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label for="temperature" class="block text-gray-700 font-medium mb-2">Température (°C) *</label>
                    <input type="number" id="temperature" name="temperature"
                           step="0.1" min="35" max="42" placeholder="37.0" required
                           class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label for="frequenceCardiaque" class="block text-gray-700 font-medium mb-2">Fréquence Cardiaque (bpm) *</label>
                    <input type="number" id="frequence" name="frequenceCardiaque"
                           min="40" max="200" placeholder="75" required
                           class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label for="tensionSystolique" class="block text-gray-700 font-medium mb-2">Tension Systolique (mmHg) *</label>
                    <input type="number" id="tensionSystolique" name="tensionSystolique"
                           min="70" max="250" placeholder="120" required
                           class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label for="tensionDiastolique" class="block text-gray-700 font-medium mb-2">Tension Diastolique (mmHg) *</label>
                    <input type="number" id="tensionDiastolique" name="tensionDiastolique"
                           min="40" max="150" placeholder="80" required
                           class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label for="frequenceRespiratoire" class="block text-gray-700 font-medium mb-2">Fréquence Respiratoire (rpm) *</label>
                    <input type="number" id="frequenceRespiratoire" name="frequenceRespiratoire"
                           min="10" max="40" placeholder="16" required
                           class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label for="saturationOxygene" class="block text-gray-700 font-medium mb-2">Saturation O₂ (%) *</label>
                    <input type="number" id="saturationOxygene" name="saturationOxygene"
                           step="1" min="70" max="100" placeholder="98.0" required
                           class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
            </div>
        </div>

        <!-- Actions -->
        <div class="flex justify-end space-x-4">
            <a href="${pageContext.request.contextPath}/RecherchePatient"
               class="bg-gray-500 text-white px-6 py-2 rounded hover:bg-gray-600">
                Annuler
            </a>
            <button type="submit"
                    class="bg-blue-500 text-white px-6 py-2 rounded hover:bg-blue-600">
                Enregistrer et Ajouter à la File
            </button>
        </div>
    </form>
</div>
</body>
</html>