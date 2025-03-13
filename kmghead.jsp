<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Account Creation</title>
    <link rel="stylesheet" href="kmphead.css">
    <link rel="icon" type="image/png" href="images/icons/cdot.jpeg"/>
</head>
<body>
    
    <script src="kmghead.js"></script>
    
    <button class="logout-button" onclick="window.location.href='otpnew.jsp'">Logout</button>
    
    <div class="button-box">
    <h1>Student Internship Form</h1>
    <div class="button-container">
        <button id="studentBtn" class="active" onclick="showForm('studentdetails')">Create Student Details</button>
        <button id="streamBtn" onclick="showForm('streamdetails')">Create new Stream</button>
        <button id="courseBtn" onclick="showForm('coursedetails')">Create New Course</button>
    </div>
</div>
    
    <%
    String jdbcURL = "jdbc:mysql://192.168.75.227/mydatabase";
    String dbUser = "dotuser";
    String dbPassword = "dot123";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    %>
    
    <div id="studentdetails" class="form-container active">
        <h1>Student Credentials</h1>
        
        

   <div class="form-group">
    <label for="cdotId">CDOT ID*</label>
    <select id="cdotId" name="cdotId" required onchange="fetchEmail()">
        <option value="">Select CDOT ID</option>
        <%
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            
            String query = "SELECT cdot_id, id, email FROM intern";
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                String cdotId = rs.getString("cdot_id"); // Fetching cdot_id
                
                String email = rs.getString("email"); // Fetching email
                String displayText = cdotId ; // Combining cdot_id and id
        %>
                <option value="<%= cdotId %>" data-email="<%= email %>"><%= displayText %></option>
        <%
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        %>
    </select>
</div>

<div class="form-group">
    <label for="email">Email*</label>
    <input type="text" id="email" name="email" readonly required>
</div>

            <div class="form-group">
                <label for="password">Password*</label>
                <div class="password-container">
                    <input type="password" id="password" name="password" required>
                    <button type="button" class="toggle-password" onclick="togglePassword()">Show</button>
                </div>
            </div>

            <button type="submit">Create Account</button>
        </form>

        
    </div>

    

    <%
    String streamname = request.getParameter("streamname");
    String remarks = request.getParameter("remarks");
    String message = "";

    if (streamname != null && !streamname.trim().isEmpty()) {
        conn = null;
        pstmt = null;
        rs = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            String checkQuery = "SELECT * FROM stream WHERE streamname = ? OR remarks = ?";
            pstmt = conn.prepareStatement(checkQuery);
            pstmt.setString(1, streamname);
            pstmt.setString(2, remarks);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                message = "Warning: Stream with this name or description already exists!";
            } else {
                String insertQuery = "INSERT INTO stream (streamname, remarks) VALUES (?, ?)";
                pstmt = conn.prepareStatement(insertQuery);
                pstmt.setString(1, streamname);
                pstmt.setString(2, remarks);
                int result = pstmt.executeUpdate();
                if (result > 0) {
                    message = "Stream created successfully!";
                }
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    %>

    <div id="streamdetails" class="form-container">
        <h1>Create New Stream</h1>
        <% if (!message.isEmpty()) { %>
            <div><%= message %></div>
        <% } %>
        <form method="POST" action="">
            <div class="form-group">
                <label for="streamname">Stream Name*</label>
                <input type="text" id="streamname" name="streamname" required>
            </div>
            <div class="form-group">
                <label for="remarks">Remarks</label>
                <textarea id="remarks" name="remarks"></textarea>
            </div>
            <button type="submit">Create Stream</button>
        </form>
    </div>

    <%
    String course = request.getParameter("course");
    String description = request.getParameter("description");

    if (course != null && !course.trim().isEmpty()) {
        conn = null;
        pstmt = null;
        rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            String checkQuery = "SELECT * FROM course WHERE course = ? OR description = ?";
            pstmt = conn.prepareStatement(checkQuery);
            pstmt.setString(1, course);
            pstmt.setString(2, description);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                message = "Warning: Course with this name or description already exists!";
            } else {
                String insertQuery = "INSERT INTO course (course, description) VALUES (?, ?)";
                pstmt = conn.prepareStatement(insertQuery);
                pstmt.setString(1, course);
                pstmt.setString(2, description);
                pstmt.executeUpdate();
                message = "Course created successfully!";
            }
        } catch(Exception e) {
            message = "Error: " + e.getMessage();
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    %>

    <div id="coursedetails" class="form-container">
        <h1>Create New Course</h1>
        <form method="POST" action="">
            <div class="form-group">
                <label>Course Name</label>
                <input type="text" name="course" required>
            </div>
            <div class="form-group">
                <label>Description</label>
                <textarea name="description"></textarea>
            </div>
            <button type="submit">Create Course</button>
        </form>
    </div>

    <script>
    
    </script>
</body>
</html>
