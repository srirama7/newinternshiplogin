<%@ page import="java.io.*, java.util.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>

<%
final String DEST_DIR = "/home/manjuv/Downloads/";

if (ServletFileUpload.isMultipartContent(request)) {
    try {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List<FileItem> items = upload.parseRequest(request);

        boolean fileTransferred = false;
        for (FileItem item : items) {
            if (!item.isFormField()) {
                String fileName = new File(item.getName()).getName();
                if (fileName.endsWith(".pdf") || fileName.endsWith(".doc") || fileName.endsWith(".docx")) {
                    File destFile = new File(DEST_DIR + fileName);
                    item.write(destFile);
                    fileTransferred = true;
                }
            }
        }

        if (fileTransferred) {
            out.print("success");
        } else {
            out.print("failed");
        }
    } catch (Exception e) {
        out.print("error: " + e.getMessage());
    }
}
%>
