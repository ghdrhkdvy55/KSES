package egovframework.let.uat.uia.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
//import egovframework.let.ems.service.EgovSndngMailRegistService;
//import egovframework.let.ems.service.SndngMailVO;

import egovframework.com.cmm.LoginVO;
import egovframework.let.uat.uia.mapper.LoginUsrManageMapper;
import egovframework.let.uat.uia.service.EgovLoginService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 일반 로그인, 인증서 로그인을 처리하는 비즈니스 구현 클래스
 * @author 공통서비스 개발팀 박지욱
 * @since 2009.03.06
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2009.03.06  박지욱          최초 생성
 *  2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성
 *
 *  </pre>
 */
@Service
public class EgovLoginServiceImpl extends EgovAbstractServiceImpl implements EgovLoginService {

    
    @Autowired
    private LoginUsrManageMapper loginUsrManageMapper;

    ///** EgovSndngMailRegistService */
	//@Resource(name = "sndngMailRegistService")
    //private EgovSndngMailRegistService sndngMailRegistService;

    /**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    @Override
	public LoginVO actionLogin(LoginVO vo) throws Exception {
    	// 1. 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
    	LoginVO loginVO = loginUsrManageMapper.actionLogin(vo);
    	// 2. 결과를 리턴한다.
    	if (loginVO != null && !loginVO.getAdminId().equals("") && !loginVO.getAdminPwd().equals("")) {
    		return loginVO;
    	} else {
    		loginVO = new LoginVO();
    	}

    	return loginVO;
    }
}