package egovframework.com.cmm.exception;

public class CustomerExcetion extends Exception {

	private static final long serialVersionUID = 1L;
	
	public CustomerExcetion(){
		
	}
	public CustomerExcetion(String Message){
		super(Message);
	}
	public CustomerExcetion(String message, Throwable cause) {
		super(message, cause);
	}
}
