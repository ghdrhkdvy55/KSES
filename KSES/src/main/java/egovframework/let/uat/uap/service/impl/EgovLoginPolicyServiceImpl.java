package egovframework.let.uat.uap.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.com.cmm.service.Globals;
import egovframework.let.uat.uap.mapper.LoginPolicyMapper;
import egovframework.let.uat.uap.service.EgovLoginPolicyService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import egovframework.let.uat.uap.vo.LoginPolicy;
import egovframework.let.uat.uap.vo.LoginPolicyVO;
/**
 * 로그인정책에 대한 ServiceImpl 클래스를 정의한다.
 * 로그인정책에 대한 등록, 수정, 삭제, 조회, 반영확인 기능을 제공한다.
 * 로그인정책의 조회기능은 목록조회, 상세조회로 구분된다.
 * @author 공통서비스개발팀 lee.m.j
 * @since 2009.08.03
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.08.03  lee.m.j        최초 생성
 *   2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성
 *
 * </pre>
 */
@Service
public class EgovLoginPolicyServiceImpl extends EgovAbstractServiceImpl implements EgovLoginPolicyService {

    @Autowired
    private LoginPolicyMapper  loginPolicyMapper;
	/**
	 * 로그인정책 목록을 조회한다.
	 * @param loginPolicyVO - 로그인정책 VO
	 * @return List - 로그인정책 목록
	 */
	public List<Map<String, Object>> selectLoginPolicyList(LoginPolicyVO loginPolicyVO) throws Exception {
		return loginPolicyMapper.selectLoginPolicyList(loginPolicyVO);
	}

	/**
	 * 로그인정책 목록의 상세정보를 조회한다.
	 * @param loginPolicyVO - 로그인정책 VO
	 * @return LoginPolicyVO - 로그인정책 VO
	 */
	public LoginPolicyVO selectLoginPolicy(LoginPolicyVO loginPolicyVO) throws Exception {
		return loginPolicyMapper.selectLoginPolicy(loginPolicyVO);
	}

	/**
	 * 기 등록된 로그인정책 정보를 수정한다.
	 * @param loginPolicy - 로그인정책 model
	 */
	public int updateLoginPolicy(LoginPolicy loginPolicy) throws Exception {
		return loginPolicy.getMode().equals(Globals.SAVE_MODE_INSERT) ? loginPolicyMapper.insertLoginPolicy(loginPolicy) : loginPolicyMapper.updateLoginPolicy(loginPolicy);
	}

	/**
	 * 기 등록된 로그인정책 정보를 삭제한다.
	 * @param loginPolicy - 로그인정책 model
	 */
	public int deleteLoginPolicy(String adminId) throws Exception {
		return loginPolicyMapper.deleteLoginPolicy(adminId);
	}

	/**
	 * 로그인정책에 대한 현재 반영되어 있는 결과를 조회한다.
	 * @param loginPolicyVO - 로그인정책 VO
	 * @return LoginPolicyVO - 로그인정책 VO
	 */
	public LoginPolicyVO selectLoginPolicyResult(LoginPolicyVO loginPolicyVO) throws Exception {
		return loginPolicyMapper.selectLoginPolicyResult(loginPolicyVO);
	}

}
