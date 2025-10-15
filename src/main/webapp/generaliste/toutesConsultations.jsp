<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Consultations</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50 min-h-screen">
<!-- Navigation -->
<nav class="bg-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4">
        <div class="flex justify-between items-center py-4">
            <div class="flex items-center space-x-3">
                <i class="fas fa-stethoscope text-2xl text-blue-600"></i>
                <h1 class="text-xl font-bold text-gray-800">MediCare Dashboard</h1>
            </div>
            <div class="flex items-center space-x-4">
                <span class="text-gray-600">Dr. ${not empty medecinNom ? medecinNom : 'Médecin'}</span>
                <div class="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center text-white font-semibold">
                    ${not empty medecinNom ? medecinNom.charAt(0) : 'M'}
                </div>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 py-8">
    <!-- En-tête avec statistiques -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-800 mb-2">Dashboard des Consultations</h1>
        <p class="text-gray-600">Gestion et suivi des consultations médicales</p>

        <!-- Cartes statistiques -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mt-6">
            <div class="bg-white rounded-xl shadow-md p-6 border-l-4 border-blue-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Total Consultations</p>
                        <p class="text-2xl font-bold text-gray-800">${not empty totalConsultations ? totalConsultations : 0}</p>
                    </div>
                    <div class="p-3 bg-blue-100 rounded-lg">
                        <i class="fas fa-calendar-check text-blue-600 text-xl"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md p-6 border-l-4 border-green-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Terminées</p>
                        <p class="text-2xl font-bold text-gray-800">${not empty consultationsTerminees ? consultationsTerminees : 0}</p>
                    </div>
                    <div class="p-3 bg-green-100 rounded-lg">
                        <i class="fas fa-check-circle text-green-600 text-xl"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md p-6 border-l-4 border-yellow-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">En Cours</p>
                        <p class="text-2xl font-bold text-gray-800">${not empty consultationsEnCours ? consultationsEnCours : 0}</p>
                    </div>
                    <div class="p-3 bg-yellow-100 rounded-lg">
                        <i class="fas fa-clock text-yellow-600 text-xl"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md p-6 border-l-4 border-purple-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Aujourd'hui</p>
                        <p class="text-2xl font-bold text-gray-800">${not empty consultationsAujourdhui ? consultationsAujourdhui : 0}</p>
                    </div>
                    <div class="p-3 bg-purple-100 rounded-lg">
                        <i class="fas fa-calendar-day text-purple-600 text-xl"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filtres et recherche -->
    <div class="bg-white rounded-xl shadow-md p-6 mb-6">
        <form id="filterForm" method="get" action="${pageContext.request.contextPath}/dashboard">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div class="flex flex-col md:flex-row md:items-center space-y-4 md:space-y-0 md:space-x-4">
                    <!-- Recherche -->
                    <div class="relative">
                        <input type="text" name="search" placeholder="Rechercher un patient..."
                               value="${param.search}"
                               class="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 w-full md:w-64">
                        <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                    </div>
                </div>


            </div>
        </form>
    </div>

    <!-- Tableau des consultations -->
    <div class="bg-white rounded-xl shadow-md overflow-hidden">
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Patient
                    </th>
                    <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Motif
                    </th>
                    <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Statut
                    </th>
                    <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Coût Total
                    </th>
                    <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Actions
                    </th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <c:choose>
                    <c:when test="${not empty consultations}">
                        <c:forEach var="consultation" items="${consultations}">
                            <tr class="hover:bg-gray-50 transition duration-150">
                                <!-- Patient -->
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10 bg-blue-100 rounded-full flex items-center justify-center">
                                            <i class="fas fa-user text-blue-600"></i>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900">
                                                <c:choose>
                                                    <c:when test="${not empty consultation.patient}">
                                                        ${consultation.patient.nom} ${consultation.patient.prenom}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Patient inconnu
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="text-sm text-gray-500">
                                                <c:if test="${not empty consultation.patient}">
                                                    ${consultation.patient.NSecuriteSociale}
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </td>

                                <!-- Motif -->
                                <td class="px-6 py-4">
                                    <div class="text-sm text-gray-900 max-w-xs truncate" title="${consultation.motif}">
                                            ${not empty consultation.motif ? consultation.motif : 'Non spécifié'}
                                    </div>
                                </td>

                                <!-- Statut -->
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium
                                        <c:choose>
                                            <c:when test="${consultation.statut == 'EN_COURS'}">
                                                bg-yellow-100 text-yellow-800
                                            </c:when>
                                            <c:when test="${consultation.statut == 'TERMINEE'}">
                                                bg-green-100 text-green-800
                                            </c:when>
                                            <c:otherwise>
                                                bg-yellow-100 text-yellow-600
                                            </c:otherwise>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${consultation.statut == 'EN_COURS'}">
                                                <i class="fas fa-clock mr-1"></i> En cours
                                            </c:when>
                                            <c:when test="${consultation.statut == 'TERMINEE'}">
                                                <i class="fas fa-check mr-1"></i> Terminée
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-clock mr-1"></i>${consultation.statut}
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>

                                <!-- Coût -->
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    <c:choose>
                                        <c:when test="${not empty consultation.coutTotal}">
                                            <fmt:formatNumber value="${consultation.coutTotal}" type="currency" currencyCode="EUR" />
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- Actions -->
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                    <div class="flex items-center space-x-3">
                                        <!-- Voir Détails -->
                                        <c:if test="${not empty consultation.patient && not empty consultation.patient.id}">
                                            <a href="${pageContext.request.contextPath}/historique-consultations?patientId=${consultation.patient.id}"
                                               class="text-blue-600 hover:text-blue-900 transition duration-150"
                                               title="Voir historique patient">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </c:if>

                                        <!-- Continuer Consultation -->
                                        <c:if test="${consultation.statut == 'EN_COURS' && not empty consultation.patient}">
                                            <a href="${pageContext.request.contextPath}/medecin/creer-consultation?patientId=${consultation.patient.id}"
                                               class="text-green-600 hover:text-green-900 transition duration-150"
                                               title="Continuer consultation">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" class="px-6 py-4 text-center text-gray-500">Aucune consultation trouvée</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <c:if test="${not empty consultations}">
            <div class="bg-white px-6 py-4 border-t border-gray-200">
                <div class="flex items-center justify-between">
                    <div class="text-sm text-gray-700">
                        Affichage de <span class="font-medium">${not empty debut ? debut : 0}</span>
                        à <span class="font-medium">${not empty fin ? fin : 0}</span> sur
                        <span class="font-medium">${not empty totalConsultations ? totalConsultations : 0}</span> consultations
                    </div>
                    <div class="flex space-x-2">
                        <c:if test="${not empty pagePrecedente}">
                            <a href="?page=${pagePrecedente}${not empty param.search ? '&search=' += param.search : ''}${not empty param.statut ? '&statut=' += param.statut : ''}${not empty param.date ? '&date=' += param.date : ''}"
                               class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50">
                                Précédent
                            </a>
                        </c:if>
                        <c:if test="${not empty pageSuivante}">
                            <a href="?page=${pageSuivante}${not empty param.search ? '&search=' += param.search : ''}${not empty param.statut ? '&statut=' += param.statut : ''}${not empty param.date ? '&date=' += param.date : ''}"
                               class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50">
                                Suivant
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Filtrage en temps réel pour la recherche
        const searchInput = document.querySelector('input[name="search"]');
        const tableRows = document.querySelectorAll('tbody tr');

        if (searchInput) {
            searchInput.addEventListener('input', function(e) {
                const searchTerm = e.target.value.toLowerCase();

                tableRows.forEach(row => {
                    if (row.cells.length > 0) {
                        const patientName = row.cells[0].textContent.toLowerCase();
                        if (patientName.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    }
                });
            });
        }

        // Reset des filtres
        const resetFilters = document.getElementById('resetFilters');
        if (resetFilters) {
            resetFilters.addEventListener('click', function() {
                document.querySelector('input[name="search"]').value = '';
                document.querySelector('select[name="statut"]').value = '';
                document.querySelector('input[name="date"]').value = '';
                document.getElementById('filterForm').submit();
            });
        }
    });
</script>
</body>
</html>