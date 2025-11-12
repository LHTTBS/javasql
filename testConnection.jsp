<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/stumanage?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    String username = "root";
    String password = "123456"; // 替换为实际密码

    Connection conn = null;
    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, username, password);
        out.println("<h3 style='color: green;'>✅ 数据库连接成功！</h3>");

        // 测试查询
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM student");
        if (rs.next()) {
            out.println("<p>学生表记录数: " + rs.getInt("count") + "</p>");
        }
        rs.close();
        stmt.close();

    } catch (ClassNotFoundException e) {
        out.println("<h3 style='color: red;'>❌ 驱动加载失败: " + e.getMessage() + "</h3>");
    } catch (SQLException e) {
        out.println("<h3 style='color: red;'>❌ 数据库连接失败: " + e.getMessage() + "</h3>");
        out.println("<p>错误代码: " + e.getErrorCode() + "</p>");
        out.println("<p>SQL状态: " + e.getSQLState() + "</p>");
    } finally {
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) {}
        }
    }
%>