<%-- 
    Document   : getStaffNumbers
    Created on : 10 Mar, 2025, 2:47:06 PM
    Author     : manjuv
--%>

<%@page import="common.CommonHelper"%>
<%@ page import="java.util.*" %>


<%
    String pagetype = request.getParameter("pagetype");
    CommonHelper util = new CommonHelper();
 %>
<%
    String selectedGroup = request.getParameter("group");
    
    // Use a modified version of your getAllGuideno method
    List<String> staffNumbers = util.getStaffNumbersByGroup(selectedGroup);
    
    if (null != staffNumbers) 
    {
        Iterator<String> iter = staffNumbers.iterator();
        while (iter.hasNext()) 
        {
            String staffNo = iter.next();
            out.println("<option value='" + staffNo + "'>" + staffNo + "</option>");
        }
    } 
    else 
    {
        out.println("<option value=''>No staff numbers found</option>");
    }
%>
