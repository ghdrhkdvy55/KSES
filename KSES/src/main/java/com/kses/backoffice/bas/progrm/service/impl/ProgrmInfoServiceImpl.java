package com.kses.backoffice.bas.progrm.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bas.progrm.mapper.ProgrmInfoManageMapper;
import com.kses.backoffice.bas.progrm.service.ProgrmInfoService;
import com.kses.backoffice.bas.progrm.vo.ProgrmInfo;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.mapper.UniSelectInfoManageMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class ProgrmInfoServiceImpl extends EgovAbstractServiceImpl implements ProgrmInfoService{
	
	@Autowired
	private ProgrmInfoManageMapper progrmMapper;
	
	@Autowired
	private UniSelectInfoManageMapper uniMapper;
	
	@Override
	public List<Map<String, Object>> selectProgrmInfoList(Map<String, Object> params) throws Exception {
		return progrmMapper.selectProgrmInfoList(params);
	}

	@Override
	public Map<String, Object> selectProgrmInfoDetail(String progrmFileNm) throws Exception {
		return progrmMapper.selectProgrmInfoDetail(progrmFileNm);
	}
	
	@Override
	public int updateProgrmInfo(ProgrmInfo vo) throws Exception {
		int ret = 0;
		
		if (vo.getMode().equals("Ins")){
			ret = (uniMapper.selectIdDoubleCheck("PROGRM_FILE_NM", "COMTNPROGRMLIST", "PROGRM_FILE_NM = ["+ vo.getProgrmFileNm() + "[" ) > 0) ? -1 :  progrmMapper.insertProgrmInfo(vo);
		} else {
			ret = progrmMapper.updateProgrmInfo(vo);
		}
		return ret;
	}

	@Override
	public int deleteProgrmInfo(String progrmFileNm) throws Exception {
		return progrmMapper.deleteProgrmInfo(progrmFileNm);
	}

	@Override
	public int deleteProgrmManageList(String checkedProgrmFileNmForDel) throws Exception {
		List<String> programFiles = SmartUtil.dotToList(checkedProgrmFileNmForDel);
		return progrmMapper.deleteProgrmManageList(programFiles);
	}

}