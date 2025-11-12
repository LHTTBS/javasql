<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbconfig.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    String studentNo = request.getParameter("studentNo");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学生成绩查询系统</title>
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
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }
        .search-form {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 25px;
            margin-bottom: 30px;
            border-radius: 8px;
            color: white;
        }
        .search-form input[type="text"] {
            padding: 12px;
            border: none;
            border-radius: 5px;
            width: 300px;
            font-size: 16px;
            margin-right: 10px;
        }
        .search-form input[type="submit"] {
            background: #e74c3c;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        .search-form input[type="submit"]:hover {
            background: #c0392b;
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
            background-color: #3498db;
            color: white;
            font-weight: bold;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        tr:hover {
            background-color: #e3f2fd;
        }
        .btn {
            background: #2ecc71;
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
            background: #27ae60;
        }
        .btn-back {
            background: #95a5a6;
        }
        .btn-back:hover {
            background: #7f8c8d;
        }
        .fail {
            color: #e74c3c;
            font-weight: bold;
        }
        .excellent {
            color: #27ae60;
            font-weight: bold;
        }
        .good {
            color: #f39c12;
            font-weight: bold;
        }
        .student-info {
            background: #ecf0f1;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #3498db;
        }
        .student-info h3 {
            margin: 0;
            color: #2c3e50;
        }
        .summary {
            background: #2c3e50;
            color: white;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
            text-align: center;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
            font-size: 18px;
        }
        .term-header {
            background: #34495e !important;
            color: white;
            font-size: 16px;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>📊 学生成绩查询系统</h2>

    <div class="search-form">
        <form method="get">
            <h3>🔍 查询学生成绩</h3>
            <input type="text" name="studentNo" value="<%= studentNo != null ? studentNo : "" %>"
                   placeholder="请输入学号，例如：081710106" required>
            <input type="submit" value="查询成绩">
        </form>
    </div>

        <%
            if (studentNo != null && !studentNo.trim().isEmpty()) {
                try {
                    conn = getConnection();
                    // 先获取学生基本信息
                    String infoSql = "SELECT s.sNO, s.sName, m.mName, d.dName " +
                                    "FROM student s " +
                                    "JOIN major m ON s.mNO = m.mNO " +
                                    "JOIN department d ON m.dNO = d.dNO " +
                                    "WHERE s.sNO = ?";
                    pstmt = conn.prepareStatement(infoSql);
                    pstmt.setString(1, studentNo);
                    ResultSet infoRs = pstmt.executeQuery();

                    if (infoRs.next()) {
        %>
    <div class="student-info">
        <h3>👨‍🎓 学生信息</h3>
        <p><strong>学号：</strong><%= infoRs.getString("sNO") %></p>
        <p><strong>姓名：</strong><%= infoRs.getString("sName") %></p>
        <p><strong>专业：</strong><%= infoRs.getString("mName") %></p>
        <p><strong>院系：</strong><%= infoRs.getString("dName") %></p>
    </div>
        <%
                    } else {
        %>
    <div class="no-data">
        <p>❌ 未找到学号为 <strong><%= studentNo %></strong> 的学生</p>
        <p>请检查学号是否正确</p>
    </div>
        <%
                        if (infoRs != null) infoRs.close();
                        return;
                    }
                    if (infoRs != null) infoRs.close();

                    // 查询成绩，按学期分组
                    String scoreSql = "SELECT c.cName, cc.Term, sc.Mark, cc.Credit, cc.ExamType " +
                                     "FROM student_course sc " +
                                     "JOIN course_class cc ON sc.ccNO = cc.ccNO " +
                                     "JOIN course c ON cc.cNO = c.cNO " +
                                     "WHERE sc.sNO = ? " +
                                     "ORDER BY cc.Term, c.cName";
                    pstmt = conn.prepareStatement(scoreSql);
                    pstmt.setString(1, studentNo);
                    rs = pstmt.executeQuery();

                    String currentTerm = "";
                    int totalCourses = 0;
                    int totalScore = 0;
                    double totalCredits = 0;
                    double earnedCredits = 0;
                    boolean hasData = false;
        %>
    <div class="score-results">
        <%
            while (rs.next()) {
                hasData = true;
                String term = rs.getString("Term");
                if (!term.equals(currentTerm)) {
                    currentTerm = term;
                    if (totalCourses > 0) {
        %>
        </tbody>
        <%
            }
        %>
        <h3>📅 学期：<%= term %></h3>
        <table>
            <thead>
            <tr>
                <th>课程名称</th>
                <th>考试类型</th>
                <th>学分</th>
                <th>成绩</th>
                <th>状态</th>
            </tr>
            </thead>
            <tbody>
            <%
                }

                totalCourses++;
                int mark = rs.getInt("Mark");
                double credit = rs.getDouble("Credit");
                totalCredits += credit;

                String statusClass = "";
                String statusText = "";
                String statusIcon = "";

                if (!rs.wasNull()) {
                    totalScore += mark;
                    if (mark < 60) {
                        statusClass = "fail";
                        statusText = "不及格";
                        statusIcon = "❌";
                    } else if (mark >= 90) {
                        statusClass = "excellent";
                        statusText = "优秀";
                        statusIcon = "⭐";
                        earnedCredits += credit;
                    } else if (mark >= 80) {
                        statusClass = "good";
                        statusText = "良好";
                        statusIcon = "✅";
                        earnedCredits += credit;
                    } else {
                        statusText = "及格";
                        statusIcon = "✅";
                        earnedCredits += credit;
                    }
                } else {
                    statusText = "未考试";
                    statusIcon = "⏳";
                }
            %>
            <tr>
                <td><%= rs.getString("cName") %></td>
                <td><%= rs.getString("ExamType") %></td>
                <td><%= credit %></td>
                <td><%= !rs.wasNull() ? mark : "未考试" %></td>
                <td class="<%= statusClass %>"><%= statusIcon %> <%= statusText %></td>
            </tr>
            <%
                }

                if (hasData) {
            %>
            </tbody>
        </table>

        <div class="summary">
            <h3>📈 成绩统计</h3>
            <p><strong>总课程数：</strong><%= totalCourses %> 门</p>
            <p><strong>平均成绩：</strong><%= totalCourses > 0 ? String.format("%.2f", (double) totalScore / totalCourses) : "0.00" %> 分</p>
            <p><strong>总学分：</strong><%= String.format("%.1f", totalCredits) %> 学分</p>
            <p><strong>已获学分：</strong><%= String.format("%.1f", earnedCredits) %> 学分</p>
            <p><strong>通过率：</strong><%= totalCredits > 0 ? String.format("%.1f", (earnedCredits / totalCredits) * 100) : "0.0" %>%</p>
        </div>
        <%
        } else {
        %>
        <div class="no-data">
            <p>📝 该学生暂无成绩记录</p>
            <p>可能尚未参加任何考试或成绩未录入</p>
        </div>
        <%
            }
        } catch (Exception e) {
        %>
        <div class="no-data">
            <p>⚠️ 查询错误：<%= e.getMessage() %></p>
            <p>请检查数据库连接或联系管理员</p>
        </div>
        <%
            } finally {
                closeResources(conn, pstmt, rs);
            }
        } else {
        %>
        <div class="no-data">
            <p>👆 请在上方输入学号查询成绩</p>
            <p>💡 提示：可以尝试学号 081710106、091650101 等</p>
        </div>
        <%
            }
        %>

        <div style="text-align: center; margin-top: 30px;">
            <a href="studentList.jsp" class="btn btn-back">← 返回学生列表</a>
            <a href="courseList.jsp" class="btn">查看课程信息 →</a>
        </div>
    </div>
</body>
</html>