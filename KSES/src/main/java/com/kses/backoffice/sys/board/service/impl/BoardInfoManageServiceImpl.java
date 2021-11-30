package com.kses.backoffice.sys.board.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.com.cmm.mapper.FileManageManageMapper;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.FileVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.sys.board.mapper.BoardInfoManageMapper;
import com.kses.backoffice.sys.board.service.BoardInfoManageService;
import com.kses.backoffice.sys.board.vo.BoardInfo;
import com.kses.backoffice.util.service.UniSelectInfoManageService;

@Service
public class BoardInfoManageServiceImpl extends EgovAbstractServiceImpl implements BoardInfoManageService {
	
	@Autowired
	private BoardInfoManageMapper boardMapper;
	
	@Autowired
	private FileManageManageMapper fileMapper;
	@Autowired
	private EgovFileMngService egocFileService;

    @Autowired
	private UniSelectInfoManageService uniService;
    
	@Override
	public List<Map<String, Object>> selectBoardManageListByPagination(Map<String, Object> SearchVO) throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.selectBoardManageListByPagination(SearchVO);
	}
	
	@Override
	public List<Map<String, Object>> selectBoardMainManageListByPagination()
			throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.selectBoardMainManageListByPagination();
	}

	
	@Override
	public Map<String, Object> selectBoardManageDetail(String boardSeq) throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.selectBoardManageDetail(boardSeq);
	}
	
	@Override
	public int updateBoardManage(BoardInfo vo, List<FileVO> result) throws Exception {
		// TODO Auto-generated method stub
		int ret  =0;
		switch (vo.getMode()) {
		   case "Ins" :
			   ret = boardMapper.insertBoardManage(vo);
			   break;
		   case "Edt" : 
			   ret = boardMapper.updateBoardManage(vo);
			   break;
		   case "Ref" : 
			   ret = boardMapper.insertBoardManage(vo);
			   break;
		}
		if (result != null) {
			result.forEach(x -> {
				x.setFileGubun("BBS");
				x.setFileSeq(vo.getBoardSeq());
			});
			fileMapper.insertFileInfs(result);
			
		}
		return ret;
	}

	@Override
	public int deleteBoardManage(String boardSeq) throws Exception {
		// TODO Auto-generated method stub
		//
		//파일 삭제
		Map<String, Object> search = new HashMap<String, Object>();
	    search.put("fileGubun", "BBS");
	    search.put("fileSeq",boardSeq);
		List<Map<String, Object>> fileLst = egocFileService.selectFileInfs(search);
		if (fileLst.size() > 0) {
			for (Map<String, Object> fileInfo : fileLst) {
				uniService.deleteUniStatement("STRE_FILE_NM", "COMTNFILEDETAIL", "STRE_FILE_NM=["+fileInfo.get("stre_file_nm")+"[");
			}
		}
		//코멘트 삭제
		
		
		return boardMapper.deleteBoardManage(boardSeq);
	}

	@Override
	public int updateBoardVisitedManage(String boardSeq) throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.updateBoardVisitedManage(boardSeq);
	}

	@Override
	public int updateBoardTopSeq() throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.updateBoardTopSeq();
	}

}