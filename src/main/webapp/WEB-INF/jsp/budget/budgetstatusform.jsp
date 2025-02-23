<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">

    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>

    <!-- validate -->

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/assets/plugins/jquery.validate.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/assets/plugins/functionValidate.js"></script>
    <style type="text/css">
        input.error, text.error {
            border: 2px solid #FD7D86;
        }

        label.error {
            color: #FD7D86;
            font-weight: 400;
            font-size: 0.75em;
            margin-top: 7px;
            margin-left: 6px;
            margin-right: 6px;
        }

        .btnsize {
            width: 80px;
            height: 30px;
            font-size: 0.8em;
            font-align: center;
            color: black;
        }

        .btnsize2 {
            width: 60px;
            height: 30px;
            font-size: 0.9em;
            color: black;
        }

        .modal-dialog.workplce {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
        }
    </style>
    <script>
        $(document).ready(function () {
            $('input:button').hover(function () {
                $(this).css("background-color", "#D8D8D8");
            }, function () {
                $(this).css("background-color", "");
            });

            createAccountPeriod();
            $("#searchPeriod").click(showAccountPeriod);

            createWorkplace();
            $("#searchWorkplace").click(showWorkplace);

            createDepartment();

            createParentBudget();
            createDetailBudget();

            //input에 이벤트 달기


        });

        var dataSet = {
            "deptCode"        : "",
            "workplaceCode"   : "",
            "accountInnerCode": "",
            "accountPeriodNo" : 0
        };


        function createAccountPeriod() {
            rowData = [];
            var columnDefs = [
                {
                    headerName: "회계기수", hide: "true", field: "accountPeriodNo", sort: "asc", width: 100
                },
                {
                    headerName: "회계연도", field: "fiscalYear", sort: "asc", width: 100
                },
                {headerName: "회계시작일", field: "periodStartDate", width: 250},
                {headerName: "회계종료일", field: "periodEndDate", width: 250},
            ];
            gridOptions3 = {
                columnDefs       : columnDefs,
                rowSelection     : 'single', //row는 하나만 선택 가능
                defaultColDef    : {editable: false}, // 정의하지 않은 컬럼은 자동으로 설정
                onGridReady      : function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                    event.api.sizeColumnsToFit();
                },
                onGridSizeChanged: function (event) { // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
                    event.api.sizeColumnsToFit();
                },
                onRowClicked     : function (event) {
                    console.log("Row선택");
                    console.log(event.data);
                    selectedRow = event.data;
                    $("#fiscalYear").val(selectedRow["fiscalYear"]);
                    $("#accountYearModal").modal("hide");

                    console.log(selectedRow["accountPeriodNo"])
                    dataSet["accountPeriodNo"] = selectedRow["accountPeriodNo"];
                    checkElement();
                }
            }
            accountGrid = document.querySelector('#accountYearGrid');
            new agGrid.Grid(accountGrid, gridOptions3);
            gridOptions3.api.setRowData([]);
        }

        function showAccountPeriod() {

            $.ajax({
                type    : "GET",
                url     : "${pageContext.request.contextPath}/operate/accountperiodlist",
                data    : {},
                dataType: "json",
                async   : false,
                success : function (jsonObj) {
                    console.log(jsonObj);
                    gridOptions3.api.setRowData(jsonObj);
                }
            });

        }

        function createWorkplace() {
            rowData = [];
            var columnDefs = [
                {
                    headerName: "사업장코드", field: "workplaceCode", sort: "asc", width: 200
                },
                {headerName: "사업장명", field: "workplaceName", width: 250},
            ];
            gridOptions4 = {
                columnDefs       : columnDefs,
                rowSelection     : 'single', //row는 하나만 선택 가능
                defaultColDef    : {editable: false}, // 정의하지 않은 컬럼은 자동으로 설정
                onGridReady      : function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                    event.api.sizeColumnsToFit();
                },
                onGridSizeChanged: function (event) { // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
                    event.api.sizeColumnsToFit();
                },
                onRowClicked     : function (event) {
                    console.log("Row선택");
                    console.log(event.data);
                    selectedRow = event.data;
                    showDepartment(selectedRow["workplaceCode"]);
                    console.log(selectedRow["workplaceName"]);

                }
            }
            workplaceGrid = document.querySelector('#workplaceGrid');
            new agGrid.Grid(workplaceGrid, gridOptions4);
            gridOptions4.api.setRowData([]);
        }

        /* ag-Grid 선택된 열의 레코드 반환하는 함수
        function getSelectedRows() {
               var selectedNodes = gridOptions4.api.getSelectedNodes()
               var selectedData = selectedNodes.map( function(node) { return node.data })
               var selectedDataStringPresentation = selectedData.map( function(node) { return node.workplaceName })
               alert('Selected nodes: ' + selectedDataStringPresentation);
           }
        */
        function createDepartment() {
            rowData = [];
            var columnDefs = [
                {
                    headerName: "사업장코드", hide: "true", field: "workplaceCode", sort: "asc", width: 100
                },
                {headerName: "사업장명", hide: "true", field: "workplaceName", width: 250},
                {
                    headerName: "부서코드", field: "deptCode", sort: "asc", width: 200
                },
                {headerName: "부서명", field: "deptName", width: 250},
            ];
            gridOptions5 = {
                columnDefs       : columnDefs,
                rowSelection     : 'single', //row는 하나만 선택 가능
                defaultColDef    : {editable: false}, // 정의하지 않은 컬럼은 자동으로 설정
                onGridReady      : function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                    event.api.sizeColumnsToFit();
                },
                onGridSizeChanged: function (event) { // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
                    event.api.sizeColumnsToFit();
                },
                onRowClicked     : function (event) {
                    console.log("Row선택");
                    console.log(event.data);
                    selectedRow = event.data;
                    $("#workplace").val(selectedRow["workplaceName"]);
                    $("#dept").val(selectedRow["deptName"]);
                    $("#workplaceModal").modal("hide");

                    console.log(selectedRow["deptName"])
                    dataSet["workplaceCode"] = selectedRow["workplaceCode"];
                    dataSet["deptCode"] = selectedRow["deptCode"];
                    checkElement();
                }
            }
            deptGrid = document.querySelector('#deptGrid');
            new agGrid.Grid(deptGrid, gridOptions5);
            gridOptions5.api.setRowData([]);
        }

        function showWorkplace() {
            $.ajax({
                type    : "GET",
                url     : "${pageContext.request.contextPath}/operate/deptlist",
                data    : {},
                dataType: "json",
                async   : false,
                success : function (jsonObj) {
                    console.log(jsonObj);
                    gridOptions4.api.setRowData(jsonObj);
                }
            });
        }

        function showDepartment(workplaceCode) {
            $.ajax({
                type    : "GET",
                url     : "${pageContext.request.contextPath}/operate/detaildeptlist",
                data    : {
                    "workplaceCode": workplaceCode,
                },
                dataType: "json",
                async   : false,
                success : function (jsonObj) {
                    console.log(jsonObj);
                    gridOptions5.api.setRowData(jsonObj);
                }
            });
        }

        function createParentBudget() {
            rowData = [];
            var columnDefs = [
                {
                    headerName: "계정과목 코드", field: "accountInnerCode", sort: "asc", width: 150
                },
                {headerName: "계정과목", field: "accountName", width: 200},
                {
                    headerName: "누계예산대비실적",
                    children  : [
                        {headerName: "실적", field: "abr", width: 120},
                        {headerName: "예산", field: "annualBudget", width: 120},
                        {headerName: "잔여예산", field: "remainingBudget", width: 120},
                        {headerName: "집행율(%)", field: "budgetExecRate", width: 120},
                    ],
                },
                {
                    headerName: "당월예산대비실적",
                    children  : [
                        {headerName: "실적", field: "ambr", width: 120},
                        {headerName: "예산", field: "budget", width: 120},
                        {headerName: "잔여예산", field: "remainingMonthBudget", width: 120},
                        {headerName: "집행율(%)", field: "monthBudgetExecRate", width: 120},
                    ],
                },
            ];
            gridOptions = {
                columnDefs            : columnDefs,
                rowSelection          : 'single', //row는 하나만 선택 가능
                defaultColDef         : {editable: false}, // 정의하지 않은 컬럼은 자동으로 설정
                onGridReady           : function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                    event.api.sizeColumnsToFit();
                },
                onGridSizeChanged     : function (event) { // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
                    event.api.sizeColumnsToFit();
                },
                onRowClicked          : function (event) {
                    console.log("Row선택");
                    console.log(event.data);
                    selectedRow = event.data;
                    dataSet["accountInnerCode"] = selectedRow["accountInnerCode"];
                    showComparisonBudget(dataSet);

                },
                setPinnedBottomRowData: function (data) {
                    return null;
                },
            }
            accountGrid = document.querySelector('#parentBudgetGrid');
            new agGrid.Grid(accountGrid, gridOptions);
            gridOptions.api.setRowData([]);
        }

        function createDetailBudget() {
            rowData = [];
            var columnDefs = [
                {headerName: "구분", field: "budgetDate", sort: "none", width: 100},
                {headerName: "신청예산", field: "appBudget", width: 100},
                {headerName: "편성예산", field: "orgBudget", width: 100},
                {headerName: "집행실정", field: "execPerform", width: 100},
                {headerName: "예실대비", field: "budgetAccountComparison", width: 100},
            ];
            gridOptions2 = {

                columnDefs       : columnDefs,
                rowSelection     : 'single', //row는 하나만 선택 가능
                defaultColDef    : {editable: false}, // 정의하지 않은 컬럼은 자동으로 설정
                onGridReady      : function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                    event.api.sizeColumnsToFit();

                },
                getRowStyle: params => {       // 분기별로
                    if ((params.node.rowIndex+1) % 4  === 0 && params.node.rowIndex  != 0) {
                        return { background: 'aliceblue' };
                    }
                },
                onGridSizeChanged: function (event) { // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
                    event.api.sizeColumnsToFit();
                },
                onRowClicked     : function (event) {
                    console.log("Row선택");
                    selectedRow = event.data;

                }


            }
            accountDetailGrid = document.querySelector('#detailBudgetGrid');
            new agGrid.Grid(accountDetailGrid, gridOptions2);
            gridOptions2.api.setRowData([]);
        }

        function sum_budgetStatus(jsonObj) {  //합계 그리드 생성 하는 메서드
            let sum_abr = 0;
            let sum_annualBudget = 0;
            let sum_remainingBudget = 0;


            let sum_ambr = 0;
            let sum_budget = 0;
            let sum_remainingMonthBudget = 0;

            for (let b = 0; b < jsonObj["budgetStatus"].length; b++) {
                sum_abr = sum_abr + jsonObj["budgetStatus"][b].abr;
                sum_annualBudget = sum_annualBudget + jsonObj["budgetStatus"][b].annualBudget;
                sum_remainingBudget = sum_remainingBudget  + jsonObj["budgetStatus"][b].remainingBudget;
                sum_ambr = sum_ambr + jsonObj["budgetStatus"][b].ambr;
                sum_budget = sum_budget + jsonObj["budgetStatus"][b].budget;
                sum_remainingMonthBudget = sum_remainingMonthBudget + jsonObj["budgetStatus"][b].remainingMonthBudget;
            }
            gridOptions.api.setPinnedBottomRowData([{
                accountInnerCode: "합계",
                accountName     : null,
                abr             : sum_abr,
                annualBudget : sum_annualBudget,
                remainingBudget : sum_remainingBudget,
                budgetExecRate :  sum_annualBudget == null?"-" : ((sum_abr/sum_annualBudget)*100).toFixed(3),     //(sum_abr/sum_annualBudget)*100,
                ambr             : sum_ambr,
                budget : sum_budget,
                remainingMonthBudget : sum_remainingMonthBudget,
                monthBudgetExecRate : sum_budget == 0 ? "-" : ((sum_ambr/sum_budget)*100).toFixed(3)
            }])
        }

        function callBudgetStatus() {

            $.ajax({
                type    : "GET",
                url     : "${pageContext.request.contextPath}/budget/budgetstatus",
                data    : {
                    "budgetObj": JSON.stringify(dataSet)
                },
                dataType: "json",
                async   : false,
                success : function (jsonObj) {
                    console.log("callBudgetStatus: ", jsonObj);
                    gridOptions.api.setRowData(jsonObj["budgetStatus"]);
                    sum_budgetStatus(jsonObj);  //합계 그리드
                }
            });

        }

        function showDetailBudget(code) {
            console.log(code);

            $.ajax({
                type    : "GET",
                url     : "${pageContext.request.contextPath}/operate/detailbudgetlist",
                data    : {
                    "code": code
                },
                dataType: "json",
                async   : false,
                success : function (jsonObj) {
                    console.log(jsonObj);
                    gridOptions2.api.setRowData(jsonObj);
                }
            });

        }

        function checkElement() {
            if ($("#fiscalYear").val() && $("#workplace").val() && $("#dept").val())
                callBudgetStatus();
        }

        function showComparisonBudget(dataSet) {
            console.log("dataSet :" +JSON.stringify(dataSet));
            $.ajax({
                type    : "GET",
                url     : "${pageContext.request.contextPath}/budget/comparisonBudget",
                data    : {
                    "budgetObj": JSON.stringify(dataSet)
                },
                dataType: "json",
                async   : false,
                success : function (jsonObj) {
                    console.log("jsonObj.RESULT :"+ jsonObj.RESULT);
                    var result = jsonObj.RESULT
                    for (a=0;a < result.length; a++) {
                        console.log(result[a])
                        if(result[a].appBudget == null){
                            result[a].appBudget = 0
                        }else{
                            result[a].appBudget = numToMoney(result[a].appBudget+"")
                        }
                        if(result[a].orgBudget == null){
                            result[a].orgBudget = 0
                        }else{
                            result[a].orgBudget = numToMoney(result[a].orgBudget+"")
                        }
                        if(result[a].execPerform == null){
                            result[a].execPerform = 0
                        }else{
                            result[a].execPerform = numToMoney(result[a].execPerform+"")
                        }
                        if(result[a].budgetAccountComparison == null){
                            result[a].budgetAccountComparison = 0
                        }else{
                            result[a].budgetAccountComparison = numToMoney(result[a].budgetAccountComparison+"")
                        }
                    }
                    gridOptions2.api.setRowData(result);
                }
            });
        }
        function numToMoney(value){//10000

            var length=value.length;//길이
            var valueArray=value.split("");//빈공간 ""을 기준으로 잘라서 배열에 넣음->모든숫자가 다 잘림 100-> 1/0/0
            var strBuffer=[];//빈배열
            for(var i in valueArray){//배열이 가지고 있는 인덱스만큼 가져오겠다
                if((i-3)%3==0&&i!=0) strBuffer.unshift(",");//세글자마다,이붙음
                strBuffer.unshift(value[length-1-i]);//배열 앞에 요소추가
            }
            value=strBuffer.join("");//자른값이 붙어짐
            return value;
        }
        function qRefresh() {
            var num = 0;
            for (var i = 1; i <= 12; i++) {
                var input = document.querySelector("#m" + i);
                num += parseInt(input.value.split(",").join(""));
                if (i % 3 == 0) {
                    var q = document.querySelector("#q" + i / 3);
                    q.value = numToMoney(num + "");
                    num = 0;
                }
            }
        }

        function checkNum() {
            this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1').replace(/(^0+)/, "");
            var length = this.value.length;
            var value = this.value.split("");
            console.log(value);
            var strBuffer = [];
            for (var i in value) {
                if ((i - 3) % 3 == 0 && i != 0) strBuffer.unshift(",");
                strBuffer.unshift(value[length - 1 - i]);
            }
            this.value = strBuffer.join("");
            console.log("checkNum: " + this.value);
        }

    </script>
    <title>예산대비실적현황</title>
</head>
<body>
<h4>예산대비실적현황</h4>
<hr>
<div class="row">
    <div class="col-sm-4 mb-3 mb-sm-0 input-group">
        <label for="example-text-input" class="col-form-label">회계연도</label>
        <input style="margin-left: 5px" type="text" class="border-0 small form-control form-control-user"
               id="fiscalYear" placeholder="fiscalYear" disabled="disabled">

        <div class="input-group-append">
            <button class="btn btn-primary" type="button" data-toggle="modal"
                    data-target="#accountYearModal" id="searchPeriod">
                <i class="fas fa-search fa-sm"></i>
            </button>
        </div>
    </div>

    <div class="col-sm-4 mb-3 mb-sm-0 input-group">
        <label for="example-text-input" class="col-form-label">사업장</label>
        <input style="margin-left: 5px" type="text" class="border-0 small form-control form-control-user" id="workplace"
               placeholder="workplace" disabled="disabled">

        <div class="input-group-append">
            <button title="사업장, 부서 검색" class="btn btn-primary" type="button" data-toggle="modal"
                    data-target="#workplaceModal" id="searchWorkplace">
                <i class="fas fa-search fa-sm"></i>
            </button>
        </div>
    </div>
    <div class="col-sm-3 mb-3 mb-sm-0 input-group">
        <label for="example-text-input" class="col-form-label">부서</label>
        <input style="margin-left: 5px" type="text" class="border-0 small form-control form-control-user" id="dept"
               placeholder="부서명" disabled="disabled">

        <!--  부서 검색 버튼
                          <div class="input-group-append">
                              <button class="btn btn-primary" type="button" data-toggle="modal"
                                  data-target="#deptModal" id="searchDept">
                                  <i class="fas fa-search fa-sm"></i>
                              </button>
                          </div>
                        </div>

        -->
    </div>
    <hr>
    <!--
<table style="width:100%;">
<tr>
<td>
<div align="left" style="padding:10px;">
<div align="center">
<div id="parentBudgetGrid" class="ag-theme-balham"  style="height:250px;width:auto;" ></div>
</div>
</div>
</td>
<td>
<div align="right" style="padding:10px;">
<div align="center">
<div id="detailBudgetGrid" class="ag-theme-balham" style="height:250px;width:auto;"></div>
</div>
</div>
</td>
</tr>
</table>
-->
    <div style="width:100%;">
        <hr>
    </div>
    <hr>
    <br>
    <div align="center" style="float:left; width:100%;">
        <div align="center">
            <div id="parentBudgetGrid" class="ag-theme-balham"
                 style="margin-right:10px;height:250px;width:auto%;"></div>
        </div>
    </div>


    <div style="width:100%;">
        <hr>
    </div>
    <div align="center" style="float:right; width:100%;">
        <div align="center">
            <div id="detailBudgetGrid" class="ag-theme-balham" style="height:350px;width:80%;"></div>
        </div>
    </div>


    <div align="center" class="modal fade" id="accountYearModal" tabindex="-1"
         role="dialog" aria-labelledby="accountLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="accountYearModal">회계연도</h5>
                    <button class="close" type="button" data-dismiss="modal"
                            aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <hr>
                <div class="modal-body">
                    <div style="float: center; width: 100%;">
                        <div align="center">
                            <div id="accountYearGrid" class="ag-theme-balham"
                                 style="height: 400px; width: auto;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div align="left" class="modal fade" id="workplaceModal" tabindex="-1"
         role="dialog" aria-labelledby="workplaceLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content" align="left" style="width:600px; height:100%;"> <!-- 모달 크기 조절 -->
                <div class="modal-header">
                    <h5 class="modal-title" id="workplaceModal">사업장, 부서</h5>
                    <button class="close" type="button" data-dismiss="modal"
                            aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <hr>
                <div class="modal-body">
                    <div style="float: left; width: 50%;">
                        <div align="center">
                            <div id="workplaceGrid" class="ag-theme-balham"
                                 style="height: 400px; width: auto;"></div>
                        </div>
                    </div>
                    <div style="float: left; width: 50%;">
                        <div align="center">
                            <div id="deptGrid" class="ag-theme-balham"
                                 style="height: 400px; width: auto;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div align="center" class="modal fade" id="deptModal" tabindex="-1"
         role="dialog" aria-labelledby="deptLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deptModal">부서</h5>
                    <button class="close" type="button" data-dismiss="modal"
                            aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <hr>
                <div class="modal-body">
                    <div style="float: left; width: 50%;">
                        <div align="center">
                            <div id="parentDeptGrid" class="ag-theme-balham"
                                 style="height: 400px; width: auto;"></div>
                        </div>
                    </div>
                    <div style="float: left; width: 50%;">
                        <div align="center">
                            <div id="detailDeptGrid" class="ag-theme-balham"
                                 style="height: 400px; width: auto;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
