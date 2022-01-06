package com.kses.backoffice.util.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.mapper.UniSelectInfoManageMapper;
import com.kses.backoffice.util.service.UniSelectInfoManageService;
import com.kses.backoffice.util.service.fileService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;


@Service
public class UniSelectInfoManageServiceImpl extends EgovAbstractServiceImpl implements UniSelectInfoManageService {
	
	
	@Autowired
	private UniSelectInfoManageMapper uniMapper;

	
	@Autowired
	private SmartUtil util;
	
	@Autowired
	private fileService fileservice;
	
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Override
	public String selectMaxValue(String is_Column, String is_Table) throws Exception {
		return uniMapper.selectMaxValue(is_Column, is_Table);
	}

	@SuppressWarnings("unchecked")
	@Override
	public int deleteUniStatement(String is_Column, String is_Table, String is_condition) throws Exception {
		//파일 체크 해서 파일 삭제 하기
		try {
			if (!is_Column.equals("")) {
			Map<String, Object> fileInfo = uniMapper.selectFieldStatement(is_Column, is_Table, is_condition);
				if (fileInfo != null ) {
					List column = util.dotToList(is_Column);
						column.forEach(target->{
						if (fileInfo.get(target)!= null)
						try {
							fileservice.deleteFile(fileInfo.get(target).toString(), propertiesService.getString("Globals.filePath"));
						} catch (Exception e) {
						e.printStackTrace();
							}
					
						});
					}
				}
				//체크 하기
				uniMapper.deleteUniStatement(is_Table, is_condition);
			} catch(Exception e) {
			return 0;
		}
		return 1;
	}

	
	@Override
	public int selectIdDoubleCheck(String is_Column, String is_Table, String is_condition) throws Exception {
		return uniMapper.selectIdDoubleCheck(is_Column, is_Table, is_condition);
	}

	@Override
	public Map<String, Object> selectFieldStatement(String is_Column, String is_Table, String is_condition) throws Exception {
		return uniMapper.selectFieldStatement(is_Column, is_Table, is_condition);
	}

	@Override
	public int updateUniStatement(String isColumn, String isTable, String isCondition) {
		return uniMapper.updateUniStatement(isColumn, isTable, isCondition);
	}


}
