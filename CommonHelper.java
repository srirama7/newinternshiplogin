/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package common;

import com.cdot.nms.ConfigManager;
import com.cdot.nms.csmp.DatabaseManager;
import com.cdot.nms.exceptions.CNMSException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 *
 * @author manjuv
 */
public class CommonHelper {
    String className = "CommonHelper";
    DatabaseManager dbmgr;

    public CommonHelper() throws CNMSException {
        ConfigManager.init("/home/manjuv/INTERNSHIP_HOME/conf/config_interndb.xml");
        dbmgr = ConfigManager.getDatabaseManager("INTERNDB");
    }
    
    public List<String> getAllStreams() throws CNMSException {

        String sql = " SELECT streamname FROM stream ";
        System.out.println(className + ":::getAllStreams:::SQL is:::" + sql);

        ArrayList<ArrayList<String>> result = dbmgr.read(sql);
        ArrayList<String> strmList = null;
        if (null != result) {
            strmList = new ArrayList<String>(result.size());
            Iterator<ArrayList<String>> iter = result.iterator();
            while (iter.hasNext()) {
                ArrayList<String> inArray = iter.next();
                strmList.add(inArray.get(0));
            }
        }
        return strmList;
    }
    
     public List<String> getAllCourse() throws CNMSException {

        String sql = " SELECT course FROM course ";
        System.out.println(className + ":::getAllCourse:::SQL is:::" + sql);

        ArrayList<ArrayList<String>> result = dbmgr.read(sql);
        ArrayList<String> strmList = null;
        if (null != result) {
            strmList = new ArrayList<String>(result.size());
            Iterator<ArrayList<String>> iter = result.iterator();
            while (iter.hasNext()) {
                ArrayList<String> inArray = iter.next();
                strmList.add(inArray.get(0));
            }
        }
        return strmList;
    }
     
    public List<String> getAllGuide() throws CNMSException {

        String sql = " select distinct EGROUP from Kmg_employeestaff_info; ";
        System.out.println(className + ":::getAllGuide:::SQL is:::" + sql);

        ArrayList<ArrayList<String>> result = dbmgr.read(sql);
        ArrayList<String> strmList = null;
        if (null != result) {
            strmList = new ArrayList<String>(result.size());
            Iterator<ArrayList<String>> iter = result.iterator();
            while (iter.hasNext()) {
                ArrayList<String> inArray = iter.next();
                strmList.add(inArray.get(0));
            }
        }
        return strmList;
    }
    
//    public List<String> getAllGuideno() throws CNMSException {
//
//        String sql = "select distinct STAFFNO from Kmg_employeestaff_info where EGROUP=' ' and designation in('Acting Group Leader' or 'Group Leader');";
//        System.out.println(className + ":::getAllGuideno:::SQL is:::" + sql);
//
//        ArrayList<ArrayList<String>> result = dbmgr.read(sql);
//        ArrayList<String> strmList = null;
//        if (null != result) {
//            strmList = new ArrayList<String>(result.size());
//            Iterator<ArrayList<String>> iter = result.iterator();
//            while (iter.hasNext()) {
//                ArrayList<String> inArray = iter.next();
//                strmList.add(inArray.get(0));
//            }
//        }
//        return strmList;
//    }
    
    public List<String> getStaffNumbersByGroup(String groupName) throws CNMSException {
    String sql = "SELECT DISTINCT STAFFNO FROM Kmg_employeestaff_info WHERE EGROUP='" + 
                  groupName + "' AND designation IN ('Acting Group Leader' or 'Group Leader')";
    
    System.out.println(className + ":::getStaffNumbersByGroup:::SQL is:::" + sql);
    ArrayList<ArrayList<String>> result = dbmgr.read(sql);
    ArrayList<String> staffList = null;
    
    if (null != result) {
        staffList = new ArrayList<String>(result.size());
        Iterator<ArrayList<String>> iter = result.iterator();
        while (iter.hasNext()) {
            ArrayList<String> inArray = iter.next();
            staffList.add(inArray.get(0));
        }
    }
    return staffList;
    }
    
    public String getGuideNameByStaffNo(String staffNo) throws CNMSException {
    String sql = "SELECT EMPNAME FROM Kmg_employeestaff_info WHERE STAFFNO='" + staffNo + "'";
    
    System.out.println(className + ":::getGuideNameByStaffNo:::SQL is:::" + sql);
    ArrayList<ArrayList<String>> result = dbmgr.read(sql);
    
    if (null != result && !result.isEmpty() && !result.get(0).isEmpty()) {
        return result.get(0).get(0);
    }
    return null;
}
}
