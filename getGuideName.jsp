<%-- 
    Document   : getGuideName
    Created on : 10 Mar, 2025, 3:45:04 PM
    Author     : manjuv
--%>

<%@page import="common.CommonHelper"%>
<%
    String pagetype = request.getParameter("pagetype");
    CommonHelper util = new CommonHelper();
%>

<%
    String staffNo = request.getParameter("staffNo");
    
    // Get the guide name for the selected staff number
    String guideName = util.getGuideNameByStaffNo(staffNo);
    
    if (guideName != null) {
        out.print(guideName);
    }
%>