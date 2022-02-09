$.Billday = function() {};

$.Billday.prototype.mainGridSettings = function() {
    MainGridAjaxUrl = '/backoffice/bld/billDayInfoListAjax.do';
    EgovJqGridApi.mainGrid([
        { label: '요일코드', name: 'billday_cd', key: true, hidden: true },
        { label: '요일', name: 'bill_day_text', align: 'center', sortable: false },
        { label: '현금영수증시퀀스', name: 'bill_seq', hidden: true },
        { label: '발급구분', align: 'center', sortable: false, formatter: (c, o, row) => {
                let html = '<select data-rowid="'+ row.billday_cd +'">';
                html += '<option value="">사용안함</option>';
                for (let item of row.bill_info_list) {
                    html += (item.bill_seq === row.bill_seq)
                        ? '<option value="'+ item.bill_seq + '" selected>'+ item.bill_dvsn_text +'</option>'
                        : '<option value="'+ item.bill_seq + '">'+ item.bill_dvsn_text +'</option>';
                }
                html += '</select>';
                return html;
            }
        },
        { label: '법인명', name: 'bill_corp_name', align: 'center', sortable: false },
        { label: '사업자번호', name: 'bill_num', align: 'center', sortable: false },
    ], false, false, fnSearch, false).jqGrid('setGridParam', {
        cellEdit: true,
        cellsubmit: 'clientArray'
    });
    $('#rightAreaBtn').show();
};

$.Billday.prototype.updateSettings = function(ajaxUpdate, changedArr) {
    ajaxUpdate.title = '현금영수증(요일) 수정';
    ajaxUpdate.url = '/backoffice/bld/billDayInfoUpdate.do';
    changedArr.forEach(x => ajaxUpdate.params.push({
        billdayCd: x.billday_cd,
        billSeq: x.bill_seq
    }));
};

$.Billday.prototype.changedArray = function() {
    let ret = [];
    $.each($('#mainGrid select[data-rowid]'), function(i, item) {
        let rowId = $(this).data('rowid');
        let rowData = $('#mainGrid').jqGrid('getRowData', rowId);
        if (rowData.bill_seq !== $(item).val()) {
            rowData.bill_seq = $(item).val();
            ret.push(rowData);
        }
    });
    return ret;
};

const Billday = new $.Billday();