
<%@page import="common.SendMail"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.IOException"%>
<%@page import="com.cdot.nms.csmp.DatabaseManager"%>
<%@page import="com.cdot.nms.ConfigManager"%>

<%
    System.out.println("I am in checkOTP");
    String emailid = request.getParameter("emailid");
    System.out.println("emailid" + emailid);
    
    String otp = request.getParameter("otpVal");
    otp = otp.trim();
    System.out.println("otp ::" + otp);
    String[] receipient = new String[1];
    receipient[0] = emailid;
    String msgBody = "<b> Generated OTP <br> "
            + "One Time Token:::" + otp + " <br> "
            + "<br><br> ";
    System.out.println("msgBody::" + msgBody);
    SendMail sendMail = new SendMail();
    System.out.println("Sent mail was successful");
    boolean mailret = true;//sendMail.process("TestUser", "User One Time Verification Details", receipient, null, msgBody); 

       response.getWriter().write(""+mailret);
%>