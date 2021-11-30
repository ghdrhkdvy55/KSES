package egovframework.com.cmm.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.mapper.FileManageManageMapper;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.FileVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class EgovFileMngServiceImpl extends EgovAbstractServiceImpl implements EgovFileMngService {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovFileMngServiceImpl.class);
	
	@Autowired
	private FileManageManageMapper fileMapper;
	
	@Override
	public List<Map<String, Object>> selectFileInfs(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return fileMapper.selectFileInfs(params);
	}

	@Override
	public String insertFileInf(FileVO fvo) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String insertFileInfs(List<FileVO> fvoList) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean deleteFileDetail(String streFileNm) throws Exception {
		// TODO Auto-generated method stub
		//중간 삭제 구문 넣기 
		try {
			fileMapper.deleteFileDetail(SmartUtil.dotToList(streFileNm));
			return true;
		}catch(Exception e) {
			LOGGER.error("deleteFileDetail  error:" + e.toString());
			return false;
		}
		
	}

	

}
