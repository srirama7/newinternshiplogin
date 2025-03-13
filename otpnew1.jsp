<%-- 
    Document   : otpnew1.jsp
    Created on : 12 Mar, 2025, 3:58:13 PM
    Author     : manjuv
--%>

<%@page import="com.cdot.nms.ConfigManager"%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    // The existing Java code remains unchanged
    ConfigManager.init("/home/manjuv/INTERNSHIP_HOME/conf/config_interndb.xml");

    // Database connection details
    String url = "jdbc:mysql://192.168.75.227/mydatabase";
    String dbUser = "dotuser";
    String dbPass = "dot123";

    if (request.getParameter("checkStaffNo") != null) {
        String staffNoToCheck = request.getParameter("checkStaffNo");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String responseText = "";

        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection
            conn = DriverManager.getConnection(url, dbUser, dbPass);

            // Query to check staff number and get email
            String sql = "SELECT STAFFNO, EMAIL FROM Kmg_employeestaff_info WHERE STAFFNO = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, staffNoToCheck);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Staff found, return the email
                responseText = rs.getString("EMAIL");
            } else {
                // Staff not found
                responseText = "No Employee Found :( ";
            }

            // Write the response
            response.setContentType("text/plain");
            response.getWriter().write(responseText);
            return; // End processing here for AJAX requests

        } catch (Exception e) {
            response.setContentType("text/plain");
            response.getWriter().write("ERROR: " + e.getMessage());
            e.printStackTrace();
            return;
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // Retrieve form data
    String username = request.getParameter("username");
    String roleName = request.getParameter("roleName");

    // Process database operation if form was submitted
    if (username != null && roleName != null && !username.isEmpty() && !roleName.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection
            conn = DriverManager.getConnection(url, dbUser, dbPass);

            // Insert query for the login table with roleName and username
            String sql = "INSERT INTO login (roleName, username) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, roleName);
            pstmt.setString(2, username);

            // Execute the query
            int rowsInserted = pstmt.executeUpdate();

            if (rowsInserted > 0) {
                // Store user data in session
                session.setAttribute("username", username);
                session.setAttribute("roleName", roleName);

                // Log successful insertion
                System.out.println("Successfully inserted record into login table: username=" + username + ", roleName=" + roleName);

                // Redirect to the role's page
                response.sendRedirect(roleName);
            } else {
                out.println("<script>alert('Error saving data. Try again!');</script>");
            }
        } catch (Exception e) {
            out.println("<script>alert('Database connection error: " + e.getMessage() + "');</script>");
            e.printStackTrace();
        } finally {
            // Close resources properly
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login & OTP Verification</title>
        <link rel="stylesheet" href="styles.css">
        <link rel="icon" type="image/png" href="images/icons/cdot.jpeg"/>
    </head>
    <body>
        <div class="card">
            <div class="header">
                <h1 style="color:green">LOGIN PAGE</h1>
                <h2 style="color:black">OTP Verification</h2>
            </div>
            <div class="content" id="content">
                <form id="loginForm" method="POST">
                    <!-- Hidden field for action -->
                    <input type="hidden" id="action" name="action" value="">
                    <!-- Hidden field for roleName (text value) -->
                    <input type="hidden" id="roleName" name="roleName" value="">

                    <!-- Dropdown to select role -->
                    <select id="roleSelect" name="role" required onchange="handleRoleChange()">
                        <option value="">Select Role</option>
                        <option value="student.jsp">STUDENT_TRAINEE</option>
                        <option value="threebuttons.jsp">REFERRED_STAFF</option>
                        <option value="kmghead.jsp">KMG_ADMIN</option>
                    </select>
                    <br><br>

                    <div id="staffNoSection" class="form-group" style="display: none;">
                        <input type="text" 
                               id="staffNo" 
                               name="staffNo" 
                               placeholder="Enter Staff Code" 
                               maxlength="4" 
                               pattern="\d{4}" 
                               title="Staff code must be exactly 4 digits"
                               oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                        <button id="verifyStaffBtn" onclick="verifyStaffNo(event)" type="button">
                            Verify Staff
                        </button>
                        <span id="staffError" style="color: red; display: none;">Invalid Staff Code</span>
                    </div>

                    <!-- Email input field -->
                    <div class="form-group" id="emailSection">
                        <input type="text" id="username" name="username" placeholder="Enter your email" required>
                        <span id="emailError" style="color: red; display: none;">Invalid Email Format</span>
                    </div>

                    <!-- Generate OTP button -->
                    <div class="form-group" id="otpButtonSection">
                        <button id="generateBtn" onclick="OTPFn(event)" type="button">
                            Generate OTP
                        </button>
                    </div>

                    <!-- OTP input and verification -->
                    <div id="otpForm" class="otp-form" style="display: none;">
                        <input type="text" id="userOTP" placeholder="Enter OTP">
                        <button onclick="OTPVerifyFn()" type="button">
                            Verify
                        </button>
                    </div>
                </form>

                <div id="successMessage" class="success-message" style="display: none;">
                    <i class="fas fa-check"></i>
                    <p>OTP is Verified Successfully! Redirecting...</p>
                </div>
                <div id="errorMessage" class="error-message" style="display: none;"></div>
                <div id="timer" class="timer" style="display: none;"></div>
            </div>
        </div>

        <script>
            // Email validation
            document.getElementById("username").addEventListener("input", function () {
                const emailInput = this.value;
                const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                const errorMessage = document.getElementById("emailError");

                if (!emailPattern.test(emailInput)) {
                    errorMessage.style.display = "block";
                } else {
                    errorMessage.style.display = "none";
                }
            });

            function validateEmail(email) {
                const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                return emailPattern.test(email);
            }

            function OTPFn(event) {
                event.preventDefault(); // Prevent any default form submission

                let email = document.getElementById("username").value;
                let role = document.getElementById("roleSelect").value;

                if (email.trim() === "") {
                    alert("Please enter your email first.");
                    return false;
                }

                if (!validateEmail(email)) {
                    document.getElementById("emailError").style.display = "block";
                    alert("Please enter a valid email address.");
                    return false;
                }

                if (!role) {
                    alert("Please select a role.");
                    return false;
                }

                alert("OTP sent to " + email); // Simulate OTP sending
                document.getElementById("otpForm").style.display = "block";
                return true;
            }

            function OTPVerifyFn() {
                let enteredOTP = document.getElementById("userOTP").value;
                let roleValue = document.getElementById("roleSelect").value;
                let username = document.getElementById("username").value;
                let roleText = document.getElementById("roleSelect").options[document.getElementById("roleSelect").selectedIndex].text;

                if (!enteredOTP) {
                    alert("Please enter the OTP.");
                    return;
                }

                if (enteredOTP === "1234") { // Simulating correct OTP
                    // Set the action to indicate we're submitting with verified OTP
                    document.getElementById("action").value = "verifyOTP";
                    // Set the roleName (text value) in the hidden field
                    document.getElementById("roleName").value = roleText;

                    // Store in session storage for client-side access if needed
                    sessionStorage.setItem('username', username);
                    sessionStorage.setItem('roleName', roleText);

                    document.getElementById("successMessage").style.display = "block";

                    console.log("Inserting into login table: username=" + username + ", roleName=" + roleText);

                    // Submit the form to insert data into the database
                    setTimeout(() => {
                        document.getElementById("loginForm").submit();
                    }, 2000);
                } else {
                    alert("Incorrect OTP, please try again.");
                }
            }

            function handleRoleChange() {
    const roleSelect = document.getElementById("roleSelect");
    const staffNoSection = document.getElementById("staffNoSection");
    const emailSection = document.getElementById("emailSection");
    const otpButtonSection = document.getElementById("otpButtonSection");
    const usernameInput = document.getElementById("username");
    const otpForm = document.getElementById("otpForm");
    const staffError = document.getElementById("staffError");

    // Reset error messages when changing roles
    staffError.style.display = "none";
    
    if (roleSelect.value === "threebuttons.jsp") {
        // For REFERRED_STAFF role
        staffNoSection.style.display = "block";
        emailSection.style.display = "none";      // Hide email section initially
        otpButtonSection.style.display = "none";  // Hide OTP button initially
        usernameInput.readOnly = true;
        otpForm.style.display = "none";           // Hide OTP form
    } else {
        // For other roles (STUDENT_TRAINEE and KMG_ADMIN)
        staffNoSection.style.display = "none";
        emailSection.style.display = "block";     // Show email section
        otpButtonSection.style.display = "block"; // Show OTP button
        usernameInput.readOnly = false;
        usernameInput.value = "";
    }
}

function verifyStaffNo(event) {
    event.preventDefault();
    const staffNo = document.getElementById("staffNo").value.trim();
    const staffError = document.getElementById("staffError");
    const emailSection = document.getElementById("emailSection");
    const otpButtonSection = document.getElementById("otpButtonSection");
    
    // Find the verify button - let's try different potential selectors
    // It could be a button with type="submit" within a form for staff verification
    const verifyButton = event.target; // This gets the button that triggered the event
    
    if (!staffNo) {
        staffError.textContent = "Please enter staff code";
        staffError.style.display = "block";
        return;
    }
    
    // Create AJAX request to verify staff number
    const xhr = new XMLHttpRequest();
    xhr.open("POST", window.location.href, true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            const response = xhr.responseText;
            
            if (response === "No Employee Found :( ") {
                staffError.textContent = "No staff found with this code";
                staffError.style.display = "block";
                document.getElementById("username").value = "";
                emailSection.style.display = "block";
                otpButtonSection.style.display = "none";
                // Keep verify button enabled
                if (verifyButton) verifyButton.disabled = false;
                
            } else if (response.startsWith("ERROR:")) {
                staffError.textContent = "System error. Please try again.";
                staffError.style.display = "block";
                document.getElementById("username").value = "";
                emailSection.style.display = "block";
                otpButtonSection.style.display = "none";
                // Keep verify button enabled
                if (verifyButton) verifyButton.disabled = false;
                
            } else {
                // Valid staff found with email
                document.getElementById("username").value = response;
                staffError.style.display = "none";
                emailSection.style.display = "block";
                
                // Only show OTP button if valid email was found
                if (response && response.includes('@')) {
                    otpButtonSection.style.display = "block";
                    // Disable verify button when valid email is found
                    if (verifyButton) verifyButton.disabled = true;
                    
                    // Also disable the staff number input field
                    document.getElementById("staffNo").disabled = true;
                    
                    // Add visual indication that verification was successful
                    console.log("Staff verification successful");
                } else {
                    otpButtonSection.style.display = "none";
                    staffError.textContent = "Staff's Email is not found try again!!";
                    staffError.style.display = "block";
                    // Keep verify button enabled
                    if (verifyButton) verifyButton.disabled = false;
                }
            }
        }
    };
    xhr.send("checkStaffNo=" + encodeURIComponent(staffNo));
}
        </script>

        <script src="script.js"></script>
    </body>
</html>