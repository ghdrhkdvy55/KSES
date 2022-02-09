package egovframework.com.cmm.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

public class FileDownloadView extends AbstractView {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileDownloadView.class);
	
	public FileDownloadView(){
        //content type을 지정.
        setContentType("apllication/download; charset=UTF-8");
    }
    @Override
    protected void renderMergedOutputModel(Map<String, Object> model,
            HttpServletRequest req, HttpServletResponse res) throws Exception {
    	
    	Map<String, Object> allData = (Map) model.get("allData");
    	File file = (File) allData.get("downloadFile");
    	String originalFileName = (String) allData.get("originalName");

    	res.setContentType(getContentType());
        res.setContentLength((int) file.length());
        res.setHeader("Content-Disposition", "attachment; filename=\"" + java.net.URLEncoder.encode(originalFileName, "UTF-8") + "\";");
        res.setHeader("Content-Transfer-Encoding", "binary");
        
        OutputStream out = res.getOutputStream();
        FileInputStream fis = null;
        
        try {
            fis = new FileInputStream(file);
            FileCopyUtils.copy(fis, out);
        } catch (Exception e) {
            LOGGER.error("FileDownloadView ERROR : " + e.toString());
        } finally {
            if(fis != null) {
                try { 
                    fis.close();
                } catch (IOException e) {
                	LOGGER.error("FileDownloadView ERROR : " + e.toString());
                }
            }
        }
        out.flush();
    }
}