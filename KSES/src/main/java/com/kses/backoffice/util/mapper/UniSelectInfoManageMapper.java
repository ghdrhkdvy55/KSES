package  com.kses.backoffice.util.mapper;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import java.util.Map;
import org.apache.ibatis.annotations.Param;


@Mapper
public interface UniSelectInfoManageMapper {

	public String selectMaxValue(@Param("isColumn") String isColumn, @Param("isTable") String isTable);
	
	public int updateUniStatement(@Param("isColumn") String isColumn, @Param("isTable") String isTable, @Param("isCondition") String isCondition);
	
	public int deleteUniStatement(@Param("isTable") String isTable, @Param("isCondition") String isCondition);
	
	public int selectIdDoubleCheck(@Param("isColumn") String isColumn,@Param("isTable") String isTable,@Param("isCondition") String isCondition);
	
	public Map<String, Object> selectFieldStatement(@Param("isColumn") String isColumn,@Param("isTable") String isTable,@Param("isCondition") String isCondition);
}
