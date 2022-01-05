package com.kses.backoffice.sts.content.service.impl;


import java.util.List;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.sts.content.mapper.ContentFileManagerMapper;
import com.kses.backoffice.sts.content.service.ContentFileInfoManageService;
import com.kses.backoffice.sts.content.vo.ContentFileInfo;
import com.kses.backoffice.sts.content.vo.ContentFileInfoVO;



@Service
public abstract class ContentFileInfoManageServiceImpl extends EgovAbstractServiceImpl implements ContentFileInfoManageService {

	@Autowired
	private ContentFileManagerMapper conFileManager;

	@Override
	public List<ContentFileInfoVO> selectFilePageListByPagination(ContentFileInfoVO searchVO) throws Exception {
		return conFileManager.selectFilePageListByPagination(searchVO);
	}

	@Override
	public int selectFilePageListByPaginationTotCnt_S(ContentFileInfoVO searchVO)
			throws Exception {
		return conFileManager.selectFilePageListByPaginationTotCnt_S(searchVO);
	}

	@Override
	public int selectFileListTotCnt_S(String conSeq) throws Exception {
		return conFileManager.selectFileListTotCnt_S(conSeq);
	}

	@Override
	public ContentFileInfoVO selectFileDetail(String atchFileId)
			throws Exception {
		return conFileManager.selectFileDetail(atchFileId);
	}

	@Override
	public int insertFileManage(ContentFileInfo vo) throws Exception {
		return conFileManager.insertFileManage(vo);
	}

	@Override
	public int updateFileManage(ContentFileInfo vo) throws Exception {
		return conFileManager.updateFileManage(vo);
	}

	@Override
	public int updateFileManageUseYn(ContentFileInfo vo) throws Exception {
		return conFileManager.updateFileManageUseYn(vo);
	}

	@Override
	public int deleteFileManage(String atchFileId) throws Exception {
		return conFileManager.deleteFileManage(atchFileId);
	}

	
	
}
