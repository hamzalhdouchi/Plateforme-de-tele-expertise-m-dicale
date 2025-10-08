<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Patients</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">
<div class="container mx-auto px-4 py-6">
    <!-- En-tête simple -->
    <div class="flex justify-between items-center mb-6">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">Liste des Patients</h1>
            <p class="text-gray-600">
                <fmt:formatDate value="${dateAujourdhui}" pattern="dd/MM/yyyy"/>
            </p>
        </div>
        <a href="accueilDach.jsp"
           class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
            ← Retour
        </a>
    </div>

    <!-- Résumé -->
    <div class="bg-white rounded-lg shadow p-4 mb-6">
        <p class="text-gray-700">
            <span class="font-semibold">${patients.size()}</span> patient(s) aujourd'hui
        </p>
    </div>

    <c:choose>
        <c:when test="${empty patients}">
            <!-- État vide -->
            <div class="bg-white rounded-lg shadow p-8 text-center">
                <p class="text-gray-600 mb-4">Aucun patient enregistré aujourd'hui</p>
                <a href="${pageContext.request.contextPath}/search-patient"
                   class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
                    Enregistrer un patient
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Tableau des patients -->
            <div class="bg-white rounded-lg shadow overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-100">
                        <tr>
                            <th class="px-4 py-3 text-left text-sm font-medium text-gray-700">Patient</th>
                            <th class="px-4 py-3 text-left text-sm font-medium text-gray-700">Heure</th>
                            <th class="px-4 py-3 text-left text-sm font-medium text-gray-700">N° SS</th>
                            <th class="px-4 py-3 text-left text-sm font-medium text-gray-700">Temp.</th>
                            <th class="px-4 py-3 text-left text-sm font-medium text-gray-700">Tension</th>
                            <th class="px-4 py-3 text-left text-sm font-medium text-gray-700">FC</th>
                            <th class="px-4 py-3 text-left text-sm font-medium text-gray-700">O₂</th>
                            <th class="px-4 py-3 text-left text-sm font-medium text-gray-700">Statut</th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                        <c:forEach var="patient" items="${patients}">
                            <tr class="hover:bg-gray-50 ${patient.enFileAttente ? 'bg-yellow-50' : ''}">
                                <!-- Nom et prénom -->
                                <td class="px-4 py-3">
                                    <div class="text-sm font-medium text-gray-900">
                                            ${patient.prenom} ${patient.nom}
                                    </div>
                                </td>

                                <!-- Heure d'arrivée -->
                                <td class="px-4 py-3">
                                    <div class="text-sm text-gray-900">
                                        <fmt:formatDate value="${patient.heureArrivee}" pattern="HH:mm"/>
                                    </div>
                                </td>

                                <!-- Numéro de sécurité sociale -->
                                <td class="px-4 py-3">
                                    <div class="text-sm text-gray-900 font-mono">
                                            ${patient.numeroSecuriteSociale}
                                    </div>
                                </td>

                                <!-- Signes vitaux -->
                                <c:choose>
                                    <c:when test="${not empty patient.signesVitaux}">
                                        <td class="px-4 py-3">
                                            <div class="text-sm text-gray-900">
                                                    ${patient.signesVitaux.temperature}°C
                                            </div>
                                        </td>
                                        <td class="px-4 py-3">
                                            <div class="text-sm text-gray-900">
                                                    ${patient.signesVitaux.tensionArterielle}
                                            </div>
                                        </td>
                                        <td class="px-4 py-3">
                                            <div class="text-sm text-gray-900">
                                                    ${patient.signesVitaux.frequenceCardiaque} bpm
                                            </div>
                                        </td>
                                        <td class="px-4 py-3">
                                            <div class="text-sm text-gray-900">
                                                    ${patient.signesVitaux.saturationOxygene}%
                                            </div>
                                        </td>
                                    </c:when>
                                    <c:otherwise>
                                        <td colspan="4" class="px-4 py-3">
                                            <div class="text-sm text-gray-500 italic">
                                                Aucune donnée
                                            </div>
                                        </td>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Statut -->
                                <td class="px-4 py-3">
                                    <c:choose>
                                        <c:when test="${patient.enFileAttente}">
                                                    <span class="bg-yellow-100 text-yellow-800 text-xs px-2 py-1 rounded">
                                                        En attente
                                                    </span>
                                        </c:when>
                                        <c:otherwise>
                                                    <span class="bg-green-100 text-green-800 text-xs px-2 py-1 rounded">
                                                        Enregistré
                                                    </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>