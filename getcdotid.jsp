<%@ page import="java.sql.*" %>
<%
    String lastCdotId = "N/A"; // Default value if no records exist

    try {
        // Load MySQL driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Connect to database
        Connection con = DriverManager.getConnection("jdbc:mysql://192.168.75.227", "dotuser", "dot123");

        // Fetch last inserted cdot_id
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT cdot_id FROM intern ORDER BY id DESC LIMIT 1");

        if (rs.next()) {
            lastCdotId = rs.getString("cdot_id");
        }

        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Send response as plain text
    out.print(lastCdotId);
%>
