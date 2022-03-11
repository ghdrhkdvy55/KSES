package egovframework.com.cmm.service;

/**
 *  Class Name : Globals.java
 *  Description : 시스템 구동 시 프로퍼티를 통해 사용될 전역변수를 정의한다.
 *  Modification Information
 * 
 *     수정일         수정자                   수정내용
 *   -------    --------    ---------------------------
 *   2009.01.19    박지욱          최초 생성
 *
 *  @author 공통 서비스 개발팀 박지욱
 *  @since 2009. 01. 19
 *  @version 1.0
 *  @see 
 * 
 */

public class Globals {
    
	//OS 유형
    public static final String OS_TYPE = EgovProperties.getProperty("Globals.OsType");
    //DB 유형
    public static final String DB_TYPE = EgovProperties.getProperty("Globals.DbType");
    //메인 페이지
    public static final String MAIN_PAGE = EgovProperties.getProperty("Globals.MainPage");
    //ShellFile 경로
    public static final String SHELL_FILE_PATH = EgovProperties.getPathProperty("Globals.ShellFilePath");
    //퍼로퍼티 파일 위치
    public static final String CONF_PATH = EgovProperties.getPathProperty("Globals.ConfPath");
    //Server정보 프로퍼티 위치
    public static final String SERVER_CONF_PATH = EgovProperties.getPathProperty("Globals.ServerConfPath");
    //Client정보 프로퍼티 위치
    public static final String CLIENT_CONF_PATH = EgovProperties.getPathProperty("Globals.ClientConfPath");
    //파일포맷 정보 프로퍼티 위치
    public static final String FILE_FORMAT_PATH = EgovProperties.getPathProperty("Globals.FileFormatPath");
    
    //파일 업로드 원 파일명
	public static final String ORIGIN_FILE_NM = "originalFileName";
	//파일 확장자
	public static final String FILE_EXT = "fileExtension";
	//파일크기
	public static final String FILE_SIZE = "fileSize";
	//업로드된 파일명
	public static final String UPLOAD_FILE_NM = "uploadFileName";
	//파일경로
	public static final String FILE_PATH =   "filePath";
	
	//메일발송요청 XML파일경로
	public static final String MAIL_REQUEST_PATH = EgovProperties.getPathProperty("Globals.MailRequestPath");
	//메일발송응답 XML파일경로
	public static final String MAIL_RESPONSE_PATH = EgovProperties.getPathProperty("Globals.MailRResponsePath");

	// G4C 연결용 IP (localhost)
	public static final String LOCAL_IP = EgovProperties.getProperty("Globals.LocalIp");

	public static final String CENTER_CODE = "C18033001";
	
	public static final String STATUS_USERINFO = "userinfo";
	public static final String STATUS_COMINFO = "cominfo";
	
	public static final String STATUS_REGINFO = "regist";
	public static final String STATUS_MYPAGE = "MYPAGE";
	public static final String REGITER_SYSTEM = "SYSTEM";
	public static final String PAGE_TOTALCNT = "totalCnt";
	public static final String SESSION_USER = "LoginUserVO";
	public static final String STATUS = "status";
	public static final String STATUS_MESSAGE = "message";
	public static final String STATUS_SUCCESS = "SUCCESS";
	public static final String STATUS_OK = "OK";
	public static final String STATUS_FAIL = "FAIL";
	public static final String STATUS_FAILLACK = "FAILLACK";
	
	public static final String STATUS_UNIQUE = "UNIQUE";
	public static final String STATUS_NTUNIQUE = "UNIQUE FAIL";
	public static final String STATUS_LOGINFAIL = "LOGIN FAIL";
	public static final String STATUS_OVERLAPFAIL = "OVERLAP FAIL";
	public static final String STATUS_SESSIONFAIL = "SESSION FAIL";
	public static final String STATUS_REFERRERFAIL = "REFERRER FAIL";
	
	public static final String JSONVIEW = "jsonView";
	public static final String JSON_RESULT_COMMAND = "command_type";
	public static final String JSON_RESULT_COMMAND_ERROR = "error_command";
	public static final String JSON_RESULT_DATA = "command_data";
	public static final String JSON_RESULT_DATAERROR = "error_data";
	public static final String JSON_RESULT = "json_res";
	public static final String JSON_RESULT_TOP = "model";
	public static final String JSON_RETURN_RESULT = "result";
	public static final String JSON_RETURN_RESULTLISR = "resultlist";
	public static final String JSON_PAGEINFO = "paginationInfo";
	
	public static final String JSON_RETURN_CONFIGE = "CONINFO";
	public static final String JSON_RETURN_MESSAGEKEY = "MESSAGEINFO";
	
	public static final String PAGE_SIZE = "pageSize";
	public static final String PAGE_UNIT = "pageUnit";
	public static final String PROCESS_STATE_NO = "NO_UPDATE";
	
	public static final String LOGIN_CONNECT_MTHD_I = "I"; // 로그인
	public static final String LOGIN_CONNECT_MTHD_O = "O"; // 로그아웃

	public static final String SAVE_MODE_INSERT = "Ins";
	public static final String SYSLOG_PROCESS_SE_CODE_INSERT = "I";
	public static final String SAVE_MODE_UPDATE = "Edt";
	public static final String SYSLOG_PROCESS_SE_CODE_UPDATE = "U";
	public static final String SYSLOG_PROCESS_SE_CODE_DELETE = "D";
	public static final String SYSLOG_PROCESS_SE_CODE_SELECT = "S";

	public static final String STEP = "step";
	public static final String JSON_NO_KEY = "NO_KEY";
	
	public static final String SMS_TYPE_RESV = "RESV";
	public static final String SMS_TYPE_AUTO_RESV = "AUTORESV";
	public static final String SMS_TYPE_CANCEL = "CANCEL";
}