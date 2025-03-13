<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.cdot.nms.ConfigManager"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.cdot.nms.csmp.Replacevalue"%>
<%@page import="com.cdot.nms.csmp.HyperlinkReport"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Internship Applications Report</title>
        
        <!-- Include all CSS and JS files from the original page -->
        <link rel="icon" type="image/png" href="images/icons/cdot.jpeg"/>
        <link rel="stylesheet" type="text/css" href="general.css">
        
        <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/tabs.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/style1.css" type="text/css" media="all" />
        <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/d_claro.css" type="text/css" />
        
        <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/dojo/dojo.js" djConfig="parseOnLoad: true, locale: 'en-us'"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/cnms/dojo-report.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/cnms/dojo-select.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/cnms/reportingTool.js"></script>
       
        <link rel="stylesheet" href="threebuttonsss.css">
        <style>
            /* Dropdown styles */
            .dropdown-container {
                position: relative;
                display: inline-block;
                margin: 10px;
            }

            /* Styling for the buttons */
            .dropdown-container .btn {
                display: block;
                padding: 10px 15px;
                background-color: #f1f1f1;
                border: 1px solid #ddd;
                text-decoration: none;
                color: black;
            }

            /* Change the dropdown class to work with hover */
            .dropdown {
                position: relative;
                display: inline-block;
            }

            /* Hide dropdown content by default */
            .dropdown-content {
                display: none;
                position: absolute;
                background-color: #f9f9f9;
                min-width: 200px;
                box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
                z-index: 1;
                border: 1px solid #ddd;
            }

            /* Show the dropdown menu on hover */
            .dropdown:hover .dropdown-content {
                display: block;
            }

            /* Links inside the dropdown */
            .dropdown-content a {
                color: black;
                padding: 12px 16px;
                text-decoration: none;
                display: block;
            }

            .dropdown-content a:hover {
                background-color: #f1f1f1;
            }
            
            .show {
                display: block;
            }
            
            /* Data container styles */
            #dataContainer {
                margin-top: 20px;
            }
            
            .data-section {
                display: none;
            }
            
            .data-section.active {
                display: block;
            }
            .container {
                width: 90%; /* Adjust width as needed */
                /* Add any other styles you need for the container */
            }
            .content1 {
                width: 100%;
                padding: 20px;
                margin-left: 10%;
            }
        </style>
        
        <%
            response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
        %>
    </head>
    <body class="claro">
    <button class="logout-button" onclick="window.location.href = 'otpnew1.jsp'">Logout</button>
    <div class="content-box">
    <h1>Student Internship Form</h1>
    <div class="button-container">
        <button class="back-button" onclick="window.location.href = 'threebuttons.jsp?form=userDetails'">Student Details</button>
        <button class="back-button" onclick="window.location.href = 'threebuttons.jsp?form=academicDetails'">Academic Details</button>
        <button class="back-button" onclick="window.location.href = 'threebuttons.jsp?form=training'">Training Details</button>
        <div class="dropdown">
            <button id="viewStorageBtn" class="back-button">Reports</button>
            <div id="viewStorageDropdown" class="dropdown-content">
                <a href="report1.jsp" id="internAppLink">Internship Applications</a>
                <a href="report2.jsp" id="courseDataLink">List Course Data</a>
                <a href="report3.jsp" id="streamDataLink">List Stream Data</a>
            </div>
        </div>
        </div>
    </div>
        
        <div id="dataContainer"> 
                <div id="internshipData" class="data-section active">

                <h1>Internship Applications</h1>

                <%
                    try {
                        ConfigManager.init("/home/manjuv/INTERNSHIP_HOME/conf/config_interndb.xml");

                        String sql =  "SELECT cdot_id, full_name, email, phone, course, stream, "
                                + "university, college, cgpa, training_duration, guide_name "
                                + "FROM intern ORDER BY id DESC";
                        System.out.println(":::displayDetails:::sql:::" + sql);

                        HyperlinkReport report = new HyperlinkReport(request, response, out);
                        String HideNullCol = "Guide_name";
                        Replacevalue repvals[] = new Replacevalue[HideNullCol.split(",").length];
                        int i = 0;
                        for (String col : HideNullCol.split(",")) {
                            repvals[i] = new Replacevalue();
                            repvals[i].setColumnName(col);
                            repvals[i].setReplaceNull(true);
                            repvals[i].setReplaceValue("--");
                            i++;
                        }
                        report.setReplaceValueInfo(repvals);
                        report.setPagination(true);
                        report.setPagesize(10);
                        report.setPageHeader("usersList");

                        report.setEmptyMsg("No Data found!!!");
                        report.print(sql, "INTERNDB");
                    } catch (Exception e) {
                        out.println("<h2>" + "ERROR: DB Exception Occured  !! " + "</h2>");
                        System.out.println("displayDetailsERROR: DB Exception Occured : " + e.getMessage());
                        e.printStackTrace();
                        out.println("<br>");
                    }
                %>
          </div>
        </div>
            
            <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Get the dropdown button and content
                const viewStorageBtn = document.getElementById('viewStorageBtn');
                const viewStorageDropdown = document.getElementById('viewStorageDropdown');
                
                // Get the data section links
                const internAppLink = document.getElementById('internAppLink');
                const courseDataLink = document.getElementById('courseDataLink');
                const streamDataLink = document.getElementById('streamDataLink');
                
                // Get the data sections
                const internshipData = document.getElementById('internshipData');
                const courseData = document.getElementById('courseData');
                const streamData = document.getElementById('streamData');
                
                // Toggle dropdown when button is clicked
                viewStorageBtn.addEventListener('click', function(event) {
                    event.preventDefault();
                    viewStorageDropdown.classList.toggle('show');
                });
                
                // Close dropdown when clicking outside
                window.addEventListener('click', function(event) {
                    if (!event.target.matches('#viewStorageBtn')) {
                        if (viewStorageDropdown.classList.contains('show')) {
                            viewStorageDropdown.classList.remove('show');
                        }
                    }
                });
                
             
                
                
                
               
                
                // Helper function to hide all data sections
                function hideAllSections() {
                    if (internshipData) internshipData.classList.remove('active');
                    if (courseData) courseData.classList.remove('active');
                    if (streamData) streamData.classList.remove('active');
                }
                
                // Apply active class to the Reports button
                viewStorageBtn.classList.add('view-stored-active');
            });
            
          
             window.onload = function() {
        // Get the form parameter from the URL
        var urlParams = new URLSearchParams(window.location.search);
        var formToShow = urlParams.get('form');
        
        // If a specific form is requested in the URL, show it automatically
        if (formToShow) {
            showForm(formToShow);
        }
    };


  
        </script>
    </body>
</html>