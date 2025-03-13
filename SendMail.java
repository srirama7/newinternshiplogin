/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package common;

import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Properties;
import java.util.ResourceBundle;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.URLName;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
//import org.apache.logging.log4j.LogManager;
//import org.apache.logging.log4j.Logger;
public class SendMail {

    private Session session;
    private String SMTP_USERNAME;
    private String SMTP_PASSWORD;
    Boolean errorStatus = false;
    int noOfTimesTried = -1;
   // private static Logger logger = LogManager.getLogger("TOT");

    public SendMail() {
    }

    public boolean process(String sender, String subject, String[] receipient, String[] cc,
            String msgBody) {
        boolean returnFlag = false;
        String user = null;
        String passwd = null;
        String host = null;
        String port = null;
        int auth = 1;
        String domainName = null;
        try {
            //Get the smtp server properties
            PropertyLoader pl = new PropertyLoader();
            pl.initiate();
            //new PropertyLoader().initiate();
            Locale locale = Locale.getDefault();
            /*ResourceBundle resources = ResourceBundle.getBundle("conf/smtp");

             host = resources.getString("host");
             port = resources.getString("port");
             auth = Integer.parseInt(resources.getString("auth"));
             user = resources.getString("username");
             passwd = resources.getString("password");
             domainName = resources.getString("domainName");*/

            host = pl.getHost();
            port = pl.getPort();
            auth = pl.getAuth();
            user = pl.getUser();
            sender = pl.getSender();
            passwd = pl.getPasswd();
            domainName = pl.getDomainName();

            System.out.println("SendMail:::properties:::" + host + "," + port + "," + auth + "," + user + "," + sender + "," + passwd + "," + domainName);

            sender = sender + "@" + domainName.trim();
            config(host, port, auth, user, passwd);

            if (send(sender, subject, receipient, cc, msgBody)) {
                System.out.println("SendMail:::Mail delivered");
                returnFlag = true;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return returnFlag;
        }
        return returnFlag;
    }

    private boolean send(String sender, String subject, String[] recepient, String[] cc,
            String msgBody) {
        System.out.println("SendMail:::Inside send new method ......... ");
        boolean result = true;

        try {
            Date date = null;
            SimpleDateFormat ORA_DATE_FORMAT = null;

            date = new Date(System.currentTimeMillis());
            ORA_DATE_FORMAT = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
            String curdate = ORA_DATE_FORMAT.format(date);

            String htmlText = "";
            htmlText = "<html><body><br><table border=1><tr><td><b>From </b></td><td><b>C-DOT InternAdmin Team</b></td></tr>"
                    + "<tr><td><b>Sender</b></td><td><b>" + sender + "</b></td></tr>"
                    //  + "<tr><td><b> Recepient List</b></td><td><b>" + recepient + "</b></td></tr>"
                    + "<tr><td><b> NOTE</b></td><td><b>Auto-Generated Mail. Don't Reply to this.</b></td></tr>"
                    + "<tr><td><b>Dated </b></td><td><b>" + curdate + "</b></td></tr>"
                    + "</b></table><br>"
                    + msgBody + "</body></html>";
            System.out.println("SendMail:::htmlText in send method:::" + htmlText);
            MimeMessage mimeMessage = new MimeMessage(session);
            mimeMessage.setContent(htmlText, "text/html");
            //mimeMessage.setText(msgBody);

            InternetAddress addressFrom = new InternetAddress(sender);
            mimeMessage.setFrom(addressFrom);
            mimeMessage.setSentDate(new Date());
            mimeMessage.setSubject(subject);

            InternetAddress[] to = new InternetAddress[recepient.length];
            for (int i = 0; i < recepient.length; i++) {
                to[i] = new InternetAddress(recepient[i]);

            }
            mimeMessage.addRecipients(Message.RecipientType.TO, to);
            if (cc != null) {
                InternetAddress[] tocc = new InternetAddress[cc.length];
                for (int i = 0; i < cc.length; i++) {
                    tocc[i] = new InternetAddress(cc[i]);
                    System.out.println("cc added:::: " + cc[i] + "  to is " + tocc[i]);
                }
                mimeMessage.addRecipients(Message.RecipientType.CC, tocc);
            }

            System.out.println("[MSN][SendEmail.java] before Message sent");
            System.out.println("[MSN][SendEmail.java]  before call to message.saveChanges()");
            mimeMessage.saveChanges();

            System.out.println( "[MSN][SendEmail.java]  after call to message.saveChanges()");
            // smtptransport.sendMessage(message,this.addressTo);
            System.out.println("[MSN][SendEmail.java] before call to  Transport.send(message)");
            Transport.send(mimeMessage);

            System.out.println("[MSN][SendEmail.java] after call to  Transport.send(message)");
            System.out.println("[MSN][SendEmail.java]  after message sent");
        } catch (Exception se) {
            System.out.println("[MSN][SendEmail.java] Send failedMessagingException in SendEmail in send :" + se);
            result = false;
        } finally {
            return result;
        }
    }

    private class SMTPAuthenticator extends javax.mail.Authenticator {
        public PasswordAuthentication getPasswordAuthentication() {
            String username = SMTP_USERNAME;
            String password = SMTP_PASSWORD;
            return new PasswordAuthentication(username, password);
        }
    }

    public void config(String mailHost, String port, int authflag, String username, String password) {
        Properties props;
        boolean debug = true;
        URLName url = null;
        try {
            SMTP_USERNAME = username;
            SMTP_PASSWORD = password;
            System.out.println("SendMail:::config:::mailHost::: " + mailHost + ":::port:::: " + port + ":::::auth flag::: " + authflag + "::::username::::" + SMTP_USERNAME + "::::passwrod:::" + SMTP_PASSWORD);

            props = new Properties();
            props.put("mail.smtp.host", mailHost);
            props.put("mail.smtp.port", port);
            props.put("mail.smtp.sendpartial", "true");

            if (authflag == 1) {
                //System.out.println("Authentication is  required.....");
                props.put("mail.smtp.auth", true);
                SMTPAuthenticator auth = new SMTPAuthenticator();
                session = Session.getInstance(props, auth);
            } else {
                System.out.println("SendMail:::config:::Authentication is not required.....");
                session = Session.getInstance(props, null);
            }
            session.setDebug(debug);
            PrintStream out = null;
            session.setDebugOut(out);
            url = new URLName("smtp", mailHost, -1, "test.txt", SMTP_USERNAME, SMTP_PASSWORD);
            try {
            } catch (Exception e) {
                System.out.println("SendMail:::config:::smtp exception" + e);
            }
        } catch (Exception e) {
            System.out.println("SendMail:::config:::Exception in SendEmail in config function " + e);
        }
    }

//    public static void main(String[] args) {
//        SendMail sm = new SendMail();
//       
//         String sender = user.trim() + "@" + domainName.trim();
//         System.out.println("Sender : " + sender);
//        String[] receipientList = new String[1];
//        receipientList[0] = "thanuja.pt@gmail.com";
//        receipientList[2] = "roopa@cdot.in";
//
//      	  String msgBody="<html></html>";
//	sm.process("sankalpa", "Travel Booking Approval Request", "sankalpa@cdot.in", null, msgBody);        
//    }
}

