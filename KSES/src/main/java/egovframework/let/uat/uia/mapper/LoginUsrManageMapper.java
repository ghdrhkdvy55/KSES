package egovframework.let.uat.uia.mapper;

import egovframework.com.cmm.LoginVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface LoginUsrManageMapper {

    public LoginVO actionLogin(LoginVO vo) ;

}
