package egovframework.com.cmm;

import java.io.Serializable;
import lombok.Getter;
import lombok.Setter;

/**
 * @Class Name : LoginVO.java
 * @Description : Login VO class
 * @Modification Information
 * @
 * @  수정일         수정자                   수정내용
 * @ -------    --------    ---------------------------
 * @ 2009.03.03    박지욱          최초 생성
 *
 *  @author 공통서비스 개발팀 박지욱
 *  @since 2009.03.03
 *  @version 1.0
 *  @see
 *  
 */
@Getter
@Setter
public class LoginVO implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -8274004534207618049L;	
	
	private String adminId ;
	private String adminPwd ;
	private String authorCd; 
	private String empNo;
	private String empNm; 
	private String adminPassUpdtDt;
	private String adminLockyn;
	private String deptNm;
	private String gradNm; 
	private String psitNm; 
	private String useYn;
	private String empClphn; 
	private String empTlphn; 
	private String empEmail; 
	private String empState; 
	private String empPic;
	private String ip;
	private String centerCd = "";
	
	
	
	
}
