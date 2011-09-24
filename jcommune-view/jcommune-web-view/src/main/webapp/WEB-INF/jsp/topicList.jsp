<%--

    Copyright (C) 2011  jtalks.org Team
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.
    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
    Also add information on how to contact you by electronic and paper mail.
    Creation date: Apr 12, 2011 / 8:05:19 PM
    The jtalks.org Project

--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="joda" uri="http://www.joda.org/joda/time/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Forum</title>
</head>
<body>

<div class="wrap branch_page">

    <!-- Начало всех форумов -->
    <div class="all_forums">
        <h2><a class="heading" href="#">Для новичков</a></h2>

        <div class="forum_misc_info">
            Здесь вы можете задать свои глупые вопросы
            <span class="nav_top">На страницу: 1, <a href="#">2</a> <a href="#">След.</a></span>
        </div>
        <a class="forum_top_right_link" href="#">Отметить все темы как прочтенные</a>
        <sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
            <a class="button top_button"
               href="${pageContext.request.contextPath}/branch/${branchId}/topic/create.html"><spring:message
                    code="label.addtopic"/></a>
            &nbsp; &nbsp; &nbsp;
        </sec:authorize>
        <a class="forums_list" href="#" title="Список форумов">Список форумов</a>
        <span class="arrow"> > </span>
        <a class="forums_list" href="#" title="Для новичков">Для новичков</a>

        <!-- Начало группы форумов -->
        <div class="forum_header_table"> <!-- Шапка бранча -->
            <div class="forum_header">
                <span class="forum_header_topics"><spring:message code="label.branch.header.topics"/></span>
                <span class="forum_header_answers"><spring:message code="label.branch.header.answers"/></span>
                <span class="forum_header_author"><spring:message code="label.branch.header.author"/></span>
                <span class="forum_header_clicks"><spring:message code="label.branch.header.views"/></span>
                <span class="forum_header_last_message"><spring:message code="label.branch.header.lastMessage"/></span>
            </div>
        </div>


        <ul class="forum_table"> <!-- Список топиков -->
            <c:forEach var="topic" items="${topics}">
                <li class="forum_row"> <!-- Топик -->
                    <div class="forum_icon"> <!-- Иконка с кофе -->
                        <img class="icon" src="${pageContext.request.contextPath}/resources/images/closed_cup.png" alt=""
                             title="Форум закрыт"/>
                    </div>
                    <c:choose>
                        <c:when test="${topic.announcement=='true'}">
                            <div class="forum_info"> <!-- Ссылка на тему -->
                                <h4><span class="sticky">Объявление: </span><a class="forum_link"
                                                                               href="${pageContext.request.contextPath}/topic/${topic.id}.html">
                                    <spring:message code="label.marked_as_announcement"/><c:out
                                        value="${topic.title}"/></a></h4>
                            </div>
                        </c:when>
                        <c:when test="${topic.sticked=='true'}">
                            <div class="forum_info"> <!-- Ссылка на тему -->
                                <h4><span class="sticky">Прикреплено: </span><a class="forum_link"
                                                                                href="${pageContext.request.contextPath}/topic/${topic.id}.html">
                                    <spring:message code="label.marked_as_sticked"/><c:out
                                        value="${topic.title}"/></a></h4>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="forum_info"> <!-- Ссылка на тему -->
                                <h4><a class="forum_link"
                                       href="${pageContext.request.contextPath}/topic/${topic.id}.html"><c:out
                                        value="${topic.title}"/></a></h4>

                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="forum_answers">
                        26
                    </div>
                    <div class="forum_author">
                        <a href="${pageContext.request.contextPath}/user/${topic.topicStarter.encodedUsername}.html"
                           title="Автор темы"><c:out value="${topic.topicStarter.username}"/></a>
                    </div>
                    <div class="forum_clicks">
                        953092
                    </div>
                    <div class="forum_last_message">
                        <a href="${pageContext.request.contextPath}/topic/${topic.id}.html">
                            <joda:format value="${topic.lastPost.creationDate}"
                                         locale="${sessionScope['org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE']}"
                                         pattern="dd MMM yyyy HH:mm"/></a>
                        <br/>
                        <a class="last_message_user"
                           href="${pageContext.request.contextPath}/user/${topic.lastPost.userCreated.encodedUsername}.html">
                            <c:out value="${topic.lastPost.userCreated.username}"/></a>
                        <a href="#"><img src="${pageContext.request.contextPath}/resources/images/icon_latest_reply.gif"
                                         alt="Последнее сообщение"/></a>
                    </div>
                </li>
            </c:forEach>
        </ul>

        <!-- Конец группы форумов -->
        <span class="nav_bottom">На страницу: 1, <a href="#">2</a> <a href="#">След.</a></span>
        <sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
            <a class="button"
               href="${pageContext.request.contextPath}/branch/${branchId}/topic/create.html#"><spring:message
                    code="label.addtopic"/></a>
            &nbsp; &nbsp; &nbsp;
        </sec:authorize>
        <a class="forums_list" href="#" title="Список форумов">Список форумов</a>
        <span class="arrow"> > </span>
        <a class="forums_list" href="#" title="Для новичков">Для новичков</a>

        <div class="forum_misc_info">
            <div id="pagination">
                <c:if test="${maxPages > 1}">

                    <c:if test="${page > 2}">
                        <c:url value="/branch/${branchId}.html" var="first">
                            <c:param name="page" value="1"/>
                        </c:url>
                        <a href='<c:out value="${first}" />' class="pn next"><spring:message
                                code="pagination.first"/></a>...
                    </c:if>

                    <c:choose>
                        <c:when test="${page > 1}">
                            <c:set var="begin" value="${page - 1}"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="begin" value="1"/>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${page + 1 < maxPages}">
                            <c:set var="end" value="${page + 1}"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="end" value="${maxPages}"/>
                        </c:otherwise>
                    </c:choose>

                    <c:forEach begin="${begin}" end="${end}" step="1" varStatus="i">
                        <c:choose>
                            <c:when test="${page == i.index}">
                                <span>${i.index}</span>
                            </c:when>
                            <c:otherwise>
                                <c:url value="/branch/${branchId}.html" var="url">
                                    <c:param name="page" value="${i.index}"/>
                                </c:url>
                                <a href='<c:out value="${url}" />'>${i.index}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:if test="${page + 2 < maxPages+1}">
                        <c:url value="/branch/${branchId}.html" var="last">
                            <c:param name="page" value="${maxPages}"/>
                        </c:url>
                        ...<a href='<c:out value="${last}"/>' class="pn next"><spring:message code="pagination.last"/></a>
                    </c:if>

                </c:if>
            </div>
            <br/>
            Модераторы:
            <ul class="users_list">
                <li><a href="#">andreyko</a>,</li>
                <li><a href="#">Староверъ</a>,</li>
                <li><a href="#">Вася</a>.</li>
            </ul>
            <br/>
            Сейчас этот форум просматривают: Нет

    </div>
</div>
<!-- Конец всех форумов -->
<div class="footer_buffer"></div>
<!-- Несемантичный буфер для прибития подвала -->
</div>
</body>
</html>