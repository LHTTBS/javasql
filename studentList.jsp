<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbconfig.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    String keyword = request.getParameter("keyword");
    String major = request.getParameter("major");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学生信息管理系统</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .search-form { background: #f5f5f5; padding: 15px; margin-bottom: 20px; border-radius: 5px; }
        table { border-collapse: collapse; width: 100%; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .btn { background: #4CAF50; color: white; padding: 5px 10px; border: none; border-radius: 3px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn:hover { background: #45a049; }
        .btn-blue { background: #2196F3; }
        .btn-blue:hover { background: #0b7dda; }
        .btn-orange { background: #ff9800; }
        .btn-orange:hover { background: #e68900; }
    </style>
</head>
<body>
<h2>学生信息管理系统</h2>

<div class="search-form">
    <form method="get">
        姓名搜索：<input type="text" name="keyword" value="<%= keyword != null ? keyword : "" %>">
        专业：
        <select name="major">
            <option value="">全部专业</option>
            <%
                try {
                    conn = getConnection();
                    String sql = "SELECT mNO, mName FROM major";
                    pstmt = conn.prepareStatement(sql);
                    ResultSet majorRs = pstmt.executeQuery();
                    while (majorRs.next()) {
                        String selected = major != null && major.equals(majorRs.getString("mNO")) ? "selected" : "";
            %>
            <option value="<%= majorRs.getString("mNO") %>" <%= selected %>>
                <%= majorRs.getString("mName") %>
            </option>
            <%
                    }
                    majorRs.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </select>
        <input type="submit" value="搜索" class="btn">
        <a href="studentList.jsp" class="btn">重置</a>
    </form>
</div>

<table>
    <tr>
        <th>学号</th>
        <th>姓名</th>
        <th>专业</th>
        <th>性别</th>
        <th>出生日期</th>
        <th>籍贯</th>
        <th>身高(cm)</th>
        <th>体重(kg)</th>
    </tr>
    <%
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT s.sNO, s.sName, m.mName, s.sSex, s.sBirth, s.sNative, s.sHeight, s.sWeight " +
                            "FROM student s JOIN major m ON s.mNO = m.mNO WHERE 1=1"
            );

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append(" AND s.sName LIKE ?");
            }
            if (major != null && !major.trim().isEmpty()) {
                sql.append(" AND s.mNO = ?");
            }
            sql.append(" ORDER BY s.sNO");

            pstmt = conn.prepareStatement(sql.toString());
            int paramIndex = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                pstmt.setString(paramIndex++, "%" + keyword + "%");
            }
            if (major != null && !major.trim().isEmpty()) {
                pstmt.setString(paramIndex++, major);
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getString("sNO") %></td>
        <td><%= rs.getString("sName") %></td>
        <td><%= rs.getString("mName") %></td>
        <td><%= rs.getString("sSex") %></td>
        <td><%= rs.getDate("sBirth") %></td>
        <td><%= rs.getString("sNative") %></td>
        <td><%= rs.getInt("sHeight") %></td>
        <td><%= rs.getInt("sWeight") %></td>
    </tr>
    <%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='8'>查询错误：" + e.getMessage() + "</td></tr>");
        } finally {
            closeResources(conn, pstmt, rs);
        }
    %>
</table>

<div style="margin-top: 20px;">
    <a href="studentScore.jsp" class="btn btn-blue">查看学生成绩</a>
    <a href="courseList.jsp" class="btn btn-orange">查看课程信息</a>
</div>
</body>
</html>