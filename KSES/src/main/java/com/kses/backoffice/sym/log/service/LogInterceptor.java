package com.kses.backoffice.sym.log.service;

import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Plugin;
import org.apache.ibatis.plugin.Signature;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;

import com.kses.backoffice.sym.log.vo.SysLog;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

//@Intercepts({@Signature(type=StatementHandler.class, method="update", args={Statement.class})})

@Intercepts(@Signature(
			type=Executor.class, 
			method="query", 
			args= {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class}))
public class LogInterceptor implements Interceptor{

	
	@Resource(name="EgovSysLogService")
	private EgovSysLogService sysLogService;
	
	
	
	/*public static Map<String, Object> toMap(JSONObject object) throws  JSONException {

	       if(object==null)return null;   
	       Map<String, Object> map = new HashMap<String, Object>();	        
	       Iterator<String> keysItr = object.keys();
	       while(keysItr.hasNext()) {
	       String key = keysItr.next();
	       Object value = object.get(key);

	       if(value instanceof JSONArray) {
	           value = toList((JSONArray) value);
	       }

	       else if(value instanceof JSONObject) {
	           value = toMap((JSONObject) value);
	       }
	       if(null != value)
	          map.put(key, value);
	       if(null==value || value.toString().equalsIgnoreCase("NULL") || "" == value) {
	           object.remove(key);
	       }
	      }
	    return map;
	}
	
	
	public static List<Object> toList(JSONArray array) throws JSONException {
	       List<Object> list = new ArrayList<Object>();
	       
	       
	       for(int i = 0; i < array.length(); i++) {
	           Object value = array.get(i);
	           
	           
	           if(value instanceof JSONArray) {
	               value = toList((JSONArray) value);
	           }

	           else if(value instanceof JSONObject) {
	               value = toMap((JSONObject) value);
	           }
	           list.add(value);
	       }
	       return list;
	}*/
	/*private Object handleArray(JsonArray json, JsonDeserializationContext context) {
	    Object[] array = new Object[json.size()];
	    for(int i = 0; i < array.length; i++)
	      array[i] = context.deserialize(json.get(i), Object.class);
	    return array;
	  }
	  private Object handleObject(JsonObject json, JsonDeserializationContext context) {
	    Map<String, Object> map = new HashMap<String, Object>();
	    for(Map.Entry<String, JsonElement> entry : json.entrySet())
	      map.put(entry.getKey(), context.deserialize(entry.getValue(), Object.class));
	    return map;
	  }*/
	/*@SuppressWarnings("unchecked") 
	@Override 
	public Object intercept(Invocation invocation) throws Throwable { 
		Object[] args = invocation.getArgs(); 
		MappedStatement ms = (MappedStatement) args[0]; 
		Map<String, String> params = (Map<String, String>) args[1]; 
		BoundSql boundSql = ms.getBoundSql(params); 
		StringBuilder sql = new StringBuilder(boundSql.getSql()); 
		for (ParameterMapping param : boundSql.getParameterMappings()) { 
			String property = param.getProperty(); 
			int index = sql.indexOf("?"); 
			sql.replace(index, index + 1, "'" + params.get(property) + "'"); 
		} 
		Object proceed = invocation.proceed(); 
		LOGGER.info("{} ==> Preparing: {}", ms.getId(), sql.toString()); 
		if (proceed != null && proceed instanceof List) { 
			List<Map<String, String>> list = (List<Map<String, String>>) proceed; 
			if (list.size() > 0) { 
				LOGGER.info("{} ==> Result: {}", ms.getId(), list.get(0)); 
				for (Entry<String, String> entry : list.get(0).entrySet()) { 
				 *  String key = entry.getKey(); 
				 *  String value = ((Object) entry.getValue()).toString(); } 
			} 
			LOGGER.info("{} <== Total: {}", ms.getId(), list.size()); 
		} 
		return proceed; 
	}*/
	
	
	
	

	@Override
	public Object intercept(Invocation invocation) throws Throwable {
		
		/*for (int i =0; i < invocation.getArgs().length; i ++){
			if (invocation.getArgs()[i] != null)
			System.err.println("length : \n" + invocation.getArgs()[i].toString());
		}*/
        //QueryId
		String queryID = ((MappedStatement)invocation.getArgs()[0]).getId();
		
        //Query Parameter
		Object param = invocation.getArgs()[1];
		
		//Query String
        String queryString = ((MappedStatement)invocation.getArgs()[0]).getBoundSql(param).getSql();
		
		String uniqId = "";
		String ip = "";
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if(isAuthenticated.booleanValue()) {
			LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			uniqId = user.getAdminId();// .getUniqId();
			ip = user.getIp();
			
    	}
		
		SysLog sysLog = new SysLog();
		
		sysLog.setSrvcNm(queryID);
		sysLog.setMethodNm(queryID.substring(queryID.lastIndexOf(".")+1) );
		sysLog.setProcessSeCode("N");
		
		sysLog.setSqlParam(ParamToJson.paramToJson(param));
		sysLog.setSqlQuery(queryString);
		
		/*try{
			sysLogService.insertTest(sysLog);
		}catch(Exception e){
			LOGGER.debug("ERROR:"+ e.toString());
		}*/
		
		return invocation.proceed();
	}

	@Override
	public Object plugin(Object target) {
		return Plugin.wrap(target, this);
	}

	@Override
	public void setProperties(Properties properties) {
	}
    
}