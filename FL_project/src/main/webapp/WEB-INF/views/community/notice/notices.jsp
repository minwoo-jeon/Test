<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

<style>
@font-face {
    font-family: 'NanumSquareNeo-Variable';
    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_11-01@1.0/NanumSquareNeo-Variable.woff2') format('woff2');
    font-weight: normal;
    font-style: normal;
}

#noticeTop h1{
	color: aliceblue;
    font-family: 'NanumSquareNeo-Variable';
}

#noticeMenu{
	margin: auto;
}

p.board {
	font-size: 2em;
}
p.sort{
	font-size: 1.5em;
}
p.board, p.board a, p.sort, p.sort a{
    color: aliceblue;
    font-family: 'NanumSquareNeo-Variable';
}

#list h2{
	margin:auto;
}

div.notices{
	width:80%;
	margin:auto;
}
div.notices div{
	float:left;
}
div.notices div.image{
	width:7%;
}
div.notices div.image img{
	width:100%;
}
div.notices div.title{
	width:83%;
	padding-left:10px;
}
div.notices div.etc{
	width:10%;
}
div.notices div.etc *{
	display:inline-block;
}

span.nickname, span.readnum{
	color: gray;
}

p.click{
	color:gray;
	cursor:pointer;
}

#pagination ul{
	margin:auto;
}
</style>

<script>
	$(function(){
		getNotices(${pageId});
	});
	
	const getNotices = function(pageId){
		$.ajax({
			type:"post",
			url:"/community/notice/getNotices?pageId="+pageId,
			dataType:"json",
			cache:false,
		}).done((res)=>{
			showList(res.items);
			showPage(res.pageNavi, res.totalCount, res.pageId, res.pageCount);
		}).fail((err)=>{
			alert("error: "+err.status);
		});
	};
	
	const showList = function(arr){
		let str = "";
		if(arr.length == 0){
			str += "<h2>공지가 없습니다</h2>";
		}
		else{
			$.each(arr, (i, notice)=>{
				str += "<div class='bg-white rounded shadow-sm p-4 mb-5 pb-3 notices'>";
				str += "<div class='image'>";
				str += "<a href='/community/notice/"+notice.notice_id+"'>";
				str += "<img src='"+notice.notice_image+"'>";
				str += "</a>";
				str += "</div>";
				str += "<div class='title'>";
				str += "<a href='/community/notice/"+notice.notice_id+"'>";
				str += "<h4>";
				str += "[공지] "+notice.notice_content;
				str += "</h4>";
				str += "<span class='nickname'>";
				str += notice.notice_nickname;
				str += "</span>";
				str += "</a>";
				str += "</div>";
				str += "<div class='etc'>";
				str += "<c:if test='${user ne null and user.state eq 3}'>";
				str += "<p class='click' onclick='location.href=\"/community/notice/"+notice.notice_id+"/edit\"'>수정";
				str += "</p> | ";
				str += "<p class='click' onclick='delNotice(\""+notice.notice_id+"\")'>삭제";
				str += "</p><br>";
				str += "</c:if>";
				str += notice.notice_date1+"<br>";
				str += "<span class='readnum'>";
				str += "조회수: "+notice.notice_readnum;
				str += "</span>";
				str += "</div>";
				str += "</div>";
			});
		}
		$("#list").html(str);
	};
	
	const showPage = function(pageNavi, totalCount, pageId, pageCount){
		let str = pageNavi;
		/* str += "총 게시글수: <span class='text-primary'>";
		str += totalCount+"개";
		str += "</span><br>";
		str += "<span class='text-danger'>";
		str += pageId;
		str += "</span>/";
		str += pageCount+"pages"; */
		
		$("#pagination").html(str);
	};
	
	const delNotice = function(id){
		$.ajax({
			type:"delete",
			url:"/community/notice/"+id+"/del",
			dataType:"json",
			cache:false,
		}).done((res)=>{
			if(res.result == "fail"){
				alert("공지 삭제 실패");
			}
			
			getNotices(${pageId});
		}).fail((err)=>{
			alert("error: "+err.status);
		});
	};
</script>
<div class="row mt-3">
	<div id="noticeTop" class="col-12 text-center">
		<h1>공지사항</h1>
	</div>
	<div class="col-10" id="noticeMenu">
		<p class="board float-left">
			<a href="/community">리뷰</a> | <a href="/community/notice">공지사항</a>
		</p>
		<c:if test="${user ne null and user.state eq 3}">
			<button class="btn btn-primary float-right mr-3" id="write" name="write" 
				onclick="location.href='/community/notice/write'">공지쓰기</button>
		</c:if>
	</div>
</div>
<div class="row mb-3" id="list"></div>
<div class="row text-center" id="pagination"></div>
