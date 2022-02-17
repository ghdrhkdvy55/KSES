<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="pop_con">
    <a class="button b-close">X</a>
    <h2 class="pop_tit">구역정보 수정</h2>
    <div class="pop_wrap">
        <form>
        <input type="hidden" name="mode">
        <input type="hidden" name="partCd">
        <table class="detail_table">
            <tbody>
                <tr>
                    <th>층이름</th>
                    <td><input type="text" name="floorNm"></td>
                </tr>
            </tbody>
        </table>
        </form>
    </div>
    <popup-right-button />
</div>
<script type="text/javascript">

</script>