<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>学生信息管理系统 - 主页</title>
  <style>
    body {
      font-family: 'Microsoft YaHei', Arial, sans-serif;
      margin: 0;
      padding: 0;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .container {
      background: white;
      padding: 40px;
      border-radius: 15px;
      box-shadow: 0 20px 40px rgba(0,0,0,0.1);
      text-align: center;
      max-width: 800px;
      width: 90%;
    }
    h1 {
      color: #2c3e50;
      margin-bottom: 10px;
      font-size: 2.5em;
    }
    .subtitle {
      color: #7f8c8d;
      margin-bottom: 40px;
      font-size: 1.2em;
    }
    .nav-cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      margin: 30px 0;
    }
    .nav-card {
      background: white;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      text-decoration: none;
      color: #2c3e50;
      transition: all 0.3s ease;
      border: 2px solid transparent;
    }
    .nav-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(0,0,0,0.2);
      border-color: #3498db;
    }
    .nav-card h3 {
      margin: 0 0 10px 0;
      font-size: 1.5em;
    }
    .nav-card p {
      color: #7f8c8d;
      margin: 0;
    }
    .icon {
      font-size: 3em;
      margin-bottom: 15px;
    }
    .card-student { border-top: 4px solid #3498db; }
    .card-score { border-top: 4px solid #2ecc71; }
    .card-course { border-top: 4px solid #e74c3c; }
    .card-admin { border-top: 4px solid #f39c12; }

    .stats {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
      gap: 15px;
      margin: 30px 0;
    }
    .stat-card {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 8px;
      border-left: 4px solid #3498db;
    }
    .stat-number {
      font-size: 2em;
      font-weight: bold;
      color: #2c3e50;
    }
    .stat-label {
      color: #7f8c8d;
      font-size: 0.9em;
    }

    .footer {
      margin-top: 40px;
      padding-top: 20px;
      border-top: 1px solid #ecf0f1;
      color: #7f8c8d;
      font-size: 0.9em;
    }
  </style>
</head>
<body>
<div class="container">
  <h1>🎓 学生信息管理系统</h1>
  <div class="subtitle">欢迎使用学生信息综合管理平台</div>

  <!-- 统计信息 -->
  <div class="stats">
    <div class="stat-card">
      <div class="stat-number">81</div>
      <div class="stat-label">学生总数</div>
    </div>
    <div class="stat-card">
      <div class="stat-number">16</div>
      <div class="stat-label">专业数量</div>
    </div>
    <div class="stat-card">
      <div class="stat-number">13</div>
      <div class="stat-label">课程数量</div>
    </div>
    <div class="stat-card">
      <div class="stat-number">574</div>
      <div class="stat-label">成绩记录</div>
    </div>
  </div>

  <!-- 导航卡片 -->
  <div class="nav-cards">
    <a href="studentList.jsp" class="nav-card card-student">
      <div class="icon">👨‍🎓</div>
      <h3>学生信息管理</h3>
      <p>查看、搜索学生基本信息，按专业筛选学生</p>
    </a>

    <a href="studentScore.jsp" class="nav-card card-score">
      <div class="icon">📊</div>
      <h3>成绩查询系统</h3>
      <p>按学号查询学生成绩，查看成绩统计和分析</p>
    </a>

    <a href="courseList.jsp" class="nav-card card-course">
      <div class="icon">📚</div>
      <h3>课程信息管理</h3>
      <p>浏览课程信息，查看课程关系和开课情况</p>
    </a>

    <a href="systemInfo.jsp" class="nav-card card-admin">
      <div class="icon">⚙️</div>
      <h3>系统信息</h3>
      <p>查看系统状态和数据库连接信息</p>
    </a>
  </div>

  <div class="footer">
    <p>技术支持：JSP + MySQL + Tomcat | 版本 1.0</p>
  </div>
</div>
</body>
</html>