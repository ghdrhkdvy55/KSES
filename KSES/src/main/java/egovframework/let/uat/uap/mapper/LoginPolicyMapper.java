package egovframework.let.uat.uap.mapper;

import java.util.List;
import java.util.Map;
import egovframework.let.uat.uap.vo.LoginPolicy;
import egovframework.let.uat.uap.vo.LoginPolicyVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface LoginPolicyMapper {

	/**
	 * 로그인정책 목록을 조회한다.
	 * @param loginPolicyVO - 로그인정책 VO
	 * @return List - 로그인정책 목록
	 */
	public List<Map<String, Object>> selectLoginPolicyList(LoginPolicyVO loginPolicyVO);

	/**
	 * 로그인정책 목록 수를 조회한다.
	 * @param loginPolicyVO - 로그인정책 VO
	 * @return int
	 */
	/**
	 * 로그인정책 목록의 상세정보를 조회한다.
	 * @param loginPolicyVO - 로그인정책 VO
	 * @return LoginPolicyVO - 로그인정책 VO
	 */
	public LoginPolicyVO selectLoginPolicy(LoginPolicyVO loginPolicyVO);

	/**
	 * 로그인정책 정보를 신규로 등록한다.
	 * @param loginPolicy - 로그인정책 model
	 */
	public int insertLoginPolicy(LoginPolicy loginPolicy);

	/**
	 * 기 등록된 로그인정책 정보를 수정한다.
	 * @param loginPolicy - 로그인정책 model
	 */
	public int updateLoginPolicy(LoginPolicy loginPolicy);

	/**
	 * 기 등록된 로그인정책 정보를 삭제한다.
	 * @param loginPolicy - 로그인정책 model
	 */
	public int deleteLoginPolicy(String adminId);

	/**
	 * 로그인정책에 대한 현재 반영되어 있는 결과를 조회한다.
	 * @param loginPolicyVO - 로그인정책 VO
	 * @return LoginPolicyVO - 로그인정책 VO
	 */
	public LoginPolicyVO selectLoginPolicyResult(LoginPolicyVO loginPolicyVO);
}
