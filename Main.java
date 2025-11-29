import java.sql.*;

public class Main {
    // 修改为你的MySQL实际信息
    static final String URL = "jdbc:mysql://localhost:3306/clothing_store?useSSL=false&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASSWORD = "123456";

    public static void main(String[] args) {
        System.out.println("===== 开始测试MySQL连接 =====");

        try {
            // 1. 加载驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ 驱动加载成功！");

            // 2. 获取连接
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ 数据库连接成功！");

            // 3. 执行查询
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT VERSION()");
            if (rs.next()) {
                System.out.println("✅ MySQL版本: " + rs.getString(1));
            }

            // 4. 关闭
            rs.close();
            stmt.close();
            conn.close();
            System.out.println("✅ 连接关闭成功！");
            System.out.println("\n🎉 恭喜你！JDBC连接完全正常！");

        } catch (ClassNotFoundException e) {
            System.err.println("❌ 驱动类找不到！请下载mysql-connector-java.jar");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("❌ 连接失败！请检查用户名、密码、MySQL服务是否启动");
            System.err.println("错误信息: " + e.getMessage());
        }
    }
}