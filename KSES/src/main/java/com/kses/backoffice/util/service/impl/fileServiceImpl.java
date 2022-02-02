package com.kses.backoffice.util.service.impl;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.kses.backoffice.util.service.fileService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service
public class fileServiceImpl extends EgovAbstractServiceImpl implements fileService{

	private static final Logger LOGGER = LoggerFactory.getLogger(fileServiceImpl.class);
	
	@Autowired
    protected EgovPropertyService propertiesService;
	
	
	public String modifyExtension(String extension){
	    	//기존
	    	//2019.12.10_JDH
	    	//이마트 부분과 달리 해당부분에서 IMAGE MEDIA부분을 구분 못할경우 reportGubun컬럼이 null값이 들어가 무결성위반 에러 발생
	    	String[] typeSplit = extension.split("\\.");
	    	String type = typeSplit[typeSplit.length -1];
	    	LOGGER.info("type : " + type);
	    	if("mp4".equals(type) || "avi".equals(type) || "mpeg".equals(type) || "webm".equals(type)) {
	    		extension = "MEDIA";
			} else if("jpg".equals(type) || "jpeg".equals(type) || "gif".equals(type) || "png".equals(type) || "bmp".equals(type)) {
				extension = "IMAGE";
			} else if("mp3".equals(type) || "wav".equals(type) || "mid".equals(type)) {
				extension = "MUSIC";
			} else {
				extension = "MUSIC";
			}
	    	return extension;
	} 
	
	public String fileSize(File f){
		  return f.exists() == true ?  Long.toString(f.length()) : "0"; 			
	}
	//파일 넓이 높이 변경 
	public Map getImageSize (File _fileNm){
		Map<String, String> map = new HashMap<String, String>();
		
		Metadata metadata = null;
		try {
			metadata = ImageMetadataReader.readMetadata(_fileNm);
		} catch (ImageProcessingException e) {
			LOGGER.error("getImageSize ImageProcessingException ERROR : " + e.toString());
		} catch (IOException e) {
			LOGGER.error("getImageSize IOException ERROR : " + e.toString());
		}  	  
	    for (Directory directory : metadata.getDirectories()) {
		    for (com.drew.metadata.Tag tag : directory.getTags()) {
		    	if (tag.getTagName().equals("Image Width") ){
		    		map.put("fileWidth", tag.getDescription());
		    		
		    	}
		    	if (tag.getTagName().equals("Image Height") ){
		    		map.put("fileHeight", tag.getDescription());
		    	}
		    	if (tag.getTagName().equals("File Size") ){
		    		map.put("fileSize", tag.getDescription().replace(" bytes", ""));
		    	}
		    }
	    }
	    return map;   
	}
	//파일 확장자 
	public String fileExt(File f, String _seq){
		return f.getName().lastIndexOf(_seq) != -1 ? f.getName().substring( f.getName().lastIndexOf(_seq) + 1) : "";
	}
	//파일 업로드 확인 
	public  String uploadFileNm(List<MultipartFile> mpf, String filePath){
		String fileNm = "";
		String ext = "";
		try {
			for (MultipartFile mFile : mpf) {
				
				String originalFilename = mFile.getOriginalFilename(); //파일명	   
	            
				if (!originalFilename.equals("")){
	            	String fileFullPath = filePath + "/" + originalFilename;
		        	File file_s =  new File(fileFullPath);	        	
		        	 
		     	    int dot = originalFilename.lastIndexOf(".");
		     	    if (dot != -1) {                              //확장자가 없을때	     	    
		     	      ext = originalFilename.substring(dot+1);
		     	    } else {                                     //확장자가 있을때	     	    
		     	      ext = "";
		     	    }		     	    
		     	    //fileNm = UUID.randomUUID().toString().replace("-", "") +"."+ ext;	     	  
		        	file_s = rename(file_s, originalFilename, filePath);
		        	mFile.transferTo(file_s);
					fileNm = file_s.getName();	
	            }
			}
		} catch (IllegalStateException e) {
			LOGGER.error("uploadFileNm IllegalStateException :" + e.toString());
		} catch (IOException e) {
			LOGGER.error("uploadFileNm IOException :" + e.toString());
		} catch (Exception ex){			
			LOGGER.error("uploadFileNm Exception :" + ex.toString());
		}        
		return fileNm;
	}
	
	//File f는 원본 파일
	public File rename(File f, String fileNm, String filedir) {             
	    String name = f.getName();
	    String body = null;
	    String ext = null;
	    
	    
	    int dot = name.lastIndexOf(".");
	    
	    if (dot != -1) { //확장자 있을떄 
		    body  = fileNm.substring(0, fileNm.lastIndexOf(".")) ;
		    ext = fileNm.substring(fileNm.lastIndexOf("."), fileNm.length());
	    } else {  //확장자가 없을떄      
	    	body = fileNm;
		    ext = "";
	    }	
	    int count = 0;
	    //중복된 파일이 있을때
	    //파일이름뒤에 a숫자.확장자 이렇게 들어가게 되는데 숫자는 9999까지 된다.
	    
	    if ( fileExites(body +ext, filedir) && count == 0   ) {
	    	  String newName = body + ext;
		      f = new File(f.getParent(), newName);
		      LOGGER.debug("파일이 없을때  filenm:"+ newName);
	    } else {	    
		    while (!createNewFile(f) && count < 9999) {  
		    	count++;
		    	String newName = body+ "_" + count + ext;
		    	LOGGER.debug("파일이 있을때  filenm:"+ newName);
		    	f = new File(f.getParent(), newName);
		    }
	    }
	    return f;
	}
 
	//존재하는 파일이 아니면 파일 생성
	private boolean createNewFile(File f) { 
	    try {
	      return f.createNewFile();                        
	    } catch (IOException ignored) {
	      return false;
	    }
	}	
	
	private boolean fileExites( String fileNm, String path){
		try {
			pathExist(path);
				
			File f = new File (path+"/"+fileNm);
			
			if (f.exists()){
				return false;
			} else {
				return true;
			}
		} catch (Exception e) {
			LOGGER.debug("fileExites Error:" + e.toString());
			return false;
		}
	}
	
	public boolean pathExist(String path){
		try {
			File dir = new File(path);
		    if(!dir.isDirectory())
			   dir.mkdir(); //폴더 생성합니다.
			
		    return true; 
		} catch(Exception e) {
			LOGGER.error("pathExist Error:" + e.toString());
			return false;
		}
	}
	
	//파일 삭제 
	public  boolean deleteFile (String fileNm ) {
	  	try {        	
	  		File delFile = new File ( fileNm);
	  		delFile.delete();
	  		return true;    		
	  	} catch(Exception e) {
	  		LOGGER.debug("file Delete error{0}", e.toString());
	  		return false;
	  	}    	
	}
	
	public boolean deleteFile (String fileNm, String path ) {
	  	try {        	
	  		pathExist(path);
	  		//path 먼저 확인 
	  		File delFile = new File ( fileNm);
	  		delFile.delete();
	  		return true;    		
	  	} catch(Exception e) {
	  		LOGGER.debug("file Delete error{0}", e.toString());
	  		return false;
	  	}    	
	}
	
	//시분초 변환 
	public String changeTime (String hour, String min, String sec){
		return (Integer.parseInt(hour)*3600 + Integer.parseInt(min)*60 + sec);
	}
	
	public String changeTime (String secound){
		int h =0, m =0, s=0;
		int sec = Integer.parseInt(secound);
		if (sec > 3600) {
			h = sec/3600;
			sec %=3600;
		}
		if (sec > 60){
			m = sec/60;
			sec %= 60;
		}
		if (sec < 60){
			s = sec;
		}
		return h+":"+m+":"+s;
	}
}