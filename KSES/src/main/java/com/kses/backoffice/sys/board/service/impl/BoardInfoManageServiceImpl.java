package com.kses.backoffice.sys.board.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.com.cmm.mapper.FileManageManageMapper;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.FileVO;
import egovframework.com.cmm.service.Globals;
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
		return boardMapper.selectBoardManageListByPagination(SearchVO);
	}
	
	@Override
	public List<Map<String, Object>> selectBoardMainManageListByPagination()
			throws Exception {
		return boardMapper.selectBoardMainManageListByPagination();
	}

	
	@Override
	public Map<String, Object> selectBoardManageDetail(String boardSeq) throws Exception {
		return boardMapper.selectBoardManageDetail(boardSeq);
	}
	
	@Override
	public int insertBoardManage(BoardInfo vo, List<FileVO> result) throws Exception {
		if (result != null) {
			result.forEach(x -> {
				x.setFileGubun("BBS");
				x.setFileSeq(vo.getBoardSeq());
			});
			fileMapper.insertFileInfs(result);
		}
		return boardMapper.insertBoardManage(vo);
	}
	
	@Override
	public int updateBoardManage(BoardInfo vo, List<FileVO> result) throws Exception {
		if (result != null) {
			result.forEach(x -> {
				x.setFileGubun("BBS");
				x.setFileSeq(vo.getBoardSeq());
			});
			fileMapper.insertFileInfs(result);
		}
		return boardMapper.updateBoardManage(vo);
	}

	@Override
	public int deleteBoardManage(String boardSeq) throws Exception {
		Map<String, Object> search = new HashMap<String, Object>();
	    search.put("fileGubun", "BBS");
	    search.put("fileSeq",boardSeq);
		List<Map<String, Object>> fileLst = egocFileService.selectFileInfs(search);
		if (fileLst.size() > 0) {
			for (Map<String, Object> fileInfo : fileLst) {
				uniService.deleteUniStatement("STRE_FILE_NM", "COMTNFILEDETAIL", "STRE_FILE_NM=["+fileInfo.get("stre_file_nm")+"[");
			}
		}
		
		return boardMapper.deleteBoardManage(boardSeq);
	}

	@Override
	public int updateBoardVisitedManage(String boardSeq) throws Exception {
		return boardMapper.updateBoardVisitedManage(boardSeq);
	}

	@Override
	public int updateBoardTopSeq() throws Exception {
		return boardMapper.updateBoardTopSeq();
	}

	@Override
	public String selectBoardoriginalFileName(String atchFileId) {
		return boardMapper.selectBoardoriginalFileName(atchFileId);
	}
	
	@Override
	public String selectBoardUploadFileName(String atchFileId) {
		return boardMapper.selectBoardUploadFileName(atchFileId);
	}
}