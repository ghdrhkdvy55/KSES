package com.kses.backoffice.bas.progrm.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.kses.backoffice.bas.progrm.mapper.ProgrameChangeManageMapper;
import com.kses.backoffice.bas.progrm.service.ProgrameChangeManageService;
import com.kses.backoffice.bas.progrm.vo.ProgrameChangeInfo;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class ProgrameChangeManageServiceImpl extends EgovAbstractServiceImpl implements ProgrameChangeManageService{

	
	@Autowired
	private ProgrameChangeManageMapper programChnageMapper;
	
	@Override
	public Map<String, Object> selectProgrmChangeRequst(Map<String, Object> vo) throws Exception {
		return programChnageMapper.selectProgrmChangeRequst(vo);
	}

	@Override
	public List<Map<String, Object>> selectProgrmChangeRequstList(Map<String, Object> params) throws Exception {
		return programChnageMapper.selectProgrmChangeRequstList(params);
	}

	@Override
	public int updateProgrmChangeRequst(ProgrameChangeInfo vo) throws Exception {
		return (vo.getMode().equals("Ins")) ? programChnageMapper.insertProgrmChangeRequst(vo) : programChnageMapper.updateProgrmChangeRequst(vo);
		
	}

	@Override
	public void deleteProgrmChangeRequst(ProgrameChangeInfo vo) throws Exception {
		programChnageMapper.deleteProgrmChangeRequst(vo);
	}

	@Override
	public String selectProgrmChangeRequstNo() throws Exception {
		return programChnageMapper.selectProgrmChangeRequstNo();
	}

	@Override
	public List<Map<String, Object>> selectChangeRequstProcessList(Map<String, Object> params) throws Exception {
		return programChnageMapper.selectChangeRequstProcessList(params);
	}

	@Override
	public int updateProgrmChangeRequstProcess(ProgrameChangeInfo vo) throws Exception {
		return programChnageMapper.updateProgrmChangeRequstProcess(vo);
	}

	

}
