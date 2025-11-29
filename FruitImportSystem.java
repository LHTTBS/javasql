import java.sql.*;
import java.util.Scanner;

/**
 * 简化版水果店进口管理系统
 * 所有功能在一个文件中实现
 */
public class FruitImportSystem {
    // 数据库配置
    private static final String URL = "jdbc:mysql://localhost:3306/fruit_shop?useSSL=false&serverTimezone=UTC";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "123456";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    private static Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        System.out.println("===== 🍎 水果店进口管理系统 =====");

        // 初始化数据库
        initializeDatabase();

        // 主菜单
        while (true) {
            showMenu();
            int choice = getIntInput("请选择操作: ");

            switch (choice) {
                case 1:
                    addFruit();
                    break;
                case 2:
                    viewAllFruits();
                    break;
                case 3:
                    addSupplier();
                    break;
                case 4:
                    viewAllSuppliers();
                    break;
                case 5:
                    addImportRecord();
                    break;
                case 6:
                    viewImportRecords();
                    break;
                case 7:
                    searchFruitsByCountry();
                    break;
                case 0:
                    System.out.println("感谢使用！再见！");
                    return;
                default:
                    System.out.println("无效选择，请重新输入！");
            }
        }
    }

    /**
     * 显示主菜单
     */
    private static void showMenu() {
        System.out.println("\n====== 主菜单 ======");
        System.out.println("1. 添加水果");
        System.out.println("2. 查看所有水果");
        System.out.println("3. 添加供应商");
        System.out.println("4. 查看所有供应商");
        System.out.println("5. 添加进口记录");
        System.out.println("6. 查看进口记录");
        System.out.println("7. 按原产国搜索水果");
        System.out.println("0. 退出系统");
        System.out.println("====================");
    }

    /**
     * 初始化数据库表
     */
    private static void initializeDatabase() {
        Connection conn = null;
        Statement stmt = null;

        try {
            Class.forName(DRIVER);
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            stmt = conn.createStatement();

            // 创建水果表
            String createFruitTable = "CREATE TABLE IF NOT EXISTS fruits (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(100) NOT NULL, " +
                    "origin_country VARCHAR(50) NOT NULL, " +
                    "price DECIMAL(10,2), " +
                    "stock INT DEFAULT 0, " +
                    "season VARCHAR(20)" +
                    ")";
            stmt.executeUpdate(createFruitTable);

            // 创建供应商表
            String createSupplierTable = "CREATE TABLE IF NOT EXISTS suppliers (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(100) NOT NULL, " +
                    "country VARCHAR(50) NOT NULL, " +
                    "contact VARCHAR(50), " +
                    "phone VARCHAR(20)" +
                    ")";
            stmt.executeUpdate(createSupplierTable);

            // 创建进口记录表
            String createImportTable = "CREATE TABLE IF NOT EXISTS import_records (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "fruit_id INT, " +
                    "supplier_id INT, " +
                    "import_date DATE, " +
                    "quantity INT, " +
                    "cost DECIMAL(12,2), " +
                    "FOREIGN KEY (fruit_id) REFERENCES fruits(id), " +
                    "FOREIGN KEY (supplier_id) REFERENCES suppliers(id)" +
                    ")";
            stmt.executeUpdate(createImportTable);

            System.out.println("✅ 数据库初始化成功！");

        } catch (Exception e) {
            System.out.println("❌ 数据库初始化失败: " + e.getMessage());
        } finally {
            closeResources(stmt, conn);
        }
    }

    /**
     * 添加水果
     */
    private static void addFruit() {
        System.out.println("\n--- 添加水果 ---");

        System.out.print("水果名称: ");
        String name = scanner.nextLine();

        System.out.print("原产国: ");
        String country = scanner.nextLine();

        double price = getDoubleInput("价格: ");
        int stock = getIntInput("库存数量: ");

        System.out.print("季节: ");
        String season = scanner.nextLine();

        String sql = "INSERT INTO fruits (name, origin_country, price, stock, season) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, name);
            pstmt.setString(2, country);
            pstmt.setDouble(3, price);
            pstmt.setInt(4, stock);
            pstmt.setString(5, season);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                System.out.println("✅ 水果添加成功！");
            }

        } catch (SQLException e) {
            System.out.println("❌ 添加失败: " + e.getMessage());
        }
    }

    /**
     * 查看所有水果
     */
    private static void viewAllFruits() {
        System.out.println("\n--- 所有水果 ---");

        String sql = "SELECT * FROM fruits ORDER BY id";

        try (Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            System.out.println("ID\t名称\t原产国\t价格\t库存\t季节");
            System.out.println("------------------------------------------------");

            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
                System.out.printf("%d\t%s\t%s\t%.2f\t%d\t%s%n",
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("origin_country"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getString("season")
                );
            }

            if (!hasData) {
                System.out.println("暂无水果数据");
            }

        } catch (SQLException e) {
            System.out.println("❌ 查询失败: " + e.getMessage());
        }
    }

    /**
     * 添加供应商
     */
    private static void addSupplier() {
        System.out.println("\n--- 添加供应商 ---");

        System.out.print("供应商名称: ");
        String name = scanner.nextLine();

        System.out.print("国家: ");
        String country = scanner.nextLine();

        System.out.print("联系人: ");
        String contact = scanner.nextLine();

        System.out.print("电话: ");
        String phone = scanner.nextLine();

        String sql = "INSERT INTO suppliers (name, country, contact, phone) VALUES (?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, name);
            pstmt.setString(2, country);
            pstmt.setString(3, contact);
            pstmt.setString(4, phone);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                System.out.println("✅ 供应商添加成功！");
            }

        } catch (SQLException e) {
            System.out.println("❌ 添加失败: " + e.getMessage());
        }
    }

    /**
     * 查看所有供应商
     */
    private static void viewAllSuppliers() {
        System.out.println("\n--- 所有供应商 ---");

        String sql = "SELECT * FROM suppliers ORDER BY id";

        try (Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            System.out.println("ID\t名称\t国家\t联系人\t电话");
            System.out.println("----------------------------------------");

            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
                System.out.printf("%d\t%s\t%s\t%s\t%s%n",
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("country"),
                        rs.getString("contact"),
                        rs.getString("phone")
                );
            }

            if (!hasData) {
                System.out.println("暂无供应商数据");
            }

        } catch (SQLException e) {
            System.out.println("❌ 查询失败: " + e.getMessage());
        }
    }

    /**
     * 添加进口记录
     */
    private static void addImportRecord() {
        System.out.println("\n--- 添加进口记录 ---");

        // 先显示水果列表
        viewAllFruits();
        int fruitId = getIntInput("选择水果ID: ");

        // 显示供应商列表
        viewAllSuppliers();
        int supplierId = getIntInput("选择供应商ID: ");

        System.out.print("进口日期 (YYYY-MM-DD): ");
        String importDate = scanner.nextLine();

        int quantity = getIntInput("进口数量: ");
        double cost = getDoubleInput("总成本: ");

        String sql = "INSERT INTO import_records (fruit_id, supplier_id, import_date, quantity, cost) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, fruitId);
            pstmt.setInt(2, supplierId);
            pstmt.setString(3, importDate);
            pstmt.setInt(4, quantity);
            pstmt.setDouble(5, cost);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                System.out.println("✅ 进口记录添加成功！");

                // 更新水果库存
                updateFruitStock(fruitId, quantity);
            }

        } catch (SQLException e) {
            System.out.println("❌ 添加失败: " + e.getMessage());
        }
    }

    /**
     * 查看进口记录
     */
    private static void viewImportRecords() {
        System.out.println("\n--- 进口记录 ---");

        String sql = "SELECT ir.id, f.name as fruit_name, s.name as supplier_name, " +
                "ir.import_date, ir.quantity, ir.cost " +
                "FROM import_records ir " +
                "JOIN fruits f ON ir.fruit_id = f.id " +
                "JOIN suppliers s ON ir.supplier_id = s.id " +
                "ORDER BY ir.import_date DESC";

        try (Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            System.out.println("ID\t水果\t供应商\t进口日期\t数量\t成本");
            System.out.println("----------------------------------------------------");

            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
                System.out.printf("%d\t%s\t%s\t%s\t%d\t%.2f%n",
                        rs.getInt("id"),
                        rs.getString("fruit_name"),
                        rs.getString("supplier_name"),
                        rs.getDate("import_date"),
                        rs.getInt("quantity"),
                        rs.getDouble("cost")
                );
            }

            if (!hasData) {
                System.out.println("暂无进口记录");
            }

        } catch (SQLException e) {
            System.out.println("❌ 查询失败: " + e.getMessage());
        }
    }

    /**
     * 按原产国搜索水果
     */
    private static void searchFruitsByCountry() {
        System.out.println("\n--- 按原产国搜索水果 ---");

        System.out.print("输入原产国: ");
        String country = scanner.nextLine();

        String sql = "SELECT * FROM fruits WHERE origin_country LIKE ? ORDER BY name";

        try (Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, "%" + country + "%");
            ResultSet rs = pstmt.executeQuery();

            System.out.println("ID\t名称\t原产国\t价格\t库存\t季节");
            System.out.println("------------------------------------------------");

            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
                System.out.printf("%d\t%s\t%s\t%.2f\t%d\t%s%n",
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("origin_country"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getString("season")
                );
            }

            if (!hasData) {
                System.out.println("没有找到相关水果");
            }

            rs.close();

        } catch (SQLException e) {
            System.out.println("❌ 搜索失败: " + e.getMessage());
        }
    }

    /**
     * 更新水果库存
     */
    private static void updateFruitStock(int fruitId, int quantity) {
        String sql = "UPDATE fruits SET stock = stock + ? WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, quantity);
            pstmt.setInt(2, fruitId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            System.out.println("❌ 更新库存失败: " + e.getMessage());
        }
    }

    /**
     * 工具方法：获取整数输入
     */
    private static int getIntInput(String prompt) {
        while (true) {
            try {
                System.out.print(prompt);
                return Integer.parseInt(scanner.nextLine());
            } catch (NumberFormatException e) {
                System.out.println("请输入有效的数字！");
            }
        }
    }

    /**
     * 工具方法：获取浮点数输入
     */
    private static double getDoubleInput(String prompt) {
        while (true) {
            try {
                System.out.print(prompt);
                return Double.parseDouble(scanner.nextLine());
            } catch (NumberFormatException e) {
                System.out.println("请输入有效的数字！");
            }
        }
    }

    /**
     * 工具方法：关闭数据库资源
     */
    private static void closeResources(Statement stmt, Connection conn) {
        try {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}