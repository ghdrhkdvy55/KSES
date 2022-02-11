package com.kses.backoffice.util.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

public interface fileService {

	
	// 파일 확장자 변환
	String modifyExtension(String extension)throws Exception;
	//파일 사이즈 
	String fileSize(File f)throws Exception;
	//이미지 사이즈 변경
	Map getImageSize (File _fileNm)throws Exception;
	//파일 확장자 
    String fileExt(File f, String _seq)throws Exception;
    //파일 업로드 확인 
  	String uploadFileNm(List<MultipartFile> mpf, String filePath)throws Exception;

	  String uploadFileNm(MultipartFile multipartFile, String filePath) throws Exception;
	//파일 이름 변경(중복 검사)
  	File rename(File f, String fileNm, String filedir)throws Exception;
  	//디렉토리 확인
  	boolean pathExist(String path)throws Exception;
  	//파일 삭제
  	boolean deleteFile (String fileNm )throws Exception;
  	//파일 삭제
  	boolean deleteFile (String fileNm, String path )throws Exception;
  	//시분초 변환 
  	String changeTime (String hour, String min, String sec)throws Exception;
  	//초를 시간으로
  	String changeTime (String secound)throws Exception;
}
