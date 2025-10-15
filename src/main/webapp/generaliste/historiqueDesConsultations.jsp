<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails de la Consultation</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50 min-h-screen">
<div class="container mx-auto px-4 py-8">
    <div class="max-w-4xl mx-auto">
        <!-- En-tête -->
        <div class="mb-8">
            <a href="historique-consultations" class="inline-flex items-center text-blue-600 hover:text-blue-800 mb-4">
                <i class="fas fa-arrow-left mr-2"></i> Retour à l'historique
            </a>
            <h1 class="text-3xl font-bold text-gray-800 mb-2">
                <i class="fas fa-file-medical mr-3 text-blue-600"></i>
                Détails de la Consultation
            </h1>
            <p class="text-gray-600">
                <c:choose>
                    <c:when test="${not empty dateConsultation}">
                        <fmt:formatDate value="${dateConsultation}" pattern="dd/MM/yyyy 'à' HH:mm" />
                    </c:when>
                    <c:otherwise>
                        Date non disponible
                    </c:otherwise>
                </c:choose>
            </p>
        </div>

        <div class="bg-white rounded-lg shadow-md overflow-hidden">
            <div class="p-6 space-y-6">
                <!-- Informations Patient -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
                            <i class="fas fa-user-injured mr-2 text-blue-600"></i>Informations Patient
                        </h2>
                        <div class="space-y-3">
                            <div>
                                <span class="font-medium text-gray-700">Nom complet:</span>
                                <p class="text-gray-900">${consultation.patient.nom} ${consultation.patient.prenom}</p>
                            </div>
                            <div>
                                <span class="font-medium text-gray-700">N° Sécurité Sociale:</span>
                                <p class="text-gray-900">${consultation.patient.NSecuriteSociale}</p>
                            </div>
                            <div>
                                <span class="font-medium text-gray-700">Date de naissance:</span>
                                <p class="text-gray-900">
                                    <fmt:formatDate value="${dateNaissance}" pattern="dd/MM/yyyy" />
                                </p>
                            </div>
                        </div>
                    </div>

                    <div>
                        <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
                            <i class="fas fa-info-circle mr-2 text-green-600"></i>Informations Consultation
                        </h2>
                        <div class="space-y-3">
                            <div>
                                <span class="font-medium text-gray-700">Statut:</span>
                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium
                                        <c:choose>
                                            <c:when test="${consultation.statut == 'EN_COURS'}">bg-yellow-100 text-yellow-800</c:when>
                                            <c:when test="${consultation.statut == 'TERMINEE'}">bg-green-100 text-green-800</c:when>
                                        </c:choose>">
                                    <c:choose>
                                        <c:when test="${consultation.statut == 'EN_COURS'}">
                                            <i class="fas fa-clock mr-1"></i> En cours
                                        </c:when>
                                        <c:when test="${consultation.statut == 'TERMINEE'}">
                                            <i class="fas fa-check mr-1"></i> Terminée
                                        </c:when>
                                    </c:choose>
                                </span>
                            </div>

                            <div>
                                <span class="font-medium text-gray-700">Date consultation:</span>
                                <p class="text-gray-900">
                                    <c:choose>
                                        <c:when test="${not empty dateConsultation}">
                                            <fmt:formatDate value="${dateConsultation}" pattern="dd/MM/yyyy 'à' HH:mm" />
                                        </c:when>
                                        <c:otherwise>
                                            Date non disponible
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <c:if test="${not empty dateCloture}">
                                <div>
                                    <span class="font-medium text-gray-700">Date clôture:</span>
                                    <p class="text-gray-900">
                                        <fmt:formatDate value="${dateCloture}" pattern="dd/MM/yyyy 'à' HH:mm" />
                                    </p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Détails médicaux (motif, observations, diagnostic, traitement, actes techniques, coûts) -->
                <div class="grid grid-cols-1 gap-6">
                    <!-- Motif -->
                    <div>
                        <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
                            <i class="fas fa-comment-medical mr-2 text-purple-600"></i>Motif de Consultation
                        </h2>
                        <div class="bg-gray-50 p-4 rounded-md">
                            <p class="text-gray-900">${consultation.motif}</p>
                        </div>
                    </div>

                    <!-- Observations -->
                    <div>
                        <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
                            <i class="fas fa-stethoscope mr-2 text-orange-600"></i>Observations
                        </h2>
                        <div class="bg-gray-50 p-4 rounded-md">
                            <c:choose>
                                <c:when test="${not empty consultation.observations}">
                                    <p class="text-gray-900">${consultation.observations}</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-gray-500 italic">Aucune observation renseignée</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Diagnostic -->
                    <div>
                        <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
                            <i class="fas fa-diagnoses mr-2 text-red-600"></i>Diagnostic
                        </h2>
                        <div class="bg-gray-50 p-4 rounded-md">
                            <c:choose>
                                <c:when test="${not empty consultation.diagnostic}">
                                    <p class="text-gray-900">${consultation.diagnostic}</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-gray-500 italic">Aucun diagnostic renseigné</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Traitement -->
                    <div>
                        <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
                            <i class="fas fa-pills mr-2 text-green-600"></i>Traitement
                        </h2>
                        <div class="bg-gray-50 p-4 rounded-md">
                            <c:choose>
                                <c:when test="${not empty consultation.traitement}">
                                    <p class="text-gray-900">${consultation.traitement}</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-gray-500 italic">Aucun traitement renseigné</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Actes Techniques -->
<%--                    <c:if test="${not empty consultation.actesTechniques}">--%>
<%--                        <div>--%>
<%--                            <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">--%>
<%--                                <i class="fas fa-procedures mr-2 text-indigo-600"></i>Actes Techniques--%>
<%--                            </h2>--%>
<%--                            <div class="bg-gray-50 p-4 rounded-md">--%>
<%--                                <ul class="list-disc list-inside space-y-2">--%>
<%--                                    <c:forEach var="acte" items="${consultation.actesTechniques}">--%>
<%--                                        <li class="text-gray-900">${acte}</li>--%>
<%--                                    </c:forEach>--%>
<%--                                </ul>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </c:if>--%>

                    <!-- Coûts -->
                    <div>
                        <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
                            <i class="fas fa-euro-sign mr-2 text-yellow-600"></i>Détails des Coûts
                        </h2>
                        <div class="bg-gray-50 p-4 rounded-md">
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                <div>
                                    <span class="font-medium text-gray-700">Consultation:</span>
                                    <p class="text-gray-900">
                                        <fmt:formatNumber value="${consultation.coutConsultation}" type="currency" currencyCode="EUR" />
                                    </p>
                                </div>
                                <div>
                                    <span class="font-medium text-gray-700">Actes techniques:</span>
                                    <p class="text-gray-900">
                                        <fmt:formatNumber value="${consultation.coutActesTechniques}" type="currency" currencyCode="EUR" />
                                    </p>
                                </div>
                                <div>
                                    <span class="font-medium text-gray-700">Total:</span>
                                    <p class="text-lg font-bold text-green-600">
                                        <fmt:formatNumber value="${consultation.coutTotal}" type="currency" currencyCode="EUR" />
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="flex justify-end space-x-4 pt-6 border-t">
                    <a href="${pageContext.request.contextPath}/medecin/dashboard" class="bg-gray-500 text-white px-6 py-2 rounded-md hover:bg-gray-600 transition duration-200">
                        Retour
                    </a>
                    <c:if test="${consultation.statut == 'EN_COURS'}">
                        <a href="modifier-consultation?id=${consultation.id}" class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition duration-200">
                            <i class="fas fa-edit mr-2"></i>Modifier
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
