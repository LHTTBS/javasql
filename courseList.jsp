<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbconfig.jsp" %>
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    // 获取查询参数
    String search = request.getParameter("search");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>课程信息管理系统</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #e67e22;
            padding-bottom: 10px;
        }
        .search-form {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            padding: 25px;
            margin-bottom: 30px;
            border-radius: 8px;
            color: white;
        }
        .search-form input[type="text"] {
            padding: 12px;
            border: none;
            border-radius: 5px;
            width: 400px;
            font-size: 16px;
            margin-right: 10px;
        }
        .search-form input[type="submit"] {
            background: #e67e22;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        .search-form input[type="submit"]:hover {
            background: #d35400;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }
        th {
            background-color: #e67e22;
            color: white;
            font-weight: bold;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        tr:hover {
            background-color: #fff3e0;
        }
        .btn {
            background: #3498db;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            margin: 5px;
        }
        .btn:hover {
            background: #2980b9;
        }
        .btn-back {
            background: #95a5a6;
        }
        .btn-back:hover {
            background: #7f8c8d;
        }
        .course-code {
            font-family: 'Courier New', monospace;
            font-weight: bold;
            color: #2c3e50;
        }
        .prerequisite {
            color: #7f8c8d;
            font-style: italic;
        }
        .no-prerequisite {
            color: #bdc3c7;
        }
        .stats {
            background: #34495e;
            color: white;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            text-align: center;
        }
        .stats h3 {
            margin: 0 0 10px 0;
            color: #ecf0f1;
        }
        .course-count {
            font-size: 24px;
            font-weight: bold;
            color: #e74c3c;
        }
        .action-buttons {
            text-align: center;
            margin: 20px 0;
        }
        .highlight {
            background-color: #fff3cd !important;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>📚 课程信息管理系统</h2>

    <div class="search-form">
        <form method="get">
            <h3>🔍 搜索课程</h3>
            <input type="text" name="search" value="<%= search != null ? search : "" %>"
                   placeholder="输入课程名称或编号进行搜索...">
            <input type="submit" value="搜索课程">
            <% if (search != null && !search.trim().isEmpty()) { %>
            <a href="courseList.jsp" style="color: white; margin-left: 10px;">清除搜索</a>
            <% } %>
        </form>
    </div>

    <%
        try {
            conn = getConnection();
            stmt = conn.createStatement();

            // 构建查询语句
            String sql = "SELECT c.cNO, c.cName, pc.cName as preCourseName, " +
                    "(SELECT COUNT(*) FROM course_class cc WHERE cc.cNO = c.cNO) as classCount " +
                    "FROM course c " +
                    "LEFT JOIN course pc ON c.cpNO = pc.cNO ";

            if (search != null && !search.trim().isEmpty()) {
                sql += "WHERE c.cName LIKE '%" + search + "%' OR c.cNO LIKE '%" + search + "%' ";
            }

            sql += "ORDER BY c.cNO";

            rs = stmt.executeQuery(sql);

            // 统计信息
            int totalCourses = 0;
            int coursesWithPrereq = 0;
    %>

    <div class="stats">
        <h3>📊 课程统计</h3>
        <%
            // 获取课程总数
            ResultSet countRs = stmt.executeQuery("SELECT COUNT(*) as total, " +
                    "COUNT(CASE WHEN cpNO IS NOT NULL THEN 1 END) as withPrereq " +
                    "FROM course");
            if (countRs.next()) {
                totalCourses = countRs.getInt("total");
                coursesWithPrereq = countRs.getInt("withPrereq");
        %>
        <p>总课程数：<span class="course-count"><%= totalCourses %></span> 门</p>
        <p>有先修课程的课程：<span class="course-count"><%= coursesWithPrereq %></span> 门</p>
        <p>无先修课程的课程：<span class="course-count"><%= totalCourses - coursesWithPrereq %></span> 门</p>
        <%
            }
            countRs.close();
        %>
    </div>

    <table>
        <thead>
        <tr>
            <th>课程编号</th>
            <th>课程名称</th>
            <th>先修课程</th>
            <th>开课班级数</th>
            <th>课程关系</th>
        </tr>
        </thead>
        <tbody>
        <%
            while (rs.next()) {
                String preCourse = rs.getString("preCourseName");
                int classCount = rs.getInt("classCount");
                String rowClass = search != null && !search.trim().isEmpty() &&
                        (rs.getString("cName").contains(search) ||
                                rs.getString("cNO").contains(search)) ? "highlight" : "";
        %>
        <tr class="<%= rowClass %>">
            <td class="course-code"><%= rs.getString("cNO") %></td>
            <td><strong><%= rs.getString("cName") %></strong></td>
            <td class="<%= preCourse != null ? "prerequisite" : "no-prerequisite" %>">
                <%= preCourse != null ? preCourse : "无先修课程" %>
            </td>
            <td>
                <% if (classCount > 0) { %>
                <span style="color: #27ae60; font-weight: bold;"><%= classCount %> 个班级</span>
                <% } else { %>
                <span style="color: #95a5a6;">暂无开课</span>
                <% } %>
            </td>
            <td>
                <% if (preCourse != null) { %>
                <span style="color: #e67e22;">📋 需要先修</span>
                <% } else { %>
                <span style="color: #27ae60;">🎯 可直接学习</span>
                <% } %>
            </td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <%
    } catch (Exception e) {
    %>
    <div style="background: #e74c3c; color: white; padding: 20px; border-radius: 5px; text-align: center;">
        <h3>⚠️ 数据库错误</h3>
        <p><%= e.getMessage() %></p>
    </div>
    <%
        } finally {
            closeResources(conn, stmt, rs);
        }
    %>

    <div class="action-buttons">
        <a href="studentList.jsp" class="btn btn-back">← 返回学生列表</a>
        <a href="studentScore.jsp" class="btn">查询学生成绩 →</a>
    </div>

    <div style="margin-top: 30px; padding: 15px; background: #ecf0f1; border-radius: 5px;">
        <h4>💡 使用说明：</h4>
        <ul>
            <li>可以通过课程名称或编号搜索课程</li>
            <li>绿色标注的课程表示当前有开课班级</li>
            <li>橙色标注的课程表示需要先修课程</li>
            <li>点击上方按钮可以切换到其他功能模块</li>
        </ul>
    </div>
</div>
</body>
</html>