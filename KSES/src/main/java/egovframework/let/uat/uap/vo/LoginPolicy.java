package egovframework.let.uat.uap.vo;

import egovframework.com.cmm.ComDefaultVO;
import lombok.Getter;
import lombok.Setter;

/**
 * 로그인정책에 대한 model 클래스를 정의한다.
 * 로그인정책정보의 사용자ID, IP정보, 중복허용여부, 제한여부 항목을 관리한다.
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
@Getter
@Setter
public class LoginPolicy extends ComDefaultVO {

    /**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = 1L;
    /**
	 * 사용자 ID
	 */	
	private String emplyrId;
    /**
	 * 사용자 명
	 */	
	private String emplyrNm;	
    /**
	 * 사용자 구분
	 */	
	private String emplyrSe;		
    /**
	 * IP정보
	 */	
    private String ipInfo;
    /**
	 * 중복허용여부
	 */	
    private String dplctPermAt;
    /**
	 * 제한여부
	 */	
    private String lmttAt;
    /**
	 * 등록자 ID
	 */	
    private String userId;
    /**
	 * 등록일시
	 */	
    private String regDate;
    /**
	 * 등록여부
	 */	
    private String regYn;
	private String mode;
}
