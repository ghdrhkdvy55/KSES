package com.kses.backoffice.sts.content.mapper;

import java.util.List;

import com.kses.backoffice.sts.content.vo.ContentFileInfo;
import com.kses.backoffice.sts.content.vo.ContentFileInfoVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper
public interface ContentFileManagerMapper {

	public List<ContentFileInfoVO> selectFilePageListByPagination (ContentFileInfoVO  searchVO);
		
	public int selectFilePageListByPaginationTotCnt_S (ContentFileInfoVO  searchVO);
	
	public int selectFileListTotCnt_S  (String conSeq);
	
	public ContentFileInfoVO selectFileDetail (String atchFileId);
	
	public int insertFileManage(ContentFileInfo vo);
	
	public int updateFileManage(ContentFileInfo vo);
	
	public int updateFileManageUseYn(ContentFileInfo vo);
		
	public int deleteFileManage(String atchFileId);
	
}
