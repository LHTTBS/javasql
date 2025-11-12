<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="dbconfig.jsp" %>
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    // 获取系统信息
    Properties props = System.getProperties();
    Runtime runtime = Runtime.getRuntime();

    long maxMemory = runtime.maxMemory();
    long totalMemory = runtime.totalMemory();
    long freeMemory = runtime.freeMemory();
    long usedMemory = totalMemory - freeMemory;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>系统信息</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1000px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin: 20px 0; }
        .info-card { background: #f8f9fa; padding: 20px; border-radius: 5px; border-left: 4px solid #3498db; }
        .info-card h3 { margin-top: 0; color: #2c3e50; }
        .btn { background: #3498db; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; margin: 5px; }
        .btn:hover { background: #2980b9; }
        .db-status { color: #27ae60; font-weight: bold; }
        .db-error { color: #e74c3c; font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <h2>⚙️ 系统信息</h2>

    <div style="text-align: center; margin-bottom: 20px;">
        <a href="index.jsp" class="btn">🏠 返回主页</a>
        <a href="studentList.jsp" class="btn">👨‍🎓 学生管理</a>
    </div>

    <div class="info-grid">
        <div class="info-card">
            <h3>📊 数据库状态</h3>
            <%
                try {
                    conn = getConnection();
                    if (conn != null && !conn.isClosed()) {
            %>
            <p class="db-status">✅ 数据库连接正常</p>
            <%
                // 获取数据库统计
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT COUNT(*) as count FROM student");
                if (rs.next()) {
            %>
            <p><strong>学生记录：</strong><%= rs.getInt("count") %> 条</p>
            <%
                }
                rs.close();

                rs = stmt.executeQuery("SELECT COUNT(*) as count FROM course");
                if (rs.next()) {
            %>
            <p><strong>课程数量：</strong><%= rs.getInt("count") %> 门</p>
            <%
                }
            %>
            <%
                }
            } catch (Exception e) {
            %>
            <p class="db-error">❌ 数据库连接失败: <%= e.getMessage() %></p>
            <%
                } finally {
                    closeResources(conn, stmt, rs);
                }
            %>
        </div>

        <div class="info-card">
            <h3>🖥️ 系统环境</h3>
            <p><strong>Java 版本：</strong><%= props.getProperty("java.version") %></p>
            <p><strong>操作系统：</strong><%= props.getProperty("os.name") %></p>
            <p><strong>系统架构：</strong><%= props.getProperty("os.arch") %></p>
            <p><strong>用户目录：</strong><%= props.getProperty("user.dir") %></p>
        </div>

        <div class="info-card">
            <h3>💾 内存使用</h3>
            <p><strong>最大内存：</strong><%= maxMemory / 1024 / 1024 %> MB</p>
            <p><strong>已用内存：</strong><%= usedMemory / 1024 / 1024 %> MB</p>
            <p><strong>可用内存：</strong><%= freeMemory / 1024 / 1024 %> MB</p>
            <p><strong>总内存：</strong><%= totalMemory / 1024 / 1024 %> MB</p>
        </div>

        <div class="info-card">
            <h3>🔗 快速链接</h3>
            <p><a href="studentList.jsp">👨‍🎓 学生信息管理</a></p>
            <p><a href="studentScore.jsp">📊 成绩查询系统</a></p>
            <p><a href="courseList.jsp">📚 课程信息管理</a></p>
            <p><a href="testConnection.jsp">🔧 连接测试</a></p>
        </div>
    </div>

    <div style="margin-top: 30px; padding: 15px; background: #ecf0f1; border-radius: 5px;">
        <h4>💡 系统说明</h4>
        <p>这是一个基于 JSP + MySQL + Tomcat 的学生信息管理系统，包含学生管理、成绩查询、课程管理等核心功能。</p>
    </div>
</div>
</body>
</html>