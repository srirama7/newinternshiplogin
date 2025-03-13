package common;

import javax.mail.*;
import javax.mail.internet.*;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

public class PropertyLoader {

    private Properties properties = null;
    private String user = null;
    private String passwd = null;
    private String sender = null;
    private String host = null;
    private String port = null;
    private int auth = 0; //1;
    private String domainName = null;
    private String home = null;

    public PropertyLoader() {
        properties = new Properties();
    }

    public void initiate() {
        home = "/home/manjuv/INTERNSHIP_HOME/conf";
        FileInputStream fis;
        try {
            fis = new FileInputStream(home + "/smtp.properties");
            properties.load(fis);
            fis.close();
        } catch (FileNotFoundException ex) {
            ex.printStackTrace();
        } catch (IOException ex) {
            ex.printStackTrace();
        }

        host = properties.getProperty("host");
        port = properties.getProperty("port");
        //auth = Integer.parseInt(properties.getProperty("auth"));
        user = properties.getProperty("username");
        passwd = properties.getProperty("password");

        //sender = "thanujap";
        sender = properties.getProperty("username");
        domainName = properties.getProperty("domainName");
    }

    public int getAuth() {
        return auth;
    }

    public void setAuth(int auth) {
        this.auth = auth;
    }

    public String getSender() {
        return sender;
    }

    public String getDomainName() {
        return domainName;
    }

    public void setDomainName(String domainName) {
        this.domainName = domainName;
    }

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public String getPasswd() {
        return passwd;
    }

    public void setPasswd(String passwd) {
        this.passwd = passwd;
    }

    public String getPort() {
        return port;
    }

    public void setPort(String port) {
        this.port = port;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }
    /*public static void main(String s[]) {
     PropertyLoader p = new PropertyLoader();
     p.initiate();
     System.err.println("" + p.getDatabaseURL());
     }*/
}
